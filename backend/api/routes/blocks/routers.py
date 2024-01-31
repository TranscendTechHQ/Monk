
from fastapi import APIRouter, Body, Request, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder

from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends
from .models import BlockCollection, BlockModel, UpdateBlockModel, Date


from utils.db import create_mongo_document, get_mongo_documents_by_date
from bson import json_util

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
