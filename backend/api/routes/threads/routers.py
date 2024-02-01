from typing import List
from fastapi import APIRouter, Body, Depends
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
#from urllib.request import Request

from .models import ThreadModel, UpdateThreadModel, CreateThreadModel, ThreadsModel
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from utils.db import create_mongo_document, get_mongo_document, get_mongo_documents, update_mongo_document_fields
from fastapi import status, Request
from bson import json_util

router = APIRouter()

@router.post("/threads", response_model=ThreadModel)
async def create_thread(request: Request, thread_data: CreateThreadModel = Body(...), 
                        session: SessionContainer = Depends(verify_session())):
    # Create a new thread in MongoDB using the thread_data
    # Index the thread by userId
    
    thread = jsonable_encoder(thread_data)
    new_thread = ThreadModel(**thread)
    user_id = session.get_user_id()
    new_thread.creator = user_id
    created_thread = await create_mongo_document(new_thread, 
                                          request.app.mongodb["threads"])
    
    return JSONResponse(status_code=status.HTTP_201_CREATED, 
                       content=jsonable_encoder(created_thread))

@router.put("/threads/{title}", response_model=ThreadModel)
async def update_thread(request: Request, title: str, thread_data: UpdateThreadModel, 
                        session: SessionContainer = Depends(verify_session())):
    # Update an existing thread in MongoDB identified by the title
    thread = jsonable_encoder(thread_data)
    
    updated_thread = await update_mongo_document_fields(
        {"title": title}, 
        thread, 
        request.app.mongodb["threads"])
    return JSONResponse(status_code=status.HTTP_200_OK, 
                       content=jsonable_encoder(updated_thread))

@router.get("/threads/{title}", response_model=ThreadModel)
async def get_thread(request: Request, title: str, 
                     session: SessionContainer = Depends(verify_session())):
    # Get a thread from MongoDB by title

    old_thread = await get_mongo_document({"title": title}, request.app.mongodb["threads"])
    if not old_thread:
        return JSONResponse(status_code=404, content={"message": "Thread not found"})
    return JSONResponse(status_code=status.HTTP_200_OK, 
                       content=jsonable_encoder(old_thread))

@router.get("/threads", response_model=List[ThreadsModel])
async def get_all_threads(request: Request, session: SessionContainer = Depends(verify_session())):
    # Get all threads from MongoDB by date created
    threads = await get_mongo_documents(request.app.mongodb["threads"])
    return threads
