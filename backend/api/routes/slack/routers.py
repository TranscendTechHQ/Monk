import logging
from fastapi import APIRouter, Body, Depends
from fastapi import status, Request
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from slack_sdk import WebClient
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.thirdparty.asyncio import get_user_by_id
from routes.threads.child_thread import create_new_thread
from routes.threads.models import CreateBlockModel
from routes.threads.routers import create_new_block
from routes.slack.models import ChannelModel, CompositeChannelList, PublicChannelList, SlackEventModel, SlackEventVerificationRequestModel, SubscribeChannelRequest, SubscribedChannelList
from utils.db import asyncdb
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

# slack webhook verification


@router.post("/webhook_event-test",)
async def webhook_event(request: Request):
    json = await request.json()
    model = SlackEventVerificationRequestModel(**json)
    print("\n 👉 Received verification")
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder({'challenge': model.challenge}))


# Slack event webhook
@router.post("/webhook_event",)
async def webhook_event(request: Request):
    try:
        json = await request.json()
        model = SlackEventModel(**json)
        print("\n [WEBHOOK] 👉 Received verification")
        print("\n")
        print(model.model_dump())
        print("\n")

        if model.event.type != 'message' or model.event.subtype == 'message_deleted' or model.event.subtype == 'message_changed':
            print(
                f"\n  [WEBHOOK] 👉 Event Type: ${model.event.type} Subtype: ${model.event.subtype}")
            return JSONResponse(status_code=status.HTTP_200_OK,
                                content=jsonable_encoder({'Received': True}))

        tenants_collection = asyncdb.tenants_collection
        threads_collection = asyncdb.threads_collection
        tenants = await tenants_collection.find({
            'tenant_id': model.team_id
        }).to_list(length=None)
        tenant = tenants[0] if tenants else None

        if not tenant:
            print(
                f"\n [WEBHOOK] ❌ Tenant not found for team_id: {model.team_id}")
            return JSONResponse(status_code=status.HTTP_200_OK,
                                content=jsonable_encoder({'Received': True}))

        tenant_id = model.team_id
        print("\n 👉 Tenant found in Db successfully.")
        SLACK_USER_TOKEN = tenant["user_token"]
        SLACK_BOT_TOKEN = tenant["bot_token"]

        # Create a Slack client instance
        print("\n [WEBHOOK] 👉 Creating Slack client...")
        slack_client = WebClient(token=SLACK_USER_TOKEN)
        slack_client_for_user_info = WebClient(token=SLACK_BOT_TOKEN)
        print("👉 Slack client created successfully.")

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
        new_thread = await create_new_thread(user_id=user_id, tenant_id=tenant_id, title=thread_title,
                                             thread_type=thread_type, created_at=channel.created_at)

        print("\n [WEBHOOK] 👉 Thread created successfully")
        print("\n [WEBHOOK] 👉 Thread ID: ", new_thread["_id"])
        main_thread_id = new_thread["_id"]

        current_slack_thread_id = ""
        current_thread_id = {}

        print("\n [WEBHOOK] 👉 Creating block instance")
        new_block = CreateBlockModel(
            content=model.event.text, main_thread_id=main_thread_id)

        print("\n 👉 Creating block")
        created_block = await create_new_block(block=new_block,
                                               user_id=user_id,
                                               tenant_id=tenant_id,
                                               id=block_id,
                                               created_at=createdAt)
        print("\n [WEBHOOK] 👉 Block created successfully")
        # print("\n 👉 Block ID: ", created_block["_id"])

        return JSONResponse(status_code=status.HTTP_200_OK,
                            content=jsonable_encoder({'Received': True}))
    except Exception as e:
        logger.error(e, exc_info=True)
        return JSONResponse(status_code=200, content=jsonable_encoder({'Received': True}))
