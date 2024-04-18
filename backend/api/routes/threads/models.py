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


class Creator(BaseModel):
    name: str = Field(default="unknown user")
    picture: str = Field(default="unknown picture link")
    email: str = Field(default="unknown email")
    id: str = Field(default="unknown id")
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra={
                                  "example": {
                                      "name": "firstname lastname",
                                      "picture": "https://www.example.com/picture.jpg",
                                      "email": "hey@abc.com",
                                      "id": "12345678-1234-5678-1234-567812345678"
                                  }
                              }
                              )


class BlockModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    content: str = Field(...)
    created_at: datetime = Field(default_factory=datetime.now)
    created_by: str = Field(default="unknown user")
    creator_email: str = Field(default="unknown email")
    creator_picture: str = Field(default="unknown picture link")
    creator_id: str = Field(default="unknown id")
    child_id: str = Field(default="")


class UpdateBlockModel(BaseModel):
    content: Union[str, SkipJsonSchema[None]] = None
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra={
                                  "example": {
                                      "content": "This is the content of the block",
                                  }
                              }
                              )


class BlockCollection(BaseModel):
    blocks: List[BlockModel]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra={
                                  "example": {
                                      "blocks": [
                                          {
                                              "content": "This is the content of the block",
                                          },
                                          {
                                              "content": "This is the content of the block",
                                          }
                                      ]
                                  }
                              }
                              )


class Date(BaseModel):
    date: dt.datetime


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
                              json_schema_extra={
                                  "example": {
                                      "type": "/new-plan",
                                      "title": "This is the title of the thread",
                                      "content": [
                                          {
                                              "content": "This is the content of the block",
                                          },
                                          {
                                              "content": "This is the content of the block",
                                          }
                                      ]

                                  }
                              }
                              )


class CreateChildThreadModel(CreateThreadModel):
    parent_block_id: str = Field(..., alias="parentBlockId")
    parent_thread_id: str = Field(..., alias="parentThreadId")


class ThreadModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    creator: str
    created_date: datetime = Field(default_factory=datetime.now)
    type: ThreadType
    title: str = Field(..., min_length=1, max_length=100, pattern="^[a-zA-Z0-9]+$")
    content: Union[List[BlockModel], SkipJsonSchema[None]] = None
    headline: str = Field(default=None)
    tenant_id: str
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra={
                                  "example": {
                                      "creator": "user1",
                                      "created_date": "2021-01-01T00:00:00.000000",
                                      "type": "/new-plan",
                                      "title": "This is the title of the thread",
                                      "content": [
                                          {
                                              "content": "This is the content of the block",
                                          },
                                          {
                                              "content": "This is the content of the block",
                                          }
                                      ],
                                      "headline": "This is the headline of the thread",
                                      "tenant_id": "ABCD1234"
                                  }
                              }
                              )


class UpdateThreadModel(BaseModel):
    content: List[BlockModel]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra={
                                  "example": {
                                      "content": [
                                          {
                                              "content": "This is the content of the block",
                                          },
                                          {
                                              "content": "This is the content of the block",
                                          }
                                      ]

                                  }
                              }
                              )


class UserThreadFlagModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    user_id: str
    thread_id: str
    read: bool = Field(default=False)
    unfollow: bool = Field(default=False)
    bookmark: bool = Field(default=False)
    upvote: bool = Field(default=False)


class UserThreadFlagsModel(BaseModel):
    threadReads: List[UserThreadFlagModel]


class CreateUserThreadFlagModel(BaseModel):
    thread_id: str
    read: Optional[bool] = None
    unfollow: Optional[bool] = None
    bookmark: Optional[bool] = None
    upvote: Optional[bool] = None
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra={
                                  "example": {
                                      "thread_id": "12345678-123"
                                  }
                              }
                              )


class ThreadsModel(BaseModel):
    threads: List[ThreadModel]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra={
                                  "example": {
                                      "threads": [
                                          {
                                              "creator": "user1",
                                              "created_date": "2021-01-01T00:00:00.000000",
                                              "type": "/new-plan",
                                              "title": "This is the title of the thread",
                                              "content": [
                                                  {
                                                      "content": "This is the content of the block",
                                                  },
                                                  {
                                                      "content": "This is the content of the block",
                                                  }
                                              ]

                                          },
                                          {
                                              "creator": "user1",
                                              "created_date": "2021-01-01T00:00:00.000000",
                                              "type": "/new-plan",
                                              "title": "This is the title of the thread",
                                              "content": [
                                                  {
                                                      "content": "This is the content of the block",
                                                  },
                                                  {
                                                      "content": "This is the content of the block",
                                                  }
                                              ]

                                          }
                                      ]

                                  }
                              }
                              )


class ThreadMetaData(BaseModel):
    id: str = Field(..., alias="_id")
    title: str
    type: str
    created_date: str
    creator: Creator
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra={
                                  "example": {
                                      "id": "12345678-1234-5678-1234-567812345678",
                                      "title": "This is the title of the thread",
                                      "type": "/new-plan",
                                      "created_date": "2021-01-01T00:00:00.000000",
                                      "creator": {
                                          "name": "firstname lastname",
                                          "picture": "https://www.example.com/picture.jpg",
                                          "email": "a@b.com",
                                          "id": "12345678-123"
                                      }
                                  }
                              }
                              )


class ThreadsMetaData(BaseModel):
    metadata: List[ThreadMetaData]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra={
                                  "example": {
                                      "metadata": [
                                          {
                                              "id": "12345678-1234-5678-1234-567812345678",
                                              "title": "This is the title of the thread",
                                              "type": "/new-plan",
                                              "created_date": "2021-01-01T00:00:00.000000",
                                              "creator": "user1"
                                          },
                                          {
                                              "id": "12345678-1234-5678-1234-567812345678",
                                              "title": "This is the title of the thread",
                                              "type": "/new-plan",
                                              "created_date": "2021-01-01T00:00:00.000000",
                                              "creator": "user1"
                                          }
                                      ]
                                  }
                              }
                              )


class ThreadsInfo(BaseModel):
    info: dict[str, ThreadType]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra={
                                  "example": {
                                      "titles": [
                                          {
                                              "ThreadTitle": "ThreadType",
                                          },
                                          {
                                              "AnotherThreadTitle": "AnotherThreadType",
                                          }
                                      ]
                                  }
                              }
                              )


class ThreadHeadlineModel(BaseModel):
    id: str = Field(..., alias="_id")
    title: str
    headline: str
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra={
                                  "example": {
                                      "id": "12345678-1234-5678-1234-567812345678",
                                      "title": "This is the title of the thread",
                                      "headline": "This is the headline of the thread"
                                  }
                              }
                              )


class ThreadHeadlinesModel(BaseModel):
    headlines: List[ThreadHeadlineModel]
