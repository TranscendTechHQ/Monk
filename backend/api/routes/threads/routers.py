from typing import List
from fastapi import APIRouter, Body, Depends
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse


from .models import ThreadModel, UpdateThreadModel, CreateThreadModel, ThreadsModel
from .models import BlockCollection, BlockModel, UpdateBlockModel, Date
from utils.db import create_mongo_document, get_mongo_documents_by_date
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from utils.db import get_mongo_document, get_mongo_documents, update_mongo_document_fields
from fastapi import status, Request
from bson import json_util
import datetime as dt

router = APIRouter()



@router.post("/blocks", response_model=BlockModel, response_description="Create a new block")
async def create_block(request: Request, block: UpdateBlockModel = Body(...),
                      session: SessionContainer = Depends(verify_session())):
    # Logic to store the block in MongoDB backend database
    # Index the block by userId
    
    block = block.model_dump()
    new_block = BlockModel(**block)
    
    created_block = await create_mongo_document(jsonable_encoder(new_block), 
                                          request.app.mongodb["blocks"])

    return JSONResponse(status_code=status.HTTP_201_CREATED, 
                       content=jsonable_encoder(created_block))
  
    
# get blocks given a date
@router.get("/blocks", response_model=BlockCollection,
            response_description="Get all blocks for a given date")
async def get_blocks_by_date(request: Request,
                             date: Date,
                             session: SessionContainer = Depends(verify_session())
                             ):
    # Logic to fetch all blocks by the signed-in user from MongoDB backend database
   
    blocks = await get_mongo_documents_by_date(date.date, request.app.mongodb["blocks"])
    
    ret_block = BlockCollection(blocks=blocks)

    
    ## retun the block in json format
    return JSONResponse(status_code=status.HTTP_200_OK, 
                       content=jsonable_encoder(ret_block))

@router.get("/journal", response_model=BlockCollection,
            response_description="Get journal for a given date")
async def get_journal_by_date(request: Request,
                                date: Date,
                                session: SessionContainer = Depends(verify_session())
                                ):
    # get journal thread. If it does not exist, create it
    journal = await get_mongo_document({"title": "journal"}, request.app.mongodb["threads"])
    if not journal:
        journal = await create_mongo_document({"title": "journal", "content": []}, request.app.mongodb["threads"])
    ## get the blocks that have created_at date equal to the date
    ## doing this query in the db directly will be much faster than doing this 
    ## in the python application
    
    ## build a pymongo query to get the list of blocks from a thread that have the created_at date equal to the date
    ## provided date:
    d = date.date.date()
    from_date = dt.datetime.combine(d, dt.datetime.min.time())
    to_date = dt.datetime.combine(d, dt.datetime.max.time())
    
    query = {"title": "journal",
             "content":{ "$elemMatch": {"created_at": {"$gte": from_date.isoformat(), 
                            "$lt": to_date.isoformat()}}}}
    collection = request.app.mongodb["threads"]
    cursor =  collection.find(query)
    batch_size = 100
    # Convert cursor to list of dictionaries
    blocks = await cursor.to_list(length=batch_size)
    
    print(blocks)
    ret_thread = BlockCollection(blocks=blocks)
    
    print(ret_thread)
    return JSONResponse(status_code=status.HTTP_200_OK,
                          content=jsonable_encoder(ret_thread))
                        
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
