from typing import Optional
import uuid
from pydantic import BaseModel, Field
from uuid import UUID

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
    id: UUID
    name: Optional[str] = Field(nullable=True)
    goal: Optional[str] = Field(nullable=True)
    completed: Optional[bool] = Field(nullable=True)

    class Config:
        json_schema_extra = {
            "example": {
                "id":"5f8b8b9e-8b7e-4e0e-8e1e-5b9b8b9b8b9b",
                "name": "An informative task title",
                "goal": "Why are we doing it?",
                "completed": True,
            }
        }
