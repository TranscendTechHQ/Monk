from pydantic import BaseModel, ConfigDict, Field

class ChannelModel(BaseModel):
    id: str
    name: str
    
class PublicChannelList(BaseModel):
    public_channels: list[ChannelModel]

class SubscribedChannelList(BaseModel):
    id: str = Field(..., alias="_id")
    subscribed_channels: list[ChannelModel]
    model_config = ConfigDict(populate_by_name=True,
                              alias_generator=None,)
    
class CompositeChannelList(PublicChannelList, SubscribedChannelList):
    pass

class SubcribeChannelRequest(BaseModel):
    channel_ids: list[str]