import datetime as dt
import json
from typing import Any

from urllib.parse import unquote
from urllib.request import Request
from fastapi import APIRouter, Body, Request, HTTPException, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder

from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

from .models import BlockCollection, BlockModel, UpdateBlockModel
from fastapi import Query

from typing_extensions import Annotated

from pydantic import (
    BaseModel,
    ValidationError,
    ValidationInfo,
    ValidatorFunctionWrapHandler,
    BeforeValidator
)
from pydantic.functional_validators import WrapValidator
from bson import json_util



router = APIRouter()

async def get_mongo_document(id: str, collection):
    if (doc := await collection.find_one({"_id": id})) is not None:
        return doc

async def get_mongo_documents(collection):
    docs = []
    async for doc in collection.find():
        docs.append(doc)
    return docs

async def get_mongo_documents_by_date(date: dt.datetime, collection):
    docs = []
   # async for doc in collection.find({"metadata.createdAt": date}):
    #    docs.append(doc)
    d = date.date()
    from_date = dt.datetime.combine(d, dt.datetime.min.time())
    print(from_date.isoformat())
    
    to_date = dt.datetime.combine(d, dt.datetime.max.time())
    print(to_date.isoformat())
    print("hey 1")
    query = {"created_at": {"$gte": from_date.isoformat(), "$lt": to_date.isoformat()}}
    print(query)
    print("hey 2")
    cursor =  collection.find(query)
    print("hey 3")
    print(cursor)
    print("hey 4")
    # Convert cursor to list of dictionaries
    documents = await cursor.to_list(length=5)
    print("hey 5")
    print(documents)
    #for doc in cursor.each():
     #   docs.append(doc)
      #  print(doc)
    print("hey 6")
    
    return documents

async def delete_mongo_document(id: str, collection):
    if (doc := await collection.find_one({"_id": id})) is not None:
        await collection.delete_one({"_id": id})
        return doc

async def create_mongo_document(document: dict, collection):

    new_document = await collection.insert_one(document)
    
    created_document = await collection.find_one(
        {"_id": new_document.inserted_id})
    
    return created_document

async def update_mongo_document_fields(id:str, fields: dict, collection):
    fields_dict = {k: v for k, v in fields.dict().items() if v is not None}

    if len(fields_dict) >= 1:
        update_result = await collection.update_one(
            {"_id": id}, {"$set": fields_dict}
        )

        if update_result.modified_count == 1:
            if (
                updated_doc := await collection.find_one({"_id": id})
            ) is not None:
                return updated_doc

    if (
        existing_doc := await collection.find_one({"_id": id})
    ) is not None:
        return existing_doc

    return None
    

@router.post("/blocks", response_model=BlockModel, 
             response_description="Create a new block")
async def create_block(request: Request, block: BlockModel = Body(...),
                      session: SessionContainer = Depends(verify_session())):
    # Logic to store the block in MongoDB backend database
    # Index the block by userId
    user_id = session.get_user_id()
    
    block = jsonable_encoder(block)
   # block["metadata"]["createdBy"] = user_id
   # block["metadata"]["createdAt"] = datetime.datetime.now().isoformat()
    
    created_block = await create_mongo_document(block, 
                                          request.app.mongodb["blocks"])
    
    return JSONResponse(status_code=status.HTTP_201_CREATED, 
                       content=jsonable_encoder(created_block))

@router.put("/blocks/{block_id}", response_model=BlockModel, 
            response_description="Update a block")
async def update_block(block_id:str, request: Request, block: UpdateBlockModel = Body(...),
                      session: SessionContainer = Depends(verify_session())):
    # Logic to update the block in MongoDB backend database
    updated_block = update_mongo_document_fields(
        block_id, block, request.app.mongodb["blocks"])
    if updated_block is not None:
        return updated_block
    else:
        raise HTTPException(status_code=404, 
                            detail=f"Block {block_id} not found")

@router.delete("/blocks/{block_id}",
               response_description="Delete a block")
def delete_block(block_id:str, request: Request,
                      session: SessionContainer = Depends(verify_session())):
    # Logic to delete the block from MongoDB backend database
    deleted_block = delete_mongo_document(block_id, 
                                          request.app.mongodb["blocks"])

@router.get("/blocks/{block_id}", response_model=BlockModel,
            response_description="Get a single block")
async def get_block(block_id: str, request: Request,
                      session: SessionContainer = Depends(verify_session())):
    # Logic to fetch a single block by id from MongoDB backend database
    get_block = await get_mongo_document(block_id, 
                                   request.app.mongodb["blocks"])
    ## retun the block in json format
    if get_block is not None:
        return JSONResponse(status_code=status.HTTP_200_OK, 
                       content=jsonable_encoder(get_block))
    else:
        raise HTTPException(status_code=404, 
                            detail=f"Block {block_id} not found")

@router.get("/all_blocks", response_model=BlockCollection,
            response_description="Get all blocks")
async def get_blocks(block_id: str, request: Request,
                      session: SessionContainer = Depends(verify_session())):
    # Logic to fetch all blocks by the signed-in user from MongoDB backend database
    blocks = await get_mongo_documents(request.app.mongodb["blocks"])
    ## retun the block in json format
    return JSONResponse(status_code=status.HTTP_200_OK, 
                       content=jsonable_encoder(blocks))

def convert_to_datetime(date_str: str):
    print("hello")
    print(date_str)
    date_str = unquote(date_str)
    return dt.datetime.fromisoformat(date_str)

class Date(BaseModel):
    date: dt.datetime
    
# get blocks given a date
@router.get("/blocks", response_model=BlockCollection,
            response_description="Get all blocks for a given date")
async def get_blocks_by_date(request: Request,
                             date: Date,
                             session: SessionContainer = Depends(verify_session())
                             ):
    # Logic to fetch all blocks by the signed-in user from MongoDB backend database
    print(date.date)
    #isodate = dt.datetime.fromisoformat(unquote(date))
    blocks = await get_mongo_documents_by_date(date.date, request.app.mongodb["blocks"])
    print(blocks)
    return JSONResponse(status_code=status.HTTP_200_OK, 
                       content=jsonable_encoder(blocks))
