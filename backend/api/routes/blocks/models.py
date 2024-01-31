from datetime import datetime
from typing import Union
from uuid import UUID
import uuid
from pydantic import BaseModel, Field, ConfigDict
from pydantic.json_schema import SkipJsonSchema
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
    blocks: list[BlockModel]
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