from pydantic import BaseModel, Field, ConfigDict
from datetime import datetime
from typing import Optional

class BlockModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    content: str = Field(...)
    created_at: datetime = Field(default_factory=datetime.now)
    last_modified: datetime = Field(default_factory=datetime.now)
    creator_id: str = Field(default="unknown id")
    main_thread_id: str = Field(default="")
    position: int = Field(default=0)
    child_thread_id: str = Field(default="")
    task_status: str = Field(
        default="todo", pattern="^(todo|inprogress|done)$")
    tenant_id: str = Field(default="")


class ThreadModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()), alias="_id")
    creator_id: str
    created_at: datetime = Field(default_factory=datetime.now)
    last_modified: str

    # ask Yogesh for ThreadType declaration
    # type: ThreadType

    title: str = Field(..., min_length=1, max_length=100,
                       pattern="^[a-zA-Z0-9]+$")
    
    headline: str = Field(default=None)
    tenant_id: str
    num_blocks: int = Field(default=0)
    parent_block_id: Optional[str] = Field(default=None, null=True)
    slack_thread_ts: Optional[float] = Field(default=None, null=True)
    model_config = ConfigDict(extra='ignore',
                              populate_by_name=True,
                              arbitrary_types_allowed=True,
                              )
