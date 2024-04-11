from fastapi import APIRouter, Body, Depends
from fastapi import status, Request
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from slack_sdk import WebClient
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.thirdparty.asyncio import get_user_by_id
from routes.slack.models import CompositeChannelList, PublicChannelList
from utils.db import asyncdb
from utils.slack.slack_channel_messages import get_channel_list

router = APIRouter()

@router.get("/public_channels", response_model=PublicChannelList,
            response_description="Get all public channels")
async def public_channels(request: Request,
                          #session: SessionContainer = Depends(verify_session())
                         ):
    # get user id from session
    #user_id = session.get_user_id()
    print("Fetching tenant...")
    doc = await asyncdb.tenants_collection.find_one({"tenant_name": "Monk"})
    if doc is None:
        print("No tenant found")
        return
    print("Tenant found successfully.")
    SLACK_USER_TOKEN = doc["user_token"]
    slack_client = WebClient(token=SLACK_USER_TOKEN)
    public_channels_list = get_channel_list(slack_client=slack_client)
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
        return JSONResponse(status_code=status.HTTP_404_NOT_FOUND, content="No subscribed channels found")
    public_channels = get_channel_list()
    composite_channels = CompositeChannelList(
        public_channels=public_channels, 
        subscribed_channels=subscribed_channels)
    return JSONResponse(status_code=status.HTTP_200_OK, 
                        content=jsonable_encoder(composite_channels))