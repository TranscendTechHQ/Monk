from datetime import timezone
import uuid
from datetime import datetime
from typing import List, Optional

from bson import ObjectId
from pydantic import BaseModel, ConfigDict, Field


class BaseModelConfig(BaseModel):
    #id: ObjectId = Field(default_factory=ObjectId, alias="_id")

    class Config:
        extra = 'ignore'
        populate_by_name = True
        arbitrary_types_allowed = True
        
class User(BaseModelConfig):
    name: str = Field(default="unknown user")
    picture: str = Field(default="unknown picture link")
    email: str = Field(default="unknown email")

class UserDb(User):
    id: str = Field(..., alias="_id")
    last_login: str = Field(default="unknown last login")
    tenant_id: str


class UserResponse(User):
    id: str = Field(..., alias="_id")
    last_login: str

class UsersResponse(BaseModelConfig):
    users: List[UserResponse]





class LinkMetaModel(BaseModelConfig):
    url: str
    topic: Optional[str] = Field(default=None)
    description: Optional[str] = Field(default=None)
    image: Optional[str] = Field(default=None)




class DBMeta(BaseModelConfig):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    creator_id: str = Field
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    last_modified: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))

class Message(BaseModelConfig):
    text: str = Field
    image: Optional[str] = Field(default=None)
    link_meta: Optional[LinkMetaModel] = Field(default=None)

class MessageDb(Message, DBMeta):
    thread_id: str = Field
    tenant_id: str = Field
    
class MessageCreate(Message):
    thread_id: str = Field

class MessageUpdate(Message):
    id: str
    
class MessageDelete(BaseModelConfig):
    id: str
    
class MessageResponse(Message, DBMeta):
    thread_id: str

class MessagesResponse(BaseModelConfig):
    messages: List[MessageResponse]

class Thread(Message):
    topic: str

class ThreadDb(Thread, DBMeta):
    tenant_id: str = Field
    
class ThreadCreate(Thread):
    pass
    
class ThreadUpdate(Thread):
    id: str

class ThreadDelete(BaseModelConfig):
    id: str   

class ThreadResponse(Thread, DBMeta):
    pass

class ThreadsResponse(BaseModelConfig):
    threads: List[ThreadResponse]


