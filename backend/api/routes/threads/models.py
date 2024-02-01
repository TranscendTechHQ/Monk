from datetime import datetime
from typing import List, Union
from uuid import UUID
import uuid
from pydantic import BaseModel, ConfigDict, Field

from pydantic.json_schema import SkipJsonSchema
from enum import Enum

import datetime as dt


class BlockModel(BaseModel):
    id: UUID = Field(default_factory=uuid.uuid4, alias="_id")
    content: str = Field(...)
    created_at: datetime = Field(default_factory=datetime.now)
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra = {
                                "example": {
                                "id": "12345678-1234-5678-1234-567812345678",
                                "content": "This is the content of the block",
                                "created_at": "2021-01-01T00:00:00.000000",
                                }
                              }                     
                        )

class UpdateBlockModel(BaseModel):
    content: Union[str, SkipJsonSchema[None]] = None
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra = {
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
                              json_schema_extra = {
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


class ThreadType(str, Enum):
    journal = "/new-journal"
    thread = "new-thread"
    plan = "new-plan"
    news = "news"
    report = "new-report"
    project = "new-project"
    task = "new-task"
    note = "new-note"
    idea = "new-idea"
    event = "new-event"
    blocker = "new-blocker"
    think = "new-thought"
    strategy = "new-strategy"
    private = "new-private"
    experiment = "new-experiment"
    go = "go"
   
class CreateThreadModel(BaseModel):
    type: ThreadType
    title: str = Field(..., min_length=1, max_length=100, pattern="^[a-zA-Z0-9]+$")
    content: Union[List[BlockModel], SkipJsonSchema[None]] = None
    model_config = ConfigDict(extra='ignore',
                                populate_by_name=True,
                                arbitrary_types_allowed=True,
                                json_schema_extra = {
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

class ThreadModel(BaseModel):
    id: UUID = Field(default_factory=uuid.uuid4, alias="_id")
    creator: str
    created_date: datetime = Field(default_factory=datetime.now)
    type: ThreadType
    title: str = Field(..., min_length=1, max_length=100, pattern="^[a-zA-Z0-9]+$")
    content: Union[List[BlockModel], SkipJsonSchema[None]] = None
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra = {
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
                                ]
                                
                                }
                              }
                        )
    
class UpdateThreadModel(BaseModel):
    content: List[BlockModel]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra = {
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
    
    
class ThreadsModel(BaseModel):
    threads: List[ThreadModel]
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra = {
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
    