import datetime as dt
import re
import time
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

from utils.scrapper import getLinkMeta
from utils.db import get_creator_block_by_id, get_mongo_document, get_mongo_documents, get_tenant_id, update_mongo_document_fields, asyncdb, \
    create_mongo_document, delete_mongo_document
from utils.db import get_mongo_documents_by_date, get_user_name, get_block_by_id
from utils.headline import generate_single_thread_headline
from .child_thread import create_child_thread
from .child_thread import create_new_thread
from .models import BlockModel, CreateBlockModel, FullThreadInfo, LinkMetaModel, UpdateBlockModel, UpdateBlockPositionModel, UserMap, UserModel, UserThreadFlagModel, CreateUserThreadFlagModel, \
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
                    "created_at": 1,
                    "headline": 1,
                    "last_modified": 1,
                    "creator._id": 1,
                    "creator.name": 1,
                    "creator.picture": 1,
                    "creator.email": 1,
                    "creator.last_login": 1,

                }
            },
            {
                "$sort": {
                    "last_modified": -1
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
                "threads.upvote": "$upvote",
                "threads.unfollow": "$unfollow"
            },
        },
        {"$replaceRoot": {"newRoot": "$threads"}},
        {
            "$project": {
                "_id": 1,
                "title": 1,
                "type": 1,
                "created_at": 1,
                "headline": 1,
                "last_modified": 1,
                "creator._id": 1,
                "creator.name": 1,
                "creator.picture": 1,
                "creator.email": 1,
                "creator.last_login": 1,
                "bookmark": 1,
                "unfollow": 1,
                "read": 1,
                "upvote": 1
            }
        },
        {
            "$sort": {
                "last_modified": -1
            }
        }
    ]
    # print(pipeline)
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
    print(aggregate.__len__())
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(ThreadsMetaData(metadata=aggregate)))


async def create_new_block(block: CreateBlockModel, user_id, tenant_id: str, id: str = None, created_at: str = None):
    try:
        # print("profiling performance 1.1")
        # start_time = time.time()

        user_info = await asyncdb.users_collection.find_one({"_id": user_id})
        thread_collection = asyncdb.threads_collection
        thread_id = block.main_thread_id

        pos = await get_blocks_count(thread_id)

        blocks_collection = asyncdb.blocks_collection
        content = block.content
        if user_info is None:
            return None
        block = block.model_dump()
        if created_at is not None:
            block["created_at"] = created_at
        if id is not None:
            block["_id"] = id

        lastUrlAvailableInContent = ''

        # id content is not None or empty.
        # then check if there is valid url in the content text. If there are multiple url available then take the last one
        if content is not None:
            urls = re.findall(
                'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', content)
            if len(urls) > 0:
                print(f'\n 👉 Link detected count: {len(urls)} ')
                lastUrlAvailableInContent = urls[-1]
            else:
                print(f'\n 👉 No link detected in the content', content)

        linkMeta = None
        # if lastUrlAvailableInContent is not empty then get the meta data of the url
        if lastUrlAvailableInContent != '':
            print(f'\n 👉 Fetching link meta for: {lastUrlAvailableInContent} ')
            # get the meta data of the url
            rawMeta = getLinkMeta(lastUrlAvailableInContent)
            if rawMeta is not None:
                print(f'\n 👉 Link meta fetched: {rawMeta} ')
                image = rawMeta.get('image', None)
                if image is None:
                    image = rawMeta.get('og:image', None)
                linkMeta = LinkMetaModel(**rawMeta, image=image)

        new_block = BlockModel(**block, tenant_id=tenant_id,
                               creator_id=user_id, position=pos, link_meta=linkMeta)
        await create_mongo_document(id=new_block.id,
                                    document=jsonable_encoder(new_block),
                                    collection=blocks_collection)

        thread_last_modified = str(new_block.created_at)
        # now update the thread block count
        num_blocks = await get_blocks_count(thread_id)

        # print(f"profiling 1.1 Time elapsed for get_blocks_count(): {time.time() - start_time:.6f} seconds")
        # print("profiling performance 1.2")
        # start_time = time.time()

        await update_mongo_document_fields({"_id": thread_id}, {"num_blocks": num_blocks, "last_modified": thread_last_modified}, thread_collection)

        await generate_single_thread_headline(thread_id=thread_id, use_ai=False)

        # print(f"profiling 1.2 Time elapsed for get_blocks_count(): {time.time() - start_time:.6f} seconds")

        return BlockWithCreator(**new_block.model_dump(), creator=UserModel(**user_info))

        # Get blocks count in a collection for a given thread
    except Exception as e:
        logger.error("❌ Error in create_new_block()", exc_info=True)
        raise HTTPException(status_code=500, detail="Internal Server Error")


async def get_blocks_count(thread_id):
    count = 0
    count += await asyncdb.blocks_collection.count_documents({"main_thread_id": thread_id})
    count += await asyncdb.blocks_collection.count_documents({"child_thread_id": thread_id})
    return count


async def get_thread_from_db(thread_id, tenant_id):
    try:
        pipeline = [
            {
                '$match': {
                    '_id': thread_id,
                    'tenant_id': tenant_id,
                }
            }, {
                '$lookup': {
                    'from': 'blocks',
                    'localField': '_id',
                    'foreignField': 'child_thread_id',
                    'as': 'default_block'
                }
            }, {
                '$addFields': {
                    'default_block': {
                        '$cond': {
                            'if': {
                                '$eq': [
                                    {
                                        '$size': '$default_block'
                                    }, 0
                                ]
                            },
                            'then': [
                                {}
                            ],
                            'else': '$default_block'
                        }
                    }
                }
            }, {
                '$unwind': {
                    'path': '$default_block'
                }
            }, {
                '$lookup': {
                    'from': 'users',
                    'localField': 'default_block.creator_id',
                    'foreignField': '_id',
                    'as': 'default_block.creator'
                }
            }, {
                '$addFields': {
                    'default_block.creator': {
                        '$cond': {
                            'if': {
                                '$eq': [
                                    {
                                        '$size': '$default_block.creator'
                                    }, 0
                                ]
                            },
                            'then': [
                                {}
                            ],
                            'else': '$default_block.creator'
                        }
                    }
                }
            }, {
                '$unwind': {
                    'path': '$default_block.creator'
                }
            }, {
                '$lookup': {
                    'from': 'blocks',
                    'localField': '_id',
                    'foreignField': 'main_thread_id',
                    'as': 'content'
                }
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
                    'content.position': 1
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
                    'created_at': {
                        '$first': '$created_at'
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
                    },
                    'parent_block_id': {
                        '$first': '$parent_block_id'
                    },
                    'default_block': {
                        '$first': '$default_block'
                    },
                    'task_status': {
                        '$first': '$task_status'
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
                    'task_status': 1,
                    'default_block': 1,
                    'created_at': 1,
                    'headline': 1,
                    'content': 1,
                    'parent_block_id': 1,
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
        # print(thread[0]["content"][0])

        # TODO: Since function is intended to return a single thread object,
        # not sure it should return a empty list here
        if len(thread) == 0:
            return []
        thread_to_return = thread[0]

        # Check if thread contains and empty default block
        # If yes, then remove the key from object
        if thread_to_return['default_block'].keys():
            if not '_id' in thread_to_return['default_block'].keys():
                thread_to_return['default_block'] = None

        if not 'content' in thread_to_return.keys():
            return thread_to_return
        if not 'creator_id' in thread_to_return["content"][0].keys():
            thread_to_return["content"] = None

        return thread_to_return
    except Exception as e:
        logger.error(e, exc_info=True)
        return None


@router.post("/blocks", response_model=BlockWithCreator, response_description="Create a new block")
async def create(request: Request, thread_title: str, block: CreateBlockModel = Body(...),
                 session: SessionContainer = Depends(verify_session())):
    start_time = time.time()
    try:
        # Logic to store the block in MongoDB backend database
        # Index the block by userId
        # print("profiling performance 0")
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
        # print("profiling performance 1")
        part_1 = time.time()
        print(
            f"profiling Time elapsed for first part(): { part_1 - start_time:.6f} seconds")
        new_block = await create_new_block(block, user_id, tenant_id)

        if not new_block:
            return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})
        # print("profiling performance 2")
        part_2 = time.time()
        print(
            f"profiling Time elapsed for create_new_block(): {part_2 - part_1:.6f} seconds")
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
        end_time = time.time()
        print(
            f"profiling Time elapsed for user_flags(): {end_time - part_2:.6f} seconds")
        print(
            f"profiling Time elapsed for create block(): {end_time - start_time:.6f} seconds")
        return JSONResponse(status_code=status.HTTP_201_CREATED,
                            content=jsonable_encoder(new_block)
                            )
    except Exception as e:
        print(e)
        return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})


# TODO: It should return BlockWithCreator model
@router.put("/blocks/{id}", response_model=BlockModel, response_description="Update a block")
async def update(request: Request, id: str, thread_title: str, block: UpdateBlockModel = Body(...),
                 session: SessionContainer = Depends(verify_session())):

    print("\nReceived request to update block")
    thread_collection = request.app.mongodb["threads"]
    block_collection = request.app.mongodb["blocks"]

    # Logic to store the block in MongoDB backend database
    # Index the block by userId
    input_block = block.model_dump()
    block_content = input_block["content"]
    bloc_position = input_block["position"]

    print("\n Fetching block from db using Id:", id)
    block_in_db = await get_block_by_id(id, block_collection)

    if not block_in_db:
        return JSONResponse(status_code=404, content={"message": "Block with ${id} not found"})

    user_id = session.get_user_id()
    tenant_id = await get_tenant_id(session)

    if block_in_db["creator_id"] != user_id:
        return JSONResponse(status_code=403, content={"message": "You are not authorized to update this thread"})

    update_block = block_in_db
    update_block["content"] = input_block["content"]

    if (block_content is not None):
        print("\n Updating block content")
        update_block["content"] = block_content

    if (bloc_position is not None):
        print("\n Updating block position")
        update_block["position"] = bloc_position

    update_block["last_modified"] = str(dt.datetime.now())

    print("\n Updating block in db")

    updated_block = await update_mongo_document_fields({"_id": id}, update_block, block_collection)

    logger.debug("\n Block updated in DB")
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(updated_block))

# API to update the block task status


@router.put("/blocks/{id}/taskStatus", response_model=BlockWithCreator, response_description="Update a block task status")
async def update_block_task_status(request: Request, id: str, task_status: str = Body(...),
                                   session: SessionContainer = Depends(verify_session())):
    try:
        print('🏁 -------------------- Update Block Task Status -------------------- 🏁')
        if (task_status not in ['todo', 'inprogress', 'done']):
            return JSONResponse(status_code=400, content={"message": "Invalid task status"})

        block_collection = request.app.mongodb["blocks"]
        print('\n👉 Fetching block from db using Id:', id)
        block_to_update = await get_block_by_id(id, block_collection)

        if not block_to_update:
            return JSONResponse(status_code=404, content={"message": f"Block with ${id} not found"})

        user_id = session.get_user_id()

        if block_to_update["creator_id"] != user_id:
            return JSONResponse(status_code=403, content={"message": "You are not authorized to update this block"})

        print('\n👉 Updating block task status in db')

        await update_mongo_document_fields({"_id": id}, {"task_status": task_status, 'last_modified': str(dt.datetime.now())}, block_collection)

        updated_block = await get_creator_block_by_id(id, block_collection)

        return JSONResponse(status_code=status.HTTP_200_OK,
                            content=jsonable_encoder(updated_block))

    except Exception as e:
        logger.error(e, exc_info=True)
        return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})


@router.put("/blocks/{id}/position", response_model=UpdateBlockPositionModel, response_description="Update a block position")
async def update_block_position(request: Request, id: str, block_position: UpdateBlockPositionModel = Body(...),
                                session: SessionContainer = Depends(verify_session())):
    try:
        print('🏁 -------------------- Update Block Position -------------------- 🏁')
        block_collection = request.app.mongodb["blocks"]

        print('\n👉 Fetching block from db using having main_thread_id:', id)
        block_id = block_position.block_id
        new_position = block_position.new_position
        block_to_move = await get_block_by_id(block_id, block_collection)

        if not block_to_move:
            return JSONResponse(status_code=404, content={"message": f"Block with ${id} not found"})

        user_id = session.get_user_id()

        # TODO: Check if tenant_id is required here. Ideally it should be required
        tenant_id = await get_tenant_id(session)

        # TODO: Who is allowed to update the block position? Thread creator or block creator?
        if block_to_move["creator_id"] != user_id:
            return JSONResponse(status_code=403, content={"message": "You are not authorized to update this block"})

        # main_thread_id of the block
        thread_id = block_to_move["main_thread_id"]

        if not thread_id:
            logger.error("Found a block without threadId. BlockId:", block_id)
            return JSONResponse(status_code=404, content={"message": "Dragged block doesn't have threadId"})

        print('\n👉 Fetching all block from from db having same thread:', thread_id, )

        filter = {'main_thread_id': thread_id}
        sort = list({'position': 1}.items())
        blocks = await block_collection.find(filter=filter, sort=sort).to_list(None)

        if not blocks:
            return JSONResponse(status_code=404, content={"message": f"Blocks with ${thread_id} id not found"})

        print(
            '\n👉 Removing the dragged block from old position. Updated Blocks length:', len(blocks))
        for i in range(len(blocks)):
            print(
                f"  → DB blocks positions {blocks[i]['content']}"),

        # remove the block from the old position
        blocks = [block for block in blocks if block["_id"] != block_id]

        print('\n👉 Block is removed the block from old position: Rest blocks length', len(blocks))

        print(
            f'\n👉 Inserting the block at new position {new_position} in the blocks list')
        # insert the block to the new position
        block_to_move["position"] = new_position
        blocks.insert(new_position, block_to_move)

        # for i in range(len(blocks)):
        #     print(
        #         f"  → New Positions block position from {blocks[i]['content']}"),

        print(
            '\n👉 Block is Inserted at new position in the blocks list: Updated blocks length', len(blocks))

        # update the positions of the blocks in the thread
        print("\n👉 Updating block position in db")
        for i in range(len(blocks)):
            new_block_position = i + 1
            await update_mongo_document_fields({"_id": blocks[i]["_id"]}, {"position": new_block_position, 'last_modified': str(dt.datetime.now())}, block_collection)
            print(
                f"    → Changing block position from {blocks[i]['content']} to {new_block_position}"),

        return JSONResponse(status_code=status.HTTP_200_OK,
                            content=jsonable_encoder(block_to_move))
    except Exception as e:
        logger.error(e, exc_info=True)
        return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})


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
    main_thread_id = child_thread["main_thread_id"]

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

    created_child_thread = await create_child_thread(
        parent_block_id=parent_block_id,
        main_thread_id=main_thread_id,
        thread_title=thread_title,
        thread_type=thread_type,
        user_id=user_id, tenant_id=tenant_id, parentBlock=BlockModel(**parentBlock))

    print("\n 6. Child thread created, Fetching child thread from db")
    ret_thread = await get_thread_from_db(created_child_thread["_id"], tenant_id)

    return JSONResponse(status_code=status.HTTP_201_CREATED,
                        content=jsonable_encoder(ret_thread))

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
        # content = []
        # if jsonable_encoder(thread_data)["content"] is not None:
        #    content = jsonable_encoder(thread_data)["content"]

        created_thread = await create_new_thread(userId, tenant_id, thread_title, thread_type, parent_block_id=None)

        print(f"\n\nCreated thread: {created_thread}\n\n")
        logger.debug("Getting thread from db")
        ret_thread = await get_thread_from_db(created_thread["_id"], tenant_id)

        # print(ret_thread[0])
        return JSONResponse(status_code=status.HTTP_201_CREATED,
                            content=jsonable_encoder(ret_thread))
    except Exception as e:
        logger.error(e, exc_info=True)
        return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})


@router.get("/threads/{id}", response_model=FullThreadInfo, response_description="Get a thread by id")
async def get_thread_id(request: Request,
                        id: str,
                        session: SessionContainer = Depends(verify_session())
                        ):

    tenant_id = await get_tenant_id(session)
    thread = await get_thread_from_db(id, tenant_id)
    if not thread:
        return JSONResponse(status_code=404, content={"message": "Thread not found"})

    thread_content = jsonable_encoder((thread))

    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=thread_content)


@router.put("/threads/{id}", response_model=FullThreadInfo, response_description="Update a thread by id")
async def update_th(request: Request, id: str, thread_data: UpdateThreadTitleModel = Body(...),
                    session: SessionContainer = Depends(verify_session())):
    try:
        # Create a new thread in MongoDB using the thread_data
        # Index the thread by user_id
        user_id = session.get_user_id()
        tenant_id = await get_tenant_id(session)

        thread_collection = request.app.mongodb["threads"]
        print("\nFetching thread from the DB")
        old_thread = await get_mongo_document({"_id": id}, thread_collection, tenant_id)
        if not old_thread:
            return JSONResponse(status_code=404, content={"message": "Thread not found"})

        if old_thread["creator_id"] != user_id:
            return JSONResponse(status_code=403, content={"message": "You are not authorized to update this thread"})

        thread_title = jsonable_encoder(thread_data)["title"]
        # content = jsonable_encoder(thread_data)["content"]

        print("\n Updating the thread in DB")
        await thread_collection.update_one({'_id': id}, {"$set": {"title": thread_title, 'last_modified': str(dt.datetime.now())}})

        print('\n Thread title is updated i DB')
        updated_thread = await get_mongo_document({"_id": id}, thread_collection, tenant_id)

        print('\n Getting updated thread from DB', updated_thread)

        ret_thread = await get_thread_from_db(updated_thread["_id"], tenant_id)
        return JSONResponse(status_code=status.HTTP_200_OK,
                            content=jsonable_encoder(ret_thread))
    except Exception as e:
        logger.error(e, exc_info=True)
        return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})


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
        await create_mongo_document(
            id=user_thread_flag_doc.id,
            document=user_thread_flag_jsonable,
            collection=request.app.mongodb["user_thread_flags"])

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
