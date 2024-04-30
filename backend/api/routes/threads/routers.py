import datetime as dt
from fastapi import FastAPI, HTTPException
import logging
from typing import List

from fastapi import APIRouter, Body, Depends
from fastapi import status, Request
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.thirdparty.asyncio import get_user_by_id

from utils.db import get_mongo_document, get_mongo_documents, get_tenant_id, update_mongo_document_fields, asyncdb, \
    create_mongo_document, delete_mongo_document
from utils.db import get_mongo_documents_by_date, get_user_name, get_block_by_id
from utils.headline import generate_single_thread_headline
from .child_thread import create_child_thread
from .child_thread import create_new_thread
from .models import BlockModel, CreateBlockModel, FullThreadInfo, PositionModel, UpdateBlockModel, UpdateBlockPositionModel, UserMap, UserModel, UserThreadFlagModel, CreateUserThreadFlagModel, \
    UpdateThreadTitleModel, BlockWithCreator
from .models import THREADTYPES, CreateChildThreadModel, ThreadType, \
    ThreadsInfo, ThreadsMetaData, CreateThreadModel, ThreadsModel
from .search import thread_semantic_search

router = APIRouter()
logger = logging.getLogger(__name__)


async def keyword_search(query, collection):
    threads = await collection.aggregate([
        {
            "$search": {
                "index": "monkThreadIndex",
                "text": {
                    "query": query,
                    "path": {
                        "wildcard": "*"
                    }
                }
            }
        },
        {
            "$limit": 3
        }
    ]).to_list(length=None)

    return threads


@router.get("/user", response_model=UserMap,
            response_description="Get user information")
async def all_users(request: Request,
                    session: SessionContainer = Depends(verify_session())
                    ):
    tenant_id = await get_tenant_id(session)
    # get all users
    final_user_map = {}

    cursor = asyncdb.users_collection.find({"tenant_id": tenant_id})
    user_list = await cursor.to_list(length=None)

    for user in user_list:
        final_user_map[user["_id"]] = UserModel(**user)

    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(UserMap(users=final_user_map)))


@router.get("/searchTitles", response_model=list[str],
            response_description="Search threads by query and get title")
async def search_titles(request: Request, query: str, session: SessionContainer = Depends(verify_session())) -> \
        (list)[str]:
    result = await thread_semantic_search(query)
    titles = [doc["title"] for doc in result]
    return JSONResponse(status_code=status.HTTP_200_OK, content=titles)


@router.get("/searchThreads", response_model=ThreadsModel,
            response_description="Search threads by query and get matching threads")
async def search_threads(request: Request, query: str, session: SessionContainer = Depends(verify_session())):
    # Search threads in MongoDB by query
    threads_collection = request.app.mongodb["threads"]
    tenant_id = await get_tenant_id(session)
    # threads = await keyword_search(query, threads_collection)
    result = await thread_semantic_search(query)

    filtered_threads = []
    for doc in result:
        filtered_threads.append(await get_mongo_document({"title": doc["title"]},
                                                         threads_collection,
                                                         tenant_id=tenant_id))
    return_threads = jsonable_encoder(ThreadsModel(threads=filtered_threads))
    # print(return_threads)
    return JSONResponse(status_code=status.HTTP_200_OK, content=return_threads)


@router.get("/threadTypes", response_model=List[ThreadType],
            response_description="Get all thread types")
async def tt(request: Request,
             session: SessionContainer = Depends(verify_session())):
    # Get all thread types
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(THREADTYPES))


@router.get("/threadsInfo", response_model=ThreadsInfo,
            response_description="Get all thread titles and corresponding types")
async def ti(request: Request,
             session: SessionContainer = Depends(verify_session())):
    tenant_id = await get_tenant_id(session)
    # Get all thread titles from MongoDB
    threads = await get_mongo_documents(
        request.app.mongodb["threads"],
        tenant_id=tenant_id)

    info: dict[str, ThreadType] = {}
    for thread in threads:
        info[thread["title"]] = thread["type"]

    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(ThreadsInfo(info=info)))


async def get_unfiltered_newsfeed(tenant_id):
    result = asyncdb.threads_collection.aggregate(
        [
            {
                "$match": {"tenant_id": tenant_id}
            },
            {
                "$lookup": {
                    "from": "users",
                    "localField": "creator_id",
                    "foreignField": "_id",
                    "as": "creator"
                }
            },
            {
                "$unwind": "$creator"
            },
            {
                "$project": {
                    "_id": 1,
                    "title": 1,
                    "type": 1,
                    "created_date": 1,
                    "headline": 1,
                    "creator._id": 1,
                    "creator.name": 1,
                    "creator.picture": 1,
                    "creator.email": 1,
                    "creator.last_login": 1
                }
            }
        ]
    )
    return result


async def get_filtered_newsfeed(user_id, tenant_id, bookmark, read, unfollow, upvote):
    pipeline = [
    {
        "$match": {
            "tenant_id": tenant_id,
            "user_id": user_id,
            "$or": [
                {"bookmark": bookmark},
                {"read": read},
                {"unfollow": unfollow},
                {"upvote": upvote}
              ]
        }
    },
    {
        "$lookup": {
            "from": "threads",
            "localField": "thread_id",
            "foreignField": "_id",
            "as": "threads"
        }
    },
    {
        "$unwind": "$threads"
    },
    {
        "$lookup": {
            "from": "users",
            "localField": "threads.creator_id",
            "foreignField": "_id",
            "as": "threads.creator"
        }
    },
    {
        "$unwind": {
            "path": "$threads.creator"
        }
    },
    {
        "$addFields": {
          "threads.bookmark": "$bookmark",
	      "threads.read": "$read",
          "threads.upvote":"$upvote",
	      "threads.unfollow":"$unfollow"
        },
    },
    { "$replaceRoot": { "newRoot": "$threads" } },
    {
        "$project": {
            "_id": 1,
            "title": 1,
            "type": 1,
            "created_date": 1,
            "headline": 1,
            "creator._id": 1,
            "creator.name": 1,
            "creator.picture": 1,
            "creator.email": 1,
            "creator.last_login": 1,
            "bookmark": 1,
            "unfollow":1,
            "read":1,
            "upvote":1
        }
    }
]
    #print(pipeline)
    result = asyncdb.user_thread_flags_collection.aggregate(pipeline)
    return result


@router.get("/newsfeed", response_model=ThreadsMetaData,
            response_description="Get news feed as  data for all threads")
async def filter(
        bookmark: bool = False,
        read: bool = False,
        unfollow: bool = False,
        upvote: bool = False,
        session: SessionContainer = Depends(verify_session())
):
    user_id = session.get_user_id()
    tenant_id = await get_tenant_id(session)

    if bookmark or unfollow or read or upvote:
        aggregate = await get_filtered_newsfeed(
            user_id=user_id,
            tenant_id=tenant_id,
            bookmark=bookmark,
            read=read,
            unfollow=unfollow,
            upvote=upvote)

    else:
        aggregate = await get_unfiltered_newsfeed(tenant_id=tenant_id)

    aggregate = await aggregate.to_list(None)
    print(aggregate.__len__() )
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(ThreadsMetaData(metadata=aggregate)))


async def create_new_block(block: CreateBlockModel, user_id,tenant_id:str):
    user_info = await asyncdb.users_collection.find_one({"_id": user_id})
    thread_collection = asyncdb.threads_collection
    thread_id = block.parent_thread_id
    # thread = await get_mongo_document({"_id": thread_id}, thread_collection, tenant_id)
    # if not thread:
    #     raise HTTPException(status_code=404, detail="Thread not found")
    # if 'num_blocks' not in thread.keys():
    #     thread['num_blocks'] = 0
    #create the new block
    # pos = thread["num_blocks"]
    pos = await get_blocks_count(thread_id, asyncdb.blocks_collection) + 1
    blocks_collection = asyncdb.blocks_collection
    if user_info is None:
        return None
    block = block.model_dump()
    new_block = BlockModel(**block,tenant_id=tenant_id, creator_id=user_id, block_pos_in_parent=pos,position=[PositionModel(position=pos, thread_id=thread_id)])
    await create_mongo_document(jsonable_encoder(new_block), blocks_collection)
    
    #now update the thread block count
    await update_mongo_document_fields({"_id": thread_id}, {"num_blocks": pos + 1}, thread_collection)
     
    # TODO: Implement AI headline generation
    #generate_single_thread_headline(thread, thread_collection, use_ai=False)

    return BlockWithCreator(**new_block.model_dump(), creator=UserModel(**user_info))

# Get blocks count in a collection for a given thread
async def get_blocks_count(thread_id, collection):
    return await collection.count_documents({"parent_thread_id": thread_id})

async def get_thread_from_db(thread_id, tenant_id):
   try:
    pipeline = [
        {
            '$match': {
                '_id': thread_id, 
                'tenant_id': tenant_id
            }
        }, {
            '$lookup': {
                'from': 'blocks', 
                'localField': '_id', 
                'foreignField': 'child_thread_id', 
                'as': 'content1'
            }
        }, {
            '$lookup': {
                'from': 'blocks', 
                'localField': '_id', 
                'foreignField': 'parent_thread_id', 
                'as': 'content2'
            }
        }, {
            '$set': {
                'content': {
                    '$concatArrays': [
                        '$content1', '$content2'
                    ]
                }
            }
        }, {
            '$unset': [
                'content1', 'content2'
            ]
        }, {
            '$addFields': {
                'content': {
                    '$cond': {
                        'if': {
                            '$eq': [
                                {
                                    '$size': '$content'
                                }, 0
                            ]
                        }, 
                        'then': [
                            {}
                        ], 
                        'else': '$content'
                    }
                }
            }
        }, {
            '$unwind': '$content'
        }, {
            '$sort': {
                'content.block_pos_in_child': 1
            }
        }, {
            '$lookup': {
                'from': 'users', 
                'localField': 'content.creator_id', 
                'foreignField': '_id', 
                'as': 'content.creator'
            }
        }, {
            '$addFields': {
                'content.creator': {
                    '$cond': {
                        'if': {
                            '$eq': [
                                {
                                    '$size': '$content.creator'
                                }, 0
                            ]
                        }, 
                        'then': [
                            {}
                        ], 
                        'else': '$content.creator'
                    }
                }
            }
        }, {
            '$unwind': {
                'path': '$content.creator'
            }
        }, {
            '$group': {
                '_id': '$_id', 
                'created_date': {
                    '$first': '$created_date'
                }, 
                'type': {
                    '$first': '$type'
                }, 
                'title': {
                    '$first': '$title'
                }, 
                'headline': {
                    '$first': '$headline'
                }, 
                'last_modified': {
                    '$first': '$last_modified'
                }, 
                'tenant_id': {
                    '$first': '$tenant_id'
                }, 
                'creator_id': {
                    '$first': '$creator_id'
                }, 
                'content': {
                    '$push': '$content'
                }
            }
        }, {
            '$lookup': {
                'from': 'users', 
                'localField': 'creator_id', 
                'foreignField': '_id', 
                'as': 'creator'
            }
        }, {
            '$unwind': '$creator'
        }, {
            '$project': {
                '_id': 1, 
                'title': 1, 
                'type': 1, 
                'created_date': 1, 
                'headline': 1, 
                'content': 1, 
                'creator._id': 1, 
                'creator.name': 1, 
                'creator.picture': 1, 
                'creator.email': 1, 
                'creator.last_login': 1
            }
        }
    ]  
    result = asyncdb.threads_collection.aggregate(pipeline)
    thread = await result.to_list(None)
    #print(thread[0]["content"][0])
    # if not 'creator_id' in thread[0]["content"][0].keys():
    #     thread[0]["content"] = None
    #print(thread[0]["content"][0])
    return thread
   except Exception as e:
        logger.error(e,exc_info=True)
        return None
    


@router.post("/blocks", response_model=BlockWithCreator, response_description="Create a new block")
async def create(request: Request, thread_title: str, block: CreateBlockModel = Body(...),
                 session: SessionContainer = Depends(verify_session())):
    try:
        # Logic to store the block in MongoDB backend database
        # Index the block by userId
 
     user_id = session.get_user_id()
     tenant_id = await get_tenant_id(session)
     thread = await get_mongo_document(
                 {"title": thread_title},
                 request.app.mongodb["threads"],
                 tenant_id=tenant_id
             )
 
     if not thread:
         return JSONResponse(status_code=404, content={"message": "Thread with ${thread_title} not found"})
 
     thread_id = thread["_id"]

     new_block = await create_new_block(block, user_id, tenant_id)

     user_thread_flag = await get_mongo_document({"thread_id": thread_id, "user_id": user_id},
                                                 request.app.mongodb["user_thread_flags"], tenant_id)
 
    #  TODO:
     if user_thread_flag:
         user_thread_flag["read"] = False
         updated_user_thread_flags = await update_mongo_document_fields(
             {"thread_id": thread_id, "user_id": user_id},
             jsonable_encoder(user_thread_flag),
             request.app.mongodb["user_thread_flags"])
 
    #  ret_thread = await get_thread_from_db(thread_id, tenant_id)
     
     return  JSONResponse(status_code=status.HTTP_201_CREATED,
                         content=jsonable_encoder(new_block)
             )
    except Exception as e:
        print(e)
        return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})


@router.put("/blocks/{id}", response_model=FullThreadInfo, response_description="Update a block")
async def update(request: Request, id: str, thread_title: str, block: UpdateBlockModel = Body(...),
                 session: SessionContainer = Depends(verify_session())):
    
    print("\nReceived request to update block")
    thread_collection = request.app.mongodb["threads"]
    block_collection = request.app.mongodb["blocks"]

    # Logic to store the block in MongoDB backend database
    # Index the block by userId
    input_block = block.model_dump()

    block = await get_block_by_id(id, block_collection)
    # TODO: Check if the block exists
    block = block["content"]
    user_id = session.get_user_id()
    tenant_id = await get_tenant_id(session)

    if block["creator_id"] != user_id:
        return JSONResponse(status_code=403, content={"message": "You are not authorized to update this thread"})

    # new_block_dict = new_block.model_dump()
    # new_block_dict["id"] = str(new_block_dict["id"])
    # to store the block as a json string in the db
    # we need the following. We have chose to insert
    # the block as a dictionary object in the db
    # json_new_block = json_util.dumps(new_block_dict)
    thread = await get_mongo_document({"title": thread_title}, thread_collection, tenant_id)
    if not thread:
        return JSONResponse(status_code=404, content={"message": "Thread with ${thread_title} not found"})

    update_block = block
    update_block["content"] = input_block["content"]

    # change new_block_dict to json_new_block if you want to store
    # block as a json string in the db
    for content in thread["content"]:
        if content["_id"] == block["_id"]:
            content["content"] = update_block["content"]

    updated_thread = await update_mongo_document_fields({"_id": thread["_id"]}, thread, thread_collection)

    user_thread_flag = await get_mongo_document({"thread_id": thread["_id"], "user_id": user_id},
                                                request.app.mongodb["user_thread_flags"], tenant_id)

    if user_thread_flag:
        user_thread_flag["read"] = False
        updated_user_thread_flags = await update_mongo_document_fields(
            {"thread_id": thread["_id"], "user_id": user_id},
            jsonable_encoder(user_thread_flag),
            request.app.mongodb["user_thread_flags"])

    ret_thread = await get_thread_from_db(updated_thread["_id"], tenant_id)

    return JSONResponse(status_code=status.HTTP_201_CREATED,
                        content=jsonable_encoder(ret_thread[0]))

@router.put("/blocks/{id}/position", response_model=UpdateBlockPositionModel, response_description="Update a block position")
async def update_block_position(request: Request, id: str, block_position: UpdateBlockPositionModel = Body(...),
                 session: SessionContainer = Depends(verify_session())):
    print("\nReceived request to update block position")
    block_collection = request.app.mongodb["blocks"]
    block = await get_block_by_id(id, block_collection)

    user_id = session.get_user_id()
    tenant_id = await get_tenant_id(session)

    if block["creator_id"] != user_id:
        return JSONResponse(status_code=403, content={"message": "You are not authorized to update this block"})
    
    block_id = block_position.block_id
    new_position = block_position.new_position
    old_position = block_position.position
    #parent thread of the block
    thread_id = block_position.thread_id

    if(old_position < new_position):
      new_position = new_position - 1

    
    # get the block to be moved to the new position
    block_to_move = await get_block_by_id(block_id, block_collection)

    if block_to_move["creator_id"] != user_id:
        return JSONResponse(status_code=403, content={"message": "You are not authorized to update this block"})
    
    # Remove the block from the old position and update the position of the blocks in the thread 
    # get the blocks in the parent thread
    blocks = await get_mongo_documents({"parent_thread_id": thread_id}, block_collection, tenant_id)

    # get the block to be moved
    block_to_move = blocks






@router.post("/blocks/child", response_model=FullThreadInfo, response_description="Create a new child thread from a block")
async def child_thread(request: Request,
                       child_thread_data: CreateChildThreadModel = Body(...),
                       session: SessionContainer = Depends(verify_session())):
    # try:
      print("\n 1. Received request to create child thread")
      thread_collection = request.app.mongodb["threads"]
      block_collection = request.app.mongodb["blocks"]
      child_thread = child_thread_data.model_dump()
  
      parent_block_id = child_thread["parent_block_id"]
      parent_thread_id = child_thread["parent_thread_id"]
  
    
      print("\n 2. Fetching parent block:", parent_block_id)
      # fetch the parent block
      parentBlock = await get_block_by_id(parent_block_id, block_collection)
      if not parentBlock:
          return JSONResponse(status_code=404, content={"message": "block with id ${parent_block_id} not found"})
      
      if parentBlock["child_thread_id"] != "":
          print("\n 2.1 Can't create child thread for this block. Block already has a child thread")
          return JSONResponse(status_code=400, content={"message": "block already has a child thread"})
  
      print("\n 3. Parent block found")
      # create a new child thread
      thread_title = jsonable_encoder(child_thread)["title"]
      thread_type = jsonable_encoder(child_thread)["type"]
      user_id = session.get_user_id()

      print("\n 4. Fetching tenant id")
      tenant_id = await get_tenant_id(session)

      print("\n 5. Creating new child thread")
  
      created_child_thread = await create_child_thread(thread_collection=thread_collection,
                                                       parent_block_id=parent_block_id,
                                                       parent_thread_id=parent_thread_id,
                                                       thread_title=thread_title,
                                                       thread_type=thread_type,
                                                       user_id=user_id, tenant_id=tenant_id, parentBlock=BlockModel(**parentBlock))
      
    
    
      print("\n 6. Child thread created, Fetching child thread from db")
      ret_thread = await get_thread_from_db(created_child_thread["_id"], tenant_id)
      
      return JSONResponse(status_code=status.HTTP_201_CREATED,
                          content=jsonable_encoder(ret_thread[0]))
      
    # except HTTPException as e:
    #     return JSONResponse(
    #         status_code=e.status_code,
    #         content={"message": e.detail}
    #     )
    # except Exception as e:
    #   print(e)
    #   return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})


@router.post("/threads", response_model=FullThreadInfo, response_description="Create a new thread")
async def create_th(request: Request, thread_data: CreateThreadModel = Body(...),
                    session: SessionContainer = Depends(verify_session())):
   try:
    print("\n ------------- Creating thread -------------")
     # Create a new thread in MongoDB using the thread_data
    # Index the thread by userId
    userId = session.get_user_id()
    
    tenant_id = await get_tenant_id(session)

    thread_title = jsonable_encoder(thread_data)["title"]
    thread_type = jsonable_encoder(thread_data)["type"]
    #content = []
    #if jsonable_encoder(thread_data)["content"] is not None: 
    #    content = jsonable_encoder(thread_data)["content"]

    created_thread = await create_new_thread(userId, tenant_id, thread_title, thread_type,parent_block_id=None)

    print(f"\n\nCreated thread: {created_thread}\n\n")
    logger.debug("Getting thread from db")
    ret_thread = await get_thread_from_db(created_thread["_id"], tenant_id)

    print(f'\n\nRet thread: {ret_thread}\n\n')
    if(len(ret_thread) > 0):
      thread = ret_thread[0]
      if(thread['content'] is not None and len(thread['content']) >0 and thread['content'][0].get('_id') is None):
        # Remove the content key if it is empty
        thread.pop('content')
        
      
    #print(ret_thread[0])
    return JSONResponse(status_code=status.HTTP_201_CREATED,
                        content=jsonable_encoder(thread))
   except Exception as e:
         logger.error(e,exc_info=True)
         return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})


@router.get("/threads/{id}", response_model=FullThreadInfo, response_description="Get a thread by id")
async def get_thread_id(request: Request, 
                        id: str,
                        session: SessionContainer = Depends(verify_session())
                        ):
    
    tenant_id = await get_tenant_id(session)
    thread_list = await get_thread_from_db(id, tenant_id)
    if not thread_list:
        return JSONResponse(status_code=404, content={"message": "Thread not found"})
    
    thread_content = jsonable_encoder((thread_list[0]))
   
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=thread_content)


@router.put("/threads/{id}", response_model=FullThreadInfo, response_description="Update a thread by id")
async def update_th(request: Request, id: str, thread_data: UpdateThreadTitleModel = Body(...),
                    session: SessionContainer = Depends(verify_session())):
    # Create a new thread in MongoDB using the thread_data
    # Index the thread by user_id
    user_id = session.get_user_id()
    tenant_id = await get_tenant_id(session)

    thread_collection = request.app.mongodb["threads"]

    old_thread = await get_mongo_document({"_id": id}, thread_collection, tenant_id)
    if not old_thread:
        return JSONResponse(status_code=404, content={"message": "Thread not found"})

    if old_thread["creator_id"] != user_id:
        return JSONResponse(status_code=403, content={"message": "You are not authorized to update this thread"})

    thread_title = jsonable_encoder(thread_data)["title"]
    # content = jsonable_encoder(thread_data)["content"]

    await thread_collection.update_one({'_id': id}, {"$set": {"title": thread_title}})
    updated_thread = await get_mongo_document({"_id": id}, thread_collection, tenant_id)

    ret_thread = await get_thread_from_db(updated_thread["_id"], tenant_id)
    return JSONResponse(status_code=status.HTTP_201_CREATED,
                        content=jsonable_encoder(ret_thread[0]))






@router.post("/thread/flag", response_model=UserThreadFlagModel, response_description="Create a new thread flag")
async def create_tf(request: Request, thread_read_data: CreateUserThreadFlagModel = Body(...),
                    session: SessionContainer = Depends(verify_session())):
    # Create a new thread in MongoDB using the thread_data
    # Index the thread by user_id
    user_id = session.get_user_id()
    tenant_id = await get_tenant_id(session)

    thread_id = jsonable_encoder(thread_read_data)["thread_id"]
    read = jsonable_encoder(thread_read_data).get("read", None)
    unfollow = jsonable_encoder(thread_read_data).get("unfollow", None)
    bookmark = jsonable_encoder(thread_read_data).get("bookmark", None)
    upvote = jsonable_encoder(thread_read_data).get("upvote", None)

    thread = await get_mongo_document({"_id": thread_id}, request.app.mongodb["threads"], tenant_id)
    if not thread:
        return JSONResponse(status_code=404, content={"message": "Thread not found"})
    if tenant_id != jsonable_encoder(thread)["tenant_id"]:
        return JSONResponse(status_code=403, content={"message": "You are not authorized to update this thread"})

    user_thread_flag = await get_mongo_document({"thread_id": thread_id, "user_id": user_id},
                                                request.app.mongodb["user_thread_flags"], tenant_id)
    if not user_thread_flag:
        user_thread_flag_doc = UserThreadFlagModel(
            user_id=user_id,
            thread_id=thread_id,
            tenant_id=tenant_id,
            read=read if read else False,
            unfollow=unfollow if unfollow else False,
            bookmark=bookmark if bookmark else False,
            upvote=upvote if upvote else False
        )
        user_thread_flag_jsonable = jsonable_encoder(user_thread_flag_doc)
        await create_mongo_document(user_thread_flag_jsonable, request.app.mongodb["user_thread_flags"])

        return JSONResponse(status_code=status.HTTP_200_OK, content=user_thread_flag_jsonable)

    user_thread_flag["read"] = read if read is not None else user_thread_flag["read"]
    user_thread_flag["unfollow"] = unfollow if unfollow is not None else user_thread_flag["unfollow"]
    user_thread_flag["bookmark"] = bookmark if bookmark is not None else user_thread_flag["bookmark"]
    user_thread_flag["upvote"] = upvote if upvote is not None else user_thread_flag["upvote"]

    await request.app.mongodb["user_thread_flags"].update_one(
        {"thread_id": thread_id, "user_id": user_id},
        {"$set": user_thread_flag}
    )

    updated_user_thread_flag = await get_mongo_document({"thread_id": thread_id, "user_id": user_id},
                                                        request.app.mongodb["user_thread_flags"], tenant_id)

    return JSONResponse(status_code=status.HTTP_200_OK, content=jsonable_encoder(updated_user_thread_flag))