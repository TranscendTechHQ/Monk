from fastapi import APIRouter, Body, Depends
from fastapi import status, Request
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from slack_sdk import WebClient
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.thirdparty.asyncio import get_user_by_id
from routes.slack.models import ChannelModel, CompositeChannelList, PublicChannelList, SubscribeChannelRequest, SubscribedChannelList
from utils.db import asyncdb
from utils.slack.slack_channel_messages import get_channel_list

router = APIRouter()

async def get_public_channel_list():
    doc = await asyncdb.tenants_collection.find_one({"tenant_name": "Monk"})
    if doc is None:
        return
    SLACK_USER_TOKEN = doc["user_token"]
    slack_client = WebClient(token=SLACK_USER_TOKEN)
    public_channels_list = get_channel_list(slack_client=slack_client)
    return public_channels_list

@router.get("/public_channels", response_model=PublicChannelList,
            response_description="Get all public channels")
async def public_channels(request: Request,
                          session: SessionContainer = Depends(verify_session())
                         ):
    # get user id from session
    #user_id = session.get_user_id()
    
    public_channels_list = await get_public_channel_list()
    return JSONResponse(status_code=status.HTTP_200_OK, 
                        content=jsonable_encoder(public_channels_list))
    

# get blocks given a date
@router.get("/channel_list", response_model=CompositeChannelList,
            response_description="Get all blocks for a given date")
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
        id = subscribed_channels['_id'],
        public_channels=public_channels.public_channels, 
        subscribed_channels=subscribed_channels['subscribed_channels'])
    return JSONResponse(status_code=status.HTTP_200_OK, 
                        content=jsonable_encoder(composite_channels))
    
@router.post("/subscribe_channel", response_model=SubscribedChannelList)
async def subscribe_channel(request: Request,
                            channels_to_subscribe: SubscribeChannelRequest = Body(...),
                            session: SessionContainer = Depends(verify_session())
                            ):
    # get user id from session
    user_id = session.get_user_id()
    subscribed_channel_collection = asyncdb.subscribed_channels_collection
    public_channels_list = await get_public_channel_list()
    subscribed_channels_list:list[ChannelModel] = []
    for channel_id in channels_to_subscribe.channel_ids:
        for channel in public_channels_list.public_channels:
            if channel.id == channel_id:
                subscribed_channels_list.append(ChannelModel(id=channel.id, name=channel.name))
    print(subscribed_channels_list)
    new_item = SubscribedChannelList(id=user_id, 
                                     subscribed_channels=subscribed_channels_list)
    subscribed_channels = await subscribed_channel_collection.replace_one(
        filter={"_id": user_id},
        replacement=jsonable_encoder(new_item),
        upsert=True)
    
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(new_item))
                        #content=new_item.model_dump_json()) #this returns id instead of _id in json
    