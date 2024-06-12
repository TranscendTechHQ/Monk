import datetime as dt
import logging
import re
from fastapi import APIRouter, Body, Depends
from fastapi import status, Request
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from slack_sdk import WebClient
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.thirdparty.asyncio import get_user_by_id
from routes.threads.block import updateBlock
from routes.threads.user_flags import set_flags_true_other_users
from routes.threads.child_thread import create_new_thread
from routes.threads.models import CreateBlockModel
from routes.threads.routers import create_new_block
from routes.slack.models import ChannelModel, CompositeChannelList, PublicChannelList, SlackEventModel, SlackEventVerificationRequestModel, SubscribeChannelRequest, SubscribedChannelList
from utils.db import asyncdb, get_block_by_id, update_mongo_document_fields
from utils.slack.slack_channel_messages import convert_unix_timestamp_to_iso_string, get_channel_list, update_third_party_user_info

router = APIRouter()
logger = logging.getLogger(__name__)


async def get_public_channel_list():
    doc = await asyncdb.tenants_collection.find_one({"tenant_name": "Monk"})
    if doc is None:
        return
    SLACK_USER_TOKEN = doc["user_token"]
    slack_client = WebClient(token=SLACK_USER_TOKEN)
    public_channels_list = get_channel_list(slack_client=slack_client)
    return public_channels_list


# get blocks given a date
@router.get("/channel_list", response_model=CompositeChannelList,
            response_description="Get a list of public and subscribed channels")
async def ch(request: Request,
             session: SessionContainer = Depends(verify_session())
             ):
    # get user id from session
    user_id = session.get_user_id()
    subscribed_channel_collection = asyncdb.subscribed_channels_collection
    subscribed_channels = await subscribed_channel_collection.find_one({"_id": user_id})
    if subscribed_channels is None:
        subscribed_channels = {"_id": user_id, "subscribed_channels": []}
    public_channels = await get_public_channel_list()
    composite_channels = CompositeChannelList(
        id=subscribed_channels['_id'],
        public_channels=public_channels.public_channels,
        subscribed_channels=subscribed_channels['subscribed_channels'])
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(composite_channels))


@router.post("/subscribe_channel", response_model=SubscribedChannelList)
async def subscribe_channel(request: Request,
                            channels_to_subscribe: SubscribeChannelRequest = Body(
                                ...),
                            session: SessionContainer = Depends(
                                verify_session())
                            ):
    # get user id from session
    user_id = session.get_user_id()
    subscribed_channel_collection = asyncdb.subscribed_channels_collection
    public_channels_list = await get_public_channel_list()
    subscribed_channels_list: list[ChannelModel] = []
    for channel_id in channels_to_subscribe.channel_ids:
        for channel in public_channels_list.public_channels:
            if channel.id == channel_id:
                subscribed_channels_list.append(ChannelModel(
                    id=channel.id, name=channel.name, creator=channel.creator, created_at=channel.created_at))
    print(subscribed_channels_list)
    new_item = SubscribedChannelList(id=user_id,
                                     subscribed_channels=subscribed_channels_list)
    subscribed_channels = await subscribed_channel_collection.replace_one(
        filter={"_id": user_id},
        replacement=jsonable_encoder(new_item),
        upsert=True)

    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(new_item))
    # content=new_item.model_dump_json()) #this returns id instead of _id in json


# Slack event webhook
@router.post("/webhook_event",)
async def webhook_event(request: Request):
    try:
        json = await request.json()

        # check if the request is a verification request
        if (json.get('challenge')):
            model = SlackEventVerificationRequestModel(**json)
            print("\n [WEBHOOK] 👉 Received verification")
            return JSONResponse(status_code=status.HTTP_200_OK,
                                content=jsonable_encoder({'challenge': json.get('challenge')}))

        model = SlackEventModel(**json)
        print("\n [WEBHOOK] 👉 Received event")
        print("\n")
        print(
            f'\n [WEBHOOK] 👉 Event: {model.event.subtype}, Content: {model.event.text}')
        print("\n")
        print(json)

        if model.event.type != 'message':
            print(
                f"\n  [WEBHOOK] 👉 Event Type: ${model.event.type} Subtype: ${model.event.subtype}")
            return JSONResponse(status_code=status.HTTP_200_OK,
                                content=jsonable_encoder({'Received': True}))

        if model.event.subtype == 'message_deleted':
            await delete_block(model)
            return JSONResponse(status_code=status.HTTP_200_OK,
                                content=jsonable_encoder({'Received': True}))
        threadReply = model.event.message

        tenants_collection = asyncdb.tenants_collection
        tenants = await tenants_collection.find({
            'tenant_id': model.team_id
        }).to_list(length=None)
        tenant = tenants[0] if tenants else None

        if not tenant:
            print(
                f"\n [WEBHOOK] ❌ Tenant not found for team_id: {model.team_id}")
            return JSONResponse(status_code=status.HTTP_200_OK,
                                content=jsonable_encoder({'Received': True}))
        SLACK_USER_TOKEN = tenant["user_token"]
        SLACK_BOT_TOKEN = tenant["bot_token"]

        # Create a Slack client instance
        print("\n [WEBHOOK] 👉 Creating Slack client...")
        slack_client = WebClient(token=SLACK_USER_TOKEN)
        slack_client_for_user_info = WebClient(token=SLACK_BOT_TOKEN)

        if threadReply and model.event.subtype == 'message_changed':
            await update_child_thread(model, slack_client_for_user_info)
            return JSONResponse(status_code=200, content=jsonable_encoder({'Received': True}))

        tenant_id = model.team_id
        print("\n 👉 Tenant found in Db successfully.")

        # Get the channel info
        print("\n [WEBHOOK] 👉 Getting channel info...")
        channel_list = get_channel_list(slack_client)

        channel: ChannelModel = None
        for ch in channel_list.public_channels:
            if ch.id == model.event.channel:
                channel = ch
                break

        if not channel:
            print(
                f"\n [WEBHOOK] ❌ Channel not found for channel_id: {model.event.channel}")
            return JSONResponse(status_code=status.HTTP_200_OK,
                                content=jsonable_encoder({'Received': True}))
        print("\n 👉 Channel info fetched successfully.")

        # Get the user info
        print("\n [WEBHOOK] 👉 Fetching user from db")
        # get or create user with slack user ID who created the channel
        user = await update_third_party_user_info(model.event.user, tenant_id, slack_client_for_user_info)

        # create threads for each public channel
        thread_type = "slack"
        user_id = user["_id"]
        thread_title = channel.name
        block_id = model.event.client_msg_id
        createdAt = convert_unix_timestamp_to_iso_string(model.event.ts)

        print("\n [WEBHOOK] 👉 Creating new thread")
        # create a new thread
        new_thread = await create_new_thread(user_id=user_id, tenant_id=tenant_id, topic=thread_title,
                                             thread_type=thread_type, created_at=channel.created_at)

        print("\n [WEBHOOK] 👉 Thread created successfully")
        print("\n [WEBHOOK] 👉 Thread ID: ", new_thread["_id"])
        main_thread_id = new_thread["_id"]

        # Check if there is a slack user mentioned in the content
        content = await replaceSlackUSerIdsToMonkMentionLink(model.event.text, tenant_id)

        print("\n [WEBHOOK] 👉 Creating block instance")
        new_block = CreateBlockModel(
            content=content, main_thread_id=main_thread_id)

        created_block = create_new_block(block=new_block,
                                               user_id=user_id,
                                               tenant_id=tenant_id,
                                               id=block_id,
                                               created_at=createdAt)
        print("\n [WEBHOOK] ✅ Block created successfully")
        # print("\n 👉 Block ID: ", created_block["_id"])

        return JSONResponse(status_code=status.HTTP_200_OK,
                            content=jsonable_encoder({'Received': True}))
    except Exception as e:
        logger.error(e, exc_info=True)
        return JSONResponse(status_code=200, content=jsonable_encoder({'Received': True}))

# function to update the child thread


async def update_child_thread(model: SlackEventModel, slack_client_for_user_info: WebClient):
    print(
        f"\n [WEBHOOK] 👉 Initiate Update block")
    try:
        tenant_id = model.team_id
        threadReply = model.event.message

        # Check foe the slack user mention
        newText = await replaceSlackUSerIdsToMonkMentionLink(threadReply.text, tenant_id)
        print("\n [WEBHOOK] 👉 New text: ", newText)
        block_id = model.event.message.client_msg_id
        # updatedAt = convert_unix_timestamp_to_iso_string(model.event.ts)

        block_collection = asyncdb.blocks_collection
        # get the block from the db
        block_in_db = await get_block_by_id(block_id, block_collection)

        if not block_in_db:
            print(
                f"\n [WEBHOOK] ❌ Block not found for block_id: {block_id}")
            raise Exception('Block not found in DB')

        # Get the user info
        print("\n [WEBHOOK] 👉 Fetching user from db")
        # get or create user with slack user ID who created the channel
        user = await update_third_party_user_info(model.event.user, tenant_id, slack_client_for_user_info)

        # create threads for each public channel
        user_id = user["_id"]

        updated_block = await updateBlock(block_in_db, user_id, tenant_id, newText, None)
        if not updated_block:
            print(
                f"\n [WEBHOOK] ❌ Block not updated for block_id: {block_id}")

        else:
            print("\n [WEBHOOK] ✅ Block updated in DB")
        return JSONResponse(status_code=status.HTTP_200_OK,
                            content=jsonable_encoder({'Received': True}))
    except Exception as e:
        logger.error(e, exc_info=True)
        return JSONResponse(status_code=200, content=jsonable_encoder({'Received': True}))


async def delete_block(model: SlackEventModel):
    try:
        block_id = model.event.previous_message.client_msg_id
        if (not block_id):
            print(
                f"\n [WEBHOOK] ❌ Block not found for block_id: {block_id}")
            return JSONResponse(status_code=200, content=jsonable_encoder({'Received': True}))
        tenant_id = model.team_id
        block_collection = asyncdb.blocks_collection
        res = await block_collection.delete_one({"_id": block_id, 'tenant_id': tenant_id})
        print(f"\n [WEBHOOK] 👉 RES: ${res}")

        print(f"\n [WEBHOOK] ✅ Block deleted successfully. ID: ${block_id}")
        return JSONResponse(status_code=status.HTTP_200_OK,
                            content=jsonable_encoder({'Received': True}))
    except Exception as e:
        logger.error(e, exc_info=True)
        return JSONResponse(status_code=200, content=jsonable_encoder({'Received': True}))


# Detect the slack user mention in the content if available in <@user_id> format
# Extract all the slack user ids mentioned in the content and fetch the user info from the slack and create a user in the db if not exists
# if user exists then change the mentioned user format to Monk user link format [user_name](@mention?user=user_id)
# and update the content with the new format
# This is done to make the user mention clickable in the frontend
async def replaceSlackUSerIdsToMonkMentionLink(content: str, tenant_id: str):
    try:
        slackUserIds = re.findall(r'<@([A-Z0-9a-z]+)>', content)
        if (not slackUserIds or len(slackUserIds) == 0):
            return content

        tenants = await asyncdb.tenants_collection.find({
            'tenant_id': tenant_id
        }).to_list(length=None)
        tenant = tenants[0] if tenants else None

        SLACK_BOT_TOKEN = tenant["bot_token"]
        slack_client_for_user_info = WebClient(token=SLACK_BOT_TOKEN)

        if slackUserIds:
            print("\n [WEBHOOK] 👉 Found Slack User IDs: ", slackUserIds)
            # get or create user with slack user ID who created the channel
            for slackUserId in slackUserIds:
                user = await update_third_party_user_info(
                    slackUserId, 'tenant_id', slack_client_for_user_info)
                if user:
                    content = content.replace(
                        f'<@{slackUserId}>', f'[{user["name"]}](mention?user={user["_id"]})')
        return content
    except Exception as e:
        logger.error(e, exc_info=True)
        return content
