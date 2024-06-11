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

from routes.threads.block import updateBlock
from utils.scrapper import getLinkMeta
from utils.db import create_mongo_doc_simple, create_mongo_document_sync, create_or_replace_mongo_doc, get_creator_block_by_id, get_mongo_document, get_mongo_document_sync, get_mongo_documents, get_tenant_id, get_tenant_id_sync, update_fields_mongo_simple, update_mongo_document_fields, asyncdb, syncdb, \
    create_mongo_document, delete_mongo_document, update_mongo_document_fields_sync
from utils.db import get_mongo_documents_by_date, get_user_name, get_block_by_id
from utils.headline import generate_single_thread_headline, set_first_block_as_headline
from .child_thread import create_child_thread
from .child_thread import create_new_thread
from .models import BlockModel, CreateBlockModel, FullThreadInfo, LinkMetaModel, UpdateBlockModel, UpdateBlockPositionModel, UserFilterPreferenceModel, UserMap, UserModel, UserThreadFlagModel, CreateUserThreadFlagModel, \
    UpdateThreadTitleModel, BlockWithCreator
from .models import THREADTYPES, CreateChildThreadModel, ThreadType, \
    ThreadsInfo, ThreadsMetaData, CreateThreadModel, ThreadsModel
from .search import thread_semantic_search
from routes.threads.user_flags import get_user_filter_preferences_from_db, save_user_filter_preferences, set_flags_true_other_users, set_unread_other_users, update_user_flags

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


async def get_unfiltered_newsfeed(tenant_id, user_id):
    default_flags = {"user_id": user_id, "unread": None,
                     "bookmark": None, "upvote": None, "unfollow": None, "mention": None}

    pipeline = [
        {
            '$match': {
                'tenant_id': tenant_id
            }
        },
        # Get all blocks for the thread
        {
            '$lookup': {
                'from': 'blocks',
                'localField': '_id',
                'foreignField': 'main_thread_id',
                'as': 'blocks'
            }
        },
        # Sort the blocks by created_at
        {
            '$set': {
                'blocks': {
                    '$sortArray': {
                        'input': '$blocks',
                        'sortBy': {
                            'created_at': 1
                        }
                    }
                }
            }
        },
        # Take the first block as this is the first block of the thread
        {
            '$addFields': {
                'block': {
                    '$first': '$blocks'
                }
            }
        },
        {
            '$lookup': {
                'from': 'users',
                'localField': 'creator_id',
                'foreignField': '_id',
                'as': 'creator'
            }
        },
        {
            '$unwind': '$creator'
        },
        {
            '$lookup': {
                'from': 'user_thread_flags',
                'localField': '_id',
                'foreignField': 'thread_id',
                'as': 'user_thread_flags',
                'pipeline': [
                    {
                        '$match': {
                            'user_id': user_id
                        }
                    }
                ]
            }
        },
        {
            '$addFields': {
                'user_thread_flags': {
                    '$cond': {
                        'if': {
                            '$eq': [
                                {
                                    '$size': '$user_thread_flags'
                                }, 0
                            ]
                        },
                        'then': default_flags,
                        'else': {
                            '$arrayElemAt': [
                                '$user_thread_flags', 0
                            ]
                        }
                    }
                }
            }
        },
        {
            '$project': {
                '_id': 1,
                'title': 1,
                'type': 1,
                'created_at': 1,
                'headline': 1,
                'last_modified': 1,
                'block': 1,
                'creator._id': 1,
                'creator.name': 1,
                'creator.picture': 1,
                'unread': '$user_thread_flags.unread',
                'bookmark': '$user_thread_flags.bookmark',
                'upvote': '$user_thread_flags.upvote',
                'mention': '$user_thread_flags.mention',
                'unfollow': '$user_thread_flags.unfollow'
            }
        },
        {
            '$sort': {
                'last_modified': -1
            }
        }
    ]

    result = asyncdb.threads_collection.aggregate(pipeline)
    return result


async def get_filtered_newsfeed(user_id, tenant_id, bookmark, unread, unfollow, upvote, mention, searchQuery: str = None,):
    print("🔍 Filtering newsfeed"
          f" bookmark: {bookmark}, unread: {unread}, unfollow: {unfollow}, upvote: {upvote}, mention {mention}, searchQuery: {searchQuery}")

    # If searchQuery is present then search the threads by query
    # Right now the algo to search on basis of semantic search is not ready to we are using bookmark flag to search the threads
    if searchQuery is not None and searchQuery != '':
        bookmark = True
    print(f"🔍 Filtering newsfeed ${bookmark}")
    user_flags = []
    if bookmark:
        user_flags.append({"bookmark": True})
    if unread:
        user_flags.append({"unread": True})
    if unfollow:
        user_flags.append({"unfollow": True})
    if upvote:
        user_flags.append({"upvote": True})
    if mention:
        user_flags.append({"mention": True})

    pipeline = [
        {
            "$match": {
                "tenant_id": tenant_id,
                "user_id": user_id,
                "$and": user_flags
            }
        },
        # Get all blocks for the thread
        {
            '$lookup': {
                'from': 'blocks',
                'localField': '_id',
                'foreignField': 'main_thread_id',
                'as': 'blocks'
            }
        },
        # Sort the blocks by created_at
        {
            '$set': {
                'blocks': {
                    '$sortArray': {
                        'input': '$blocks',
                        'sortBy': {
                            'created_at': 1
                        }
                    }
                }
            }
        },
        # Take the first block as this is the first block of the thread
        {
            '$addFields': {
                'block': {
                    '$first': '$blocks'
                }
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
                "threads.unread": "$unread",
                "threads.upvote": "$upvote",
                "threads.unfollow": "$unfollow",
                "threads.mention": "$mention"
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
                "block": 1,
                "last_modified": 1,
                "creator._id": 1,
                "creator.name": 1,
                "creator.picture": 1,
                "creator.email": 1,
                "creator.last_login": 1,
                "bookmark": 1,
                "unfollow": 1,
                "unread": 1,
                "upvote": 1,
                "mention": 1
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
        unread: bool = False,
        unfollow: bool = False,
        upvote: bool = False,
        mention: bool = False,
        searchQuery: str = None,
        isFilterEnabled: bool = False,
        session: SessionContainer = Depends(verify_session())
):
    user_id = session.get_user_id()
    tenant_id = await get_tenant_id(session)
    if not isFilterEnabled:
        user_flags = await get_user_filter_preferences_from_db(user_id, tenant_id)
        if user_flags:
            bookmark = user_flags.bookmark
            unread = user_flags.unread
            unfollow = user_flags.unfollow
            upvote = user_flags.upvote
            mention = user_flags.mention
            searchQuery = user_flags.searchQuery

    if bookmark or unfollow or unread or upvote or mention or searchQuery:
        aggregate = await get_filtered_newsfeed(
            user_id=user_id,
            tenant_id=tenant_id,
            bookmark=bookmark,
            unread=unread,
            unfollow=unfollow,
            upvote=upvote,
            mention=mention,
            searchQuery=searchQuery
        )

    else:
        aggregate = await get_unfiltered_newsfeed(tenant_id=tenant_id, user_id=user_id)

    aggregate = await aggregate.to_list(None)

    # Save user's filter preferences to db if filter is enabled
    if isFilterEnabled:
        user_flags = {
            "user_id": user_id,
            "bookmark": bookmark,
            "unread": unread,
            "unfollow": unfollow,
            "upvote": upvote,
            "mention": mention,
            'searchQuery': searchQuery
        }
        save_user_filter_preferences(
            user_id, tenant_id, UserFilterPreferenceModel(**user_flags))

    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(ThreadsMetaData(metadata=aggregate)))


def create_new_block(block: CreateBlockModel, user_id, tenant_id: str, id: str = None, created_at: str = None):
    try:
        # print("profiling performance 1.1")
        start_time = time.time()

        user_info = syncdb.users_collection.find_one({"_id": user_id})
        user_time = time.time()
        print(
            f"profiling Time elapsed for user_info(): {user_time - start_time:.6f} seconds")
        thread_collection = syncdb.threads_collection
        thread_id = block.main_thread_id

        pos = get_blocks_count(thread_id)

        blocks_collection = syncdb.blocks_collection
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

            # Check if user mentions are present in the content.
            # If a user is mentioned available then it will be in markdown link format [user_name](@mention?user=user_id)
            # Extract the user_id from the content and update the mention field in the block
            mentions = re.findall(
                r'\[@[^\]]+\]\(@mention\?user=([a-f0-9-]+)\)', content)
            if len(mentions) > 0:
                print(f'\n 👉 User mention detected count: {len(mentions)} ')
                for user_id in mentions:
                    print(f'\n 👉 User mention detected: {user_id} ')
                    update_user_flags(thread_id, user_id,
                                      tenant_id, mention=True)

        #

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
        create_or_replace_mongo_doc(id=new_block.id,
                                    document=jsonable_encoder(new_block),
                                    collection=blocks_collection)

        create_block_time = time.time()
        print(
            f"profiling Time elapsed for create_mongo_document(new_block): {create_block_time - user_time:.6f} seconds")
        thread_last_modified = str(new_block.created_at)
        # now update the thread block count
        num_blocks = get_blocks_count(thread_id)

        # print(f"profiling 1.1 Time elapsed for get_blocks_count(): {time.time() - start_time:.6f} seconds")
        # print("profiling performance 1.2")
        # start_time = time.time()

        update_fields_mongo_simple({"_id": thread_id}, {
                                   "num_blocks": num_blocks, "last_modified": thread_last_modified}, thread_collection)
        num_blocks_time = time.time()
        print(
            f"profiling Time elapsed for update_mongo_document_fields(num_block): {num_blocks_time - create_block_time:.6f} seconds")
        # generate_single_thread_headline(thread_id=thread_id, use_ai=False)
        set_first_block_as_headline(thread_id, num_blocks, content)
        headline_time = time.time()
        print(
            f"profiling Time elapsed for generate_single_thread_headline(): {headline_time - num_blocks_time:.6f} seconds")
        # print(f"profiling 1.2 Time elapsed for get_blocks_count(): {time.time() - start_time:.6f} seconds")

        return BlockWithCreator(**new_block.model_dump(), creator=UserModel(**user_info))

        # Get blocks count in a collection for a given thread
    except Exception as e:
        logger.error("❌ Error in create_new_block()", exc_info=True)
        raise HTTPException(status_code=500, detail="Internal Server Error")


def get_blocks_count(thread_id):
    count = 0
    count += syncdb.blocks_collection.count_documents(
        {"main_thread_id": thread_id})
    count += syncdb.blocks_collection.count_documents(
        {"child_thread_id": thread_id})
    return count


async def get_thread_from_db(thread_id, user_id, tenant_id):
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

        if len(thread) == 0:
            return None
        thread_to_return = thread[0]

        # user is now reading the thread so set unread to false
        update_user_flags(
            thread_to_return["_id"], user_id, tenant_id, unread=False)

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

        tenant_id = get_tenant_id_sync(session)
        tenant_time = time.time()
        print(
            f"profiling Time elapsed for tenant_id(): {tenant_time - start_time:.6f} seconds")
        thread = get_mongo_document_sync(
            {"title": thread_title},
            syncdb.threads_collection,
            tenant_id=tenant_id
        )
        title_time = time.time()
        print(
            f"profiling Time elapsed for get_mongo_document(title_time): {title_time - tenant_time:.6f} seconds")
        if not thread:
            return JSONResponse(status_code=404, content={"message": "Thread with ${thread_title} not found"})

        thread_id = thread["_id"]
        # print("profiling performance 1")
        part_1 = time.time()

        new_block = create_new_block(block, user_id, tenant_id)

        if not new_block:
            return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})
        # print("profiling performance 2")
        part_2 = time.time()
        # print(
        #    f"profiling Time elapsed for create_new_block(): {part_2 - part_1:.6f} seconds")

    #  as we modify a thread, we need to update the user_thread_flags
    # to indicate that the all other users other than the creator have an unread thread:
        # set_flags_true_other_users(thread_id, user_id, tenant_id, unread=True)
        set_unread_other_users(thread_id, user_id, tenant_id)

        end_time = time.time()
        print(
            f"profiling Time elapsed for user_flags(): {end_time - part_2:.6f} seconds")
        print(
            f"profiling Time elapsed for total create block(): {end_time - start_time:.6f} seconds")
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

    block_collection = request.app.mongodb["blocks"]

    # Logic to store the block in MongoDB backend database
    # Index the block by userId
    input_block = block.model_dump()
    block_content = input_block["content"]
    bloc_position = input_block["position"]

    print("\n Fetching block from db using Id:", id)
    user_id = session.get_user_id()
    tenant_id = await get_tenant_id(session)
    block_in_db = await get_block_by_id(id, block_collection)
    if not block_in_db:
        return JSONResponse(status_code=404, content={"message": "Block with ${id} not found"})

    if block_in_db["creator_id"] != user_id:
        return JSONResponse(status_code=403, content={"message": "You are not authorized to update this thread"})

    updated_block = await updateBlock(block_in_db, user_id, tenant_id, block_content, bloc_position)
    if not updated_block:
        return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})

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

        thread_id = updated_block["main_thread_id"]
        tenant_id = await get_tenant_id(session)
        await set_flags_true_other_users(thread_id, user_id, tenant_id, unread=True)

        return JSONResponse(status_code=status.HTTP_200_OK,
                            content=jsonable_encoder(updated_block))

    except Exception as e:
        logger.error(e, exc_info=True)
        return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})

# Api to update the due date on todo type block


@router.put("/blocks/{id}/dueDate", response_model=BlockWithCreator, response_description="Update a block due date")
async def update_block_due_date(request: Request, id: str, due_date: str = Body(...),
                                session: SessionContainer = Depends(verify_session())):
    try:
        print('🏁 -------------------- Update Block Due Date -------------------- 🏁')
        block_collection = request.app.mongodb["blocks"]
        print('\n👉 Fetching block from db using Id:', id)
        block_to_update = await get_block_by_id(id, block_collection)

        if not block_to_update:
            return JSONResponse(status_code=404, content={"message": f"Block with ${id} not found"})

        user_id = session.get_user_id()

        if block_to_update["creator_id"] != user_id:
            return JSONResponse(status_code=403, content={"message": "You are not authorized to update this block"})

        print('\n👉 Updating block due date in db')
        await update_mongo_document_fields({"_id": id}, {"due_date": due_date, 'last_modified': str(dt.datetime.now())}, block_collection)

        updated_block = await get_creator_block_by_id(id, block_collection)

        thread_id = updated_block["main_thread_id"]
        tenant_id = get_tenant_id(session)
        await set_flags_true_other_users(thread_id, user_id, tenant_id, unread=True)

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

        await set_flags_true_other_users(thread_id, user_id, tenant_id, unread=True)

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
    ret_thread = await get_thread_from_db(created_child_thread["_id"], user_id, tenant_id)

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
        user_id = session.get_user_id()

        tenant_id = await get_tenant_id(session)

        thread_title = jsonable_encoder(thread_data)["title"]
        thread_type = jsonable_encoder(thread_data)["type"]
        # content = []
        # if jsonable_encoder(thread_data)["content"] is not None:
        #    content = jsonable_encoder(thread_data)["content"]

        created_thread = await create_new_thread(user_id, tenant_id, thread_title, thread_type, parent_block_id=None)

        print(f"\n\nCreated thread: {created_thread}\n\n")
        logger.debug("Getting thread from db")
        ret_thread = await get_thread_from_db(created_thread["_id"], user_id, tenant_id)

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
    user_id = session.get_user_id()
    thread = await get_thread_from_db(id, user_id, tenant_id)
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

        ret_thread = await get_thread_from_db(updated_thread["_id"], user_id, tenant_id)
        thread_id = ret_thread["_id"]
        await set_flags_true_other_users(thread_id, user_id, tenant_id, unread=True)
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
    unread = jsonable_encoder(thread_read_data).get("unread", None)
    unfollow = jsonable_encoder(thread_read_data).get("unfollow", None)
    bookmark = jsonable_encoder(thread_read_data).get("bookmark", None)
    mention = jsonable_encoder(thread_read_data).get("mention", None)
    upvote = jsonable_encoder(thread_read_data).get("upvote", None)

    thread = await get_mongo_document({"_id": thread_id}, request.app.mongodb["threads"], tenant_id)
    if not thread:
        return JSONResponse(status_code=404, content={"message": "Thread not found"})
    if tenant_id != jsonable_encoder(thread)["tenant_id"]:
        return JSONResponse(status_code=403, content={"message": "You are not authorized to update this thread"})
    print(
        f"🔍 updating thread flag with thread_id {thread_id} user_id {user_id} tenant_id {tenant_id}: unread {unread}, unfollow {unfollow}, bookmark {bookmark}, upvote {upvote}, mention {mention}")
    updated_user_thread_flag = update_user_flags(
        thread_id, user_id, tenant_id, unread, upvote, bookmark, unfollow, mention)
    return JSONResponse(status_code=status.HTTP_200_OK, content=jsonable_encoder(updated_user_thread_flag))

# API to delete thread. only the creator of the thread can delete the thread


@router.delete("/threads/{id}", response_model=bool, response_description="Delete a thread by id")
async def delete_thread(request: Request, id: str, session: SessionContainer = Depends(verify_session())):

    try:
        print('\n🏁 -------------------- Delete Thread -------------------- 🏁')
        user_id = session.get_user_id()
        tenant_id = await get_tenant_id(session)

        thread_collection = request.app.mongodb["threads"]
        block_collection = request.app.mongodb["blocks"]

        print('\n👉 Fetching thread from db using Id:', id)
        thread = await get_mongo_document({"_id": id}, thread_collection, tenant_id)
        if not thread:
            return JSONResponse(status_code=404, content={"message": "Thread not found"})

        if thread["creator_id"] != user_id:
            return JSONResponse(status_code=403, content={"message": "You are not authorized to delete this thread"})

        print('\n👉 Deleting all blocks linked to th thread')
        # delete all the blocks in the thread
        await block_collection.delete_many({"main_thread_id": id})

        print('\n👉 Deleting thread from db')
        # delete the thread
        await thread_collection.delete_one({"_id": id})

        print('\n👉 Unlinking the child blocks from the main thread')
        # Unlink the child blocks from the main thread
        await block_collection.update_many({"child_thread_id": id}, {"$set": {"child_thread_id": ""}})

        return JSONResponse(status_code=status.HTTP_200_OK, content=True)
    except Exception as e:
        logger.error(e, exc_info=True)
        return JSONResponse(status_code=500, content={"message": "Something went wrong. Please try again later."})


# API to get user filter preferences
@router.get("/user/news-filter", response_model=UserFilterPreferenceModel, response_description="Get user filter preferences")
async def get_user_filter_preferences(session: SessionContainer = Depends(verify_session())):
    user_id = session.get_user_id()
    tenant_id = await get_tenant_id(session)

    user_flags = await get_user_filter_preferences_from_db(user_id, tenant_id)
    if user_flags:
        return JSONResponse(status_code=status.HTTP_200_OK, content=jsonable_encoder(user_flags))
    else:
        return JSONResponse(status_code=404, content={"message": "User filter preferences not found"})
