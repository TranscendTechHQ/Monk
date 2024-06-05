from typing import Any, List, Optional
from pydantic import BaseModel, ConfigDict, Field


class ChannelModel(BaseModel):
    id: str
    name: str
    creator: str
    created_at: str


class PublicChannelList(BaseModel):
    public_channels: list[ChannelModel]


class SubscribedChannelList(BaseModel):
    id: str = Field(..., alias="_id")
    subscribed_channels: list[ChannelModel]
    model_config = ConfigDict(populate_by_name=True,
                              alias_generator=None,)


class CompositeChannelList(PublicChannelList, SubscribedChannelList):
    pass


class SubscribeChannelRequest(BaseModel):
    channel_ids: list[str]


class SlackEventVerificationRequestModel(BaseModel):
    token: str
    challenge: str
    type: str


# Slack model for Reply message
class Message(BaseModel):
    user: Optional[str] = None
    type: Optional[str] = None
    ts: Optional[str] = None
    client_msg_id: Optional[str] = None
    text: Optional[str] = None
    team: Optional[str] = None
    channel: Optional[str] = None
    ts: Optional[str] = None


class Event(BaseModel):
    user: Optional[str] = None
    type: Optional[str] = None
    ts: Optional[str] = None
    client_msg_id: Optional[str] = None
    text: Optional[str] = None
    team: Optional[str] = None
    channel: Optional[str] = None
    event_ts: Optional[str] = None
    subtype: Optional[str] = None
    channel_type: Optional[str] = None
    parent_user_id: Optional[str] = None
    message: Optional[Message] = None
    previous_message: Optional[Message] = None


class SlackEventModel(BaseModel):
    token: str = None
    team_id: str = None
    context_team_id: Optional[str] = None
    api_app_id: Optional[str] = None
    event: Optional[Event] = None
    type: Optional[str] = None
    event_id: Optional[str] = None
    event_time: Optional[int] = None
    is_ext_shared_channel: Optional[bool] = None
    event_context: Optional[str] = None
