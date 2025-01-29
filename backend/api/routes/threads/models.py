import datetime as dt
import uuid
from datetime import datetime
from typing import Annotated, List, Optional, Union

from bson import ObjectId
from pydantic import AfterValidator, BaseModel, ConfigDict, Field
from pydantic.json_schema import SkipJsonSchema




class UserModel(BaseModel):
    id: str = Field(..., alias="_id")
    name: str = Field(default="unknown user")
    picture: str = Field(default="unknown picture link")
    email: str = Field(default="unknown email")
    last_login: str = Field(default="unknown last login")
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class UserMap(BaseModel):
    users: dict[str, UserModel]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,)





class LinkMetaModel(BaseModel):
    url: str
    topic: Optional[str] = Field(default=None)
    description: Optional[str] = Field(default=None)
    image: Optional[str] = Field(default=None)
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )

class BaseModelConfig(BaseModel):
    #id: ObjectId = Field(default_factory=ObjectId, alias="_id")

    class Config:
        extra = 'ignore'
        populate_by_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}

class Message(BaseModelConfig):
    text: str = Field
    image: Optional[str] = Field(default=None)
    link_meta: Optional[LinkMetaModel] = Field(default=None)

class MessageDb(BaseModelConfig):
    content: Message
    creator_id: str = Field
    created_at: datetime = Field(default_factory=datetime.now)
    last_modified: datetime = Field(default_factory=datetime.now)
    thread_id: str = Field
    tenant_id: str = Field
    
    
class MessageCreate(BaseModelConfig):
    content: Message
    thread_id: str = Field

class MessageUpdate(BaseModelConfig):
    content: Message
    
class MessageDelete(BaseModelConfig):
    id: str
    
class MessageResponse(BaseModelConfig):
    id: str
    content: Message
    creator_id: str
    created_at: datetime
    last_modified: datetime
    thread_id: str

class MessagesResponse(BaseModelConfig):
    messages: List[MessageResponse]

class Thread(BaseModelConfig):
    topic: str
    headline: Message

class ThreadDb(BaseModelConfig):
    content: Thread
    tenant_id: str
    creator_id: str
    created_at: datetime = Field(default_factory=datetime.now)
    last_modified: datetime = Field(default_factory=datetime.now)
    
class ThreadCreate(BaseModelConfig):
    content: Thread
    
class ThreadUpdate(BaseModelConfig):
    content: Thread

class ThreadResponse(BaseModelConfig):
    id: str
    content: Thread
    creator_id: str
    created_at: datetime
    last_modified: datetime
    

    
class ThreadDelete(BaseModelConfig):
    id: str
    
    
class ThreadsResponse(BaseModelConfig):
    threads: List[ThreadResponse]


