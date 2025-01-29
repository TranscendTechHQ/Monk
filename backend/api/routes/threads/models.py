import datetime as dt
import uuid
from datetime import datetime
from typing import Annotated, List, Optional, Union

from bson import ObjectId
from pydantic import AfterValidator, BaseModel, ConfigDict, Field
from pydantic.json_schema import SkipJsonSchema

THREADTYPES = [
    "chat",
    "todo",
    "slack"]


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


class UpdateBlockPositionModel(BaseModel):
    block_id: str = Field(default='')
    new_position: int = Field(default=0)
    sort_by_assigned_pos: bool = Field(default=False)
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


class BlockModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    content: str = Field(...)
    image: Optional[str] = Field(default=None)
    created_at: datetime = Field(default_factory=datetime.now)
    last_modified: datetime = Field(default_factory=datetime.now)
    due_date: Optional[dt.datetime] = Field(default=None)
    creator_id: str = Field(default="unknown id")
    main_thread_id: str = Field(default="")
    position: int = Field(default=0)
    child_thread_id: str = Field(default="")
    task_status: str = Field(
        default="todo", pattern="^(todo|inprogress|done)$")
    tenant_id: str = Field(default="")
    link_meta: Optional[LinkMetaModel] = Field(default=None)
    assigned_to_id: Optional[str] = Field(default=None)
    assigned_to: Optional[UserModel] = Field(default=None)
    assigned_thread_id: Optional[str] = Field(default=None)
    assigned_pos: int = Field(default=1)


class CreateBlockModel(BaseModel):
    content: str
    due_date: Optional[dt.datetime] = Field(default=None)
    image: Optional[str] = Field(default=None)
    main_thread_id: str
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class UpdateBlockModel(BaseModel):
    content: Union[str, SkipJsonSchema[None]] = None
    position: int = Field(default=None)
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


def allowed_thread_types(thread_type: str) -> str:
    assert thread_type in THREADTYPES, f'{thread_type} Unknown ThreadType'
    return thread_type


ThreadType = Annotated[str, AfterValidator(allowed_thread_types)]


class CreateThreadModel(BaseModel):
    type: ThreadType
    topic: str = Field(..., min_length=1, max_length=60)
    content: Union[List[BlockModel], SkipJsonSchema[None]] = None
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class CreateChildThreadModel(CreateThreadModel):
    parent_block_id: str = Field(..., alias="parentBlockId")
    main_thread_id: str = Field(..., alias="mainThreadId")
    assigned_to_id: Optional[str] = Field(default=None, alias="assignedId")


class ThreadModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    creator_id: str
    created_at: datetime = Field(default_factory=datetime.now)
    last_modified: str
    type: ThreadType
    topic: str = Field(..., min_length=1, max_length=60)
    content: Union[List[BlockModel], SkipJsonSchema[None]] = None
    headline: str = Field(default=None)
    tenant_id: str
    num_blocks: int = Field(default=0)
    assigned_to_id: Optional[str] = Field(default=None)
    parent_block_id: Optional[str] = Field(default=None, null=True)
    slack_thread_ts: Optional[float] = Field(default=None, null=True)
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class UpdateThreadModel(BaseModel):
    content: List[BlockModel]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class UpdateThreadTitleModel(BaseModel):
    topic: str
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class UserFilterPreferenceModel(BaseModel):
    unread: Optional[bool] = Field(default=None, null=True)
    unfollow: Optional[bool] = Field(default=None, null=True)
    bookmark: Optional[bool] = Field(default=None, null=True)
    upvote: Optional[bool] = Field(default=None, null=True)
    mention: Optional[bool] = Field(default=None, null=True)
    searchQuery: Optional[str] = Field(default=None, null=True)
    assigned: Optional[bool] = Field(default=None, null=True)


class UserThreadFlagModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    user_id: str
    thread_id: str
    tenant_id: str
    unread: Optional[bool] = Field(default=None, null=True)
    unfollow: Optional[bool] = Field(default=None, null=True)
    bookmark: Optional[bool] = Field(default=None, null=True)
    upvote: Optional[bool] = Field(default=None, null=True)
    mention: Optional[bool] = Field(default=None, null=True)
    assigned: Optional[bool] = Field(default=None, null=False)


class UserThreadFlagsModel(BaseModel):
    threadReads: List[UserThreadFlagModel]


class CreateUserThreadFlagModel(BaseModel):
    thread_id: str
    unread: Optional[bool] = Field(default=None, null=True)
    unfollow: Optional[bool] = Field(default=None, null=True)
    bookmark: Optional[bool] = Field(default=None, null=True)
    mention: Optional[bool] = Field(default=None, null=True)
    upvote: Optional[bool] = Field(default=None, null=True)
    assigned: Optional[bool] = Field(default=None, null=True)
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


# TODO: Deprecate this model. Use ThreadMetaData instead
class ThreadsModel(BaseModel):
    threads: List[ThreadModel]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class ThreadMetaData(BaseModel):
    id: str = Field(..., alias="_id")
    topic: str
    type: str
    created_at: str
    last_modified: datetime = Field(default_factory=datetime.now)
    creator: UserModel
    parent_block_id: Optional[str] = Field(default=None)
    assigned_to_id: Optional[str] = Field(default=None)
    headline: str = Field(default=None)
    num_blocks: int = Field(default=0)
    unread: Optional[bool] = Field(default=None, null=True)
    unfollow: Optional[bool] = Field(default=None, null=True)
    bookmark: Optional[bool] = Field(default=None, null=True)
    assigned: Optional[bool] = Field(default=None, null=True)
    mention: Optional[bool] = Field(default=None, null=True)
    upvote: Optional[bool] = Field(default=None, null=True)
    block: Optional[BlockModel] = Field(default=None)
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class ThreadsMetaData(BaseModel):
    metadata: List[ThreadMetaData]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class BlockWithCreator(BlockModel):
    creator: UserModel
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class FullThreadInfo(ThreadMetaData):
    content: Union[List[BlockWithCreator], SkipJsonSchema[None]] = None
    default_block: BlockWithCreator = Field(default=None)
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class ThreadsInfo(BaseModel):
    info: dict[str, ThreadType]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )
