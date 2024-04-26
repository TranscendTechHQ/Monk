import datetime as dt
import uuid
from datetime import datetime
from typing import Annotated, List, Union, Optional

from pydantic import AfterValidator, BaseModel, ConfigDict, Field
from pydantic.json_schema import SkipJsonSchema

THREADTYPES = [
    "/new-thread",
    "/new-plan",
    "/news",
    "/new-report",
    "/new-project",
    "/new-task",
    "/new-note",
    "/new-idea",
    "/new-event",
    "/new-blocker",
    "/new-thought",
    "/new-strategy",
    "/new-private",
    "/new-experiment",
    "/go"]


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

class BlockModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    content: str = Field(...)
    created_at: datetime = Field(default_factory=datetime.now)
    last_modified: datetime = Field(default_factory=datetime.now)
    creator_id: str = Field(default="unknown id")
    child_id: str = Field(default="")
    parent_thread_id: str = Field(default="")
    block_pos_in_child: int = Field(default=0)
    block_pos_in_parent: int = Field(default=0)
    child_thread_id: str = Field(default="")
    tenant_id: str = Field(default="")



class UpdateBlockModel(BaseModel):
    content: Union[str, SkipJsonSchema[None]] = None
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
    title: str = Field(..., min_length=1, max_length=100, pattern="^[a-zA-Z0-9]+$")
    content: Union[List[BlockModel], SkipJsonSchema[None]] = None
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class CreateChildThreadModel(CreateThreadModel):
    parent_block_id: str = Field(..., alias="parentBlockId")
    parent_thread_id: str = Field(..., alias="parentThreadId")


class ThreadModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    creator_id: str
    created_date: datetime = Field(default_factory=datetime.now)
    type: ThreadType
    title: str = Field(..., min_length=1, max_length=100, pattern="^[a-zA-Z0-9]+$")
    content: Union[List[BlockModel], SkipJsonSchema[None]] = None
    headline: str = Field(default=None)
    tenant_id: str
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
    title: str
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class UserThreadFlagModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    user_id: str
    thread_id: str
    tenant_id: str
    read: bool = Field(default=False)
    unfollow: bool = Field(default=False)
    bookmark: bool = Field(default=False)
    upvote: bool = Field(default=False)


class UserThreadFlagsModel(BaseModel):
    threadReads: List[UserThreadFlagModel]


class CreateUserThreadFlagModel(BaseModel):
    thread_id: str
    read: bool = Field(default=None)
    unfollow: bool = Field(default=None)
    bookmark: bool = Field(default=None)
    upvote: bool = Field(default=None)
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class ThreadsModel(BaseModel):
    threads: List[ThreadModel]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )


class ThreadMetaData(BaseModel):
    id: str = Field(..., alias="_id")
    title: str
    type: str
    created_date: str
    creator: UserModel
    headline: str = Field(default=None)
    read: bool = Field(default=False)
    unfollow: bool = Field(default=False)
    bookmark: bool = Field(default=False)
    upvote: bool = Field(default=False)
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


