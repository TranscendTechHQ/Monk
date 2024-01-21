from datetime import datetime
from typing import Dict, Any, Union
from uuid import UUID
import uuid
from pydantic import BaseModel, Field, ConfigDict
from pydantic.json_schema import SkipJsonSchema

class BlockModel(BaseModel):
    id: UUID = Field(default_factory=uuid.uuid4, alias="_id")
    content: str = Field(...)
    created_at: datetime = Field(default_factory=datetime.now)
    metadata: Union[Dict[str, Any], SkipJsonSchema[None]] = None
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra = {
                                "example": {
                                "content": "This is the content of the block",
                                "metadata": {
                                    "type": "task",
                                    "description": "This block describes a task",
                                    "tags": ["tag1", "tag2"],
                                    "created_at": "2021-01-01T00:00:00.000000",
                                },
                            }
                         }
                        )
    
        
        
        
class UpdateBlockModel(BaseModel):
    content: Union[str, SkipJsonSchema[None]] = None
    metadata: Union[Dict[str, Any], SkipJsonSchema[None]] = None
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              json_schema_extra = {
                                "example": {
                                "content": "This is the content of the block",
                                "metadata": {
                                    "type": "task",
                                    "description": "This block describes a task",
                                    "tags": ["tag1", "tag2"],
                                    "created_at": "2021-01-01T00:00:00.000000",
                                },
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
                                        "metadata": {
                                            "type": "task",
                                            "description": "This block describes a task",
                                            "tags": ["tag1", "tag2"],
                                            "created_at": "2021-01-01T00:00:00.000000",
                                        },
                                    }
                                ]
                            }
                         }
                        )
    
