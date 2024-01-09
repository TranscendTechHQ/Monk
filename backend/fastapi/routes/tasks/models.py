from typing import Optional, Union
import uuid
from pydantic import BaseModel, Field
from uuid import UUID
from pydantic.json_schema import SkipJsonSchema

class TaskModel(BaseModel):
    id: UUID = Field(default_factory=uuid.uuid4, alias="_id") # mongodb uses _id
    name: str = Field(...) # what is the task
    goal: str = Field(...) # why are we doing the task
    completed: bool = Field(...)

    class Config:
        populate_by_name = True
        ## will not show _id in the doc as it is autmatically generated in the backend
        json_schema_extra = {
            "example": {
                "name": "An informative task title",
                "goal": "Why are we doing it?",
                "completed": True,
            }
        }


class UpdateTaskModel(BaseModel):
    #name: Optional[str] = Field(nullable=True)

    
    name: Union[str, SkipJsonSchema[None]] = None
    goal: Union[str, SkipJsonSchema[None]] = None
    completed: Union[bool, SkipJsonSchema[None]] = None

    class Config:
        json_schema_extra = {
            "example": {
                "name": "An informative task title",
                "goal": "Why are we doing it?",
                "completed": True,
            }
        }
