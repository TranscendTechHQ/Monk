from pydantic import BaseModel, Field

class ChannelModel(BaseModel):
    id: str
    name: str
    
class PublicChannelList(BaseModel):
    public_channels: list[ChannelModel]

class SubscribedChannelList(BaseModel):
    id: str = Field(..., alias="_id")
    subscribed_channels: list[ChannelModel]
    
class CompositeChannelList(PublicChannelList, SubscribedChannelList):
    pass