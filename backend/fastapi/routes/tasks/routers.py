from fastapi import APIRouter, Body, Request, HTTPException, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder

from .models import TaskModel, UpdateTaskModel

from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()


@router.post("/", response_description="Create a new task",
             response_model=TaskModel)
async def create_task(request: Request, task: TaskModel = Body(...),
                      session: SessionContainer = Depends(verify_session())):
    user_id = session.get_user_id()
    task = jsonable_encoder(task)
    new_task = await request.app.mongodb["tasks"].insert_one(task)
    created_task = await request.app.mongodb["tasks"].find_one(
        {"_id": new_task.inserted_id}
    )

    return JSONResponse(status_code=status.HTTP_201_CREATED, content=created_task)


@router.get("/", response_description="Get all tasks", 
            response_model=list[TaskModel],
            )
async def list_tasks(request: Request,
                      session: SessionContainer = Depends(verify_session())):
    session.get_user_id()
    tasks = []
    for doc in await request.app.mongodb["tasks"].find().to_list(length=100):
        tasks.append(doc)
    return tasks


@router.get("/{id}", response_description="Get a single task",
            response_model=TaskModel)
async def show_task(id: str, request: Request,
                    session: SessionContainer = Depends(verify_session())):
    if (task := await request.app.mongodb["tasks"].find_one({"_id": id})) is not None:
        return task

    raise HTTPException(status_code=404, detail=f"Task {id} not found")


@router.put("/{id}", response_description="Update a task",
            response_model=TaskModel,)
async def update_task(id: str, request: Request, 
                      task: UpdateTaskModel = Body(...),
                      session: SessionContainer = Depends(verify_session())):
    task = {k: v for k, v in task.dict().items() if v is not None}

    if len(task) >= 1:
        update_result = await request.app.mongodb["tasks"].update_one(
            {"_id": id}, {"$set": task}
        )

        if update_result.modified_count == 1:
            if (
                updated_task := await request.app.mongodb["tasks"].find_one({"_id": id})
            ) is not None:
                return updated_task

    if (
        existing_task := await request.app.mongodb["tasks"].find_one({"_id": id})
    ) is not None:
        return existing_task

    raise HTTPException(status_code=404, detail=f"Task {id} not found")


@router.delete("/{id}", response_description="Delete a task")
async def delete_task(id: str, request: Request,
                      session: SessionContainer = Depends(verify_session())):
    delete_result = await request.app.mongodb["tasks"].delete_one({"_id": id})

    if delete_result.deleted_count == 1:
        return JSONResponse(status_code=status.HTTP_204_NO_CONTENT)

    raise HTTPException(status_code=404, detail=f"Task {id} not found")
