import datetime as dt
from typing import List

from fastapi import APIRouter, Body, Depends
from fastapi import status, Request
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.thirdparty.asyncio import get_user_by_id

from utils.db import get_mongo_document, get_mongo_documents, update_mongo_document_fields, asyncdb
from utils.db import get_mongo_documents_by_date, get_user_name, get_block_by_id
from utils.headline import generate_single_thread_headline
from .child_thread import create_child_thread
from .child_thread import create_new_thread
from .models import BlockCollection, BlockModel, UpdateBlockModel, Date
from .models import THREADTYPES, CreateChildThreadModel, ThreadHeadlinesModel, ThreadModel, ThreadType, \
    ThreadsInfo, ThreadsMetaData, CreateThreadModel, ThreadsModel
from .search import thread_semantic_search

router = APIRouter()


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

    # threads = await keyword_search(query, threads_collection)
    result = await thread_semantic_search(query)

    filtered_threads = []
    for doc in result:
        filtered_threads.append(await get_mongo_document({"title": doc["title"]}, threads_collection))
    return_threads = jsonable_encoder(ThreadsModel(threads=filtered_threads))
    # print(return_threads)
    return JSONResponse(status_code=status.HTTP_200_OK, content=return_threads)


@router.get("/threadHeadlines", response_model=ThreadHeadlinesModel,
            response_description="Get headlines for all threads")
async def th(request: Request,
             session: SessionContainer = Depends(verify_session())):
    # Get all thread headlines from MongoDB
    collection = request.app.mongodb["threads"]
    userId = session.get_user_id()
    userDoc = await request.app.mongodb["users"].find_one({"_id": userId})
    # headlines = await get_mongo_documents(request.app.mongodb["thread_headlines"])

    # Convert string datetimes to actual datetime objects during sorting
    sort_criteria = [{
        "$addFields":
            {"last_modified_date":
                 {"$toDate": "$last_modified"}
             }
    },
        {"$sort": {"last_modified_date": -1}}]

    # Fetch all documents with the sort criteria (using aggregation for sorting)

    cursor = collection.aggregate(sort_criteria)

    sorted_headlines = []
    async for document in cursor:
        if document['tenant_id'] == userDoc['tenant_id']:
            headline = {
                "id": document['_id'],
                "title": document['title'],
                "headline": document['headline'],
                "last_modified": document['last_modified']
            }
            sorted_headlines.append(headline)

    thread_headlines = ThreadHeadlinesModel(headlines=sorted_headlines)

    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(
                            thread_headlines))


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
    userId = session.get_user_id()
    userDoc = await request.app.mongodb["users"].find_one({"_id": userId})

    # Get all thread titles from MongoDB
    threads = await get_mongo_documents(request.app.mongodb["threads"])

    info: dict[str, ThreadType] = {}
    for thread in threads:
        if thread['tenant_id'] == userDoc['tenant_id']:
            info[thread["title"]] = thread["type"]

    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(ThreadsInfo(info=info)))


@router.get("/metadata", response_model=ThreadsMetaData,
            response_description="Get meta data for all threads")
async def md(request: Request,
             session: SessionContainer = Depends(verify_session())):
    # Get all thread titles from MongoDB
    threads = await get_mongo_documents(request.app.mongodb["threads"])
    users = await get_mongo_documents(request.app.mongodb["users"])
    metadata = []
    for doc in threads:
        creator = {}
        user_info = None
        for user in users:
            if doc['creator'] == user['_id']:
                user_info = user
                break
        if user_info and user_info['tenant_id'] == doc['tenant_id']:
            creator["id"] = user_info["_id"]
            creator["name"] = user_info["user_name"]
            creator["picture"] = user_info["user_picture"]
            creator["email"] = user_info["email"]
        metadata.append({
            "_id": doc["_id"],
            "title": doc["title"],
            "type": doc["type"],
            "created_date": doc["created_date"],
            "creator": creator
        })
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(ThreadsMetaData(metadata=metadata)))


async def create_new_block(thread_id, block: UpdateBlockModel, user_id):
    user_info = await asyncdb.users_collection.find_one({"_id": user_id})
    threads_collection = asyncdb.threads_collection
    if user_info is None:
        return None
    fullName = user_info['user_name']
    email = user_info['email']
    picture = user_info['user_picture']
    block = block.model_dump()
    new_block = BlockModel(**block)
    new_block.created_by = fullName
    new_block.creator_email = email
    new_block.creator_picture = picture
    new_block.creator_id = user_id
    thread = await get_mongo_document({"_id": thread_id}, threads_collection)
    # change new_block_dict to json_new_block if you want to store
    # block as a json string in the db
    thread["content"].append(jsonable_encoder(new_block))


    updated_thread = await update_mongo_document_fields(
        {"_id": thread_id},
        thread,
        threads_collection)

    generate_single_thread_headline(thread, threads_collection, use_ai=False)

    return updated_thread


@router.post("/blocks", response_model=ThreadModel, response_description="Create a new block")
async def create(request: Request, thread_title: str, block: UpdateBlockModel = Body(...),
                 session: SessionContainer = Depends(verify_session())):
    # Logic to store the block in MongoDB backend database
    # Index the block by userId

    user_id = session.get_user_id()
    thread = await get_mongo_document({"title": thread_title}, request.app.mongodb["threads"])

    if not thread:
        return JSONResponse(status_code=404, content={"message": "Thread with ${thread_title} not found"})

    thread_id = thread["_id"]
    updated_thread = await create_new_block(thread_id, block, user_id)


    return JSONResponse(status_code=status.HTTP_201_CREATED,
                        content=jsonable_encoder(updated_thread))


@router.put("/blocks", response_model=ThreadModel, response_description="Update a block")
async def update(request: Request, thread_title: str, block: UpdateBlockModel = Body(...),
                 session: SessionContainer = Depends(verify_session())):
    thread_collection = request.app.mongodb["threads"]

    # Logic to store the block in MongoDB backend database
    # Index the block by userId
    update_block = block.model_dump()
    block = get_block_by_id(update_block["id"], thread_collection)
    user_id = session.get_user_id()

    if jsonable_encoder(block)["creator_id"] != user_id:
        return JSONResponse(status_code=401, content={"message": "Unauthorized"})

    # new_block_dict = new_block.model_dump()
    # new_block_dict["id"] = str(new_block_dict["id"])
    # to store the block as a json string in the db
    # we need the following. We have chose to insert
    # the block as a dictionary object in the db
    # json_new_block = json_util.dumps(new_block_dict)
    thread = await get_mongo_document({"title": thread_title}, thread_collection)
    if not thread:
        return JSONResponse(status_code=404, content={"message": "Thread with ${thread_title} not found"})

    # change new_block_dict to json_new_block if you want to store
    # block as a json string in the db
    thread["content"].remove(jsonable_encoder(block))
    thread["content"].append(jsonable_encoder(update_block))

    generate_single_thread_headline(thread, thread_collection, use_ai=False)

    updated_thread = await update_mongo_document_fields(
        {"title": thread_title},
        thread,
        request.app.mongodb["threads"])

    return JSONResponse(status_code=status.HTTP_201_CREATED,
                        content=jsonable_encoder(updated_thread))


@router.post("/blocks/child", response_model=ThreadModel)
async def child_thread(request: Request,
                       child_thread_data: CreateChildThreadModel = Body(...),
                       session: SessionContainer = Depends(verify_session())):
    thread_collection = request.app.mongodb["threads"]
    child_thread = child_thread_data.model_dump()

    parent_block_id = child_thread["parent_block_id"]
    parent_thread_id = child_thread["parent_thread_id"]

    # fetch the parent block
    block = await get_block_by_id(parent_block_id, thread_collection)
    if not block:
        return JSONResponse(status_code=404, content={"message": "block with id ${parent_block_id} not found"})

    # create a new child thread
    thread_title = jsonable_encoder(child_thread)["title"]
    thread_type = jsonable_encoder(child_thread)["type"]
    user_id = session.get_user_id()
    creator_name = await get_user_name(user_id, request.app.mongodb["users"])

    created_child_thread = await create_child_thread(thread_collection=thread_collection,
                                                     parent_block_id=parent_block_id,
                                                     parent_thread_id=parent_thread_id,
                                                     thread_title=thread_title,
                                                     thread_type=thread_type,
                                                     user_id=user_id, )

    return JSONResponse(status_code=status.HTTP_201_CREATED,
                        content=jsonable_encoder(created_child_thread))


# get blocks given a date
@router.get("/blocksDate", response_model=BlockCollection,
            response_description="Get all blocks for a given date")
async def get_blocks_by_date(request: Request,
                             date: Date,
                             session: SessionContainer = Depends(verify_session())
                             ):
    # Logic to fetch all blocks by the signed-in user from MongoDB backend database

    blocks = await get_mongo_documents_by_date(date.date, request.app.mongodb["blocks"])

    ret_block = BlockCollection(blocks=blocks)

    # retun the block in json format
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(ret_block))


@router.get("/journal", response_model=BlockCollection,
            response_description="Get journal for a given date")
async def date(request: Request,
               date: Date,
               session: SessionContainer = Depends(verify_session())
               ):
    print("Getting journal for date: ", date.date)
    userId = session.get_user_id()
    # get journal thread. If it does not exist, create it
    journal_thread = await create_new_thread(userId, "journal", "/new-thread")
    # get the blocks that have created_at date equal to the date
    # doing this query in the db directly will be much faster than doing this 
    # in the python application

    # build a pymongo query to get the list of blocks from a thread that have the created_at date equal to the date
    # provided date:
    d = date.date.date()
    from_date = dt.datetime.combine(d, dt.datetime.min.time())
    to_date = dt.datetime.combine(d, dt.datetime.max.time())

    query = {"title": "journal",
             "content": {"$elemMatch": {"created_at": {"$gte": from_date.isoformat(),
                                                       "$lt": to_date.isoformat()}}}}
    collection = request.app.mongodb["threads"]
    doc = await collection.find_one(query)
    if not doc:
        return JSONResponse(status_code=404, content={"message": "Journal not found"})

    # Convert cursor to list of dictionaries
    blocks = doc["content"]

    ret_thread = BlockCollection(blocks=blocks)

    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(ret_thread))


@router.post("/threads", response_model=ThreadModel)
async def create_th(request: Request, thread_data: CreateThreadModel = Body(...),
                    session: SessionContainer = Depends(verify_session())):
    # Create a new thread in MongoDB using the thread_data
    # Index the thread by userId
    userId = session.get_user_id()
    userName = await get_user_by_id(userId)

    thread_title = jsonable_encoder(thread_data)["title"]
    thread_type = jsonable_encoder(thread_data)["type"]
    # content = jsonable_encoder(thread_data)["content"]

    created_thread = await create_new_thread(userId, thread_title, thread_type)

    return JSONResponse(status_code=status.HTTP_201_CREATED,
                        content=jsonable_encoder(created_thread))


@router.get("/threads/{id}", response_model=ThreadModel)
async def get_thread_id(request: Request, id: str,
                        session: SessionContainer = Depends(verify_session())):
    # Get a thread from MongoDB by title

    old_thread = await get_mongo_document({"_id": id}, request.app.mongodb["threads"])
    if not old_thread:
        return JSONResponse(status_code=404, content={"message": "Thread not found"})

    thread_content = jsonable_encoder(old_thread)
    user = get_user_by_id(thread_content['creator'])
    thread_content['creator'] = jsonable_encoder(user)['user_name']
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=thread_content)


@router.put("/threads/{id}", response_model=ThreadModel)
async def update_th(request: Request, id: str, thread_data: CreateThreadModel = Body(...),
                    session: SessionContainer = Depends(verify_session())):
    # Create a new thread in MongoDB using the thread_data
    # Index the thread by userId
    userId = session.get_user_id()

    thread_collection = request.app.mongodb["threads"]

    old_thread = await get_mongo_document({"_id": id}, thread_collection)
    if not old_thread:
        return JSONResponse(status_code=404, content={"message": "Thread not found"})

    if old_thread["creator"] != userId:
        return JSONResponse(status_code=401, content={"message": "Unauthorized"})

    thread_title = jsonable_encoder(thread_data)["title"]
    # content = jsonable_encoder(thread_data)["content"]

    updated_thread = thread_collection.update_one({'_id': id}, {"$set": {"title": thread_title}})

    return JSONResponse(status_code=status.HTTP_201_CREATED,
                        content=jsonable_encoder(updated_thread))


@router.get("/threads/{title}", response_model=ThreadModel)
async def get_thread(request: Request, title: str,
                     session: SessionContainer = Depends(verify_session())):
    # Get a thread from MongoDB by title

    old_thread = await get_mongo_document({"title": title}, request.app.mongodb["threads"])
    if not old_thread:
        return JSONResponse(status_code=404, content={"message": "Thread not found"})

    thread_content = jsonable_encoder(old_thread)
    user = get_user_by_id(thread_content['creator'])
    thread_content['creator'] = jsonable_encoder(user)['user_name']
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=thread_content)


@router.get("/allThreads", response_model=List[ThreadsModel])
async def at(request: Request, session: SessionContainer = Depends(verify_session())):
    # Get all threads from MongoDB by date created
    threads = await get_mongo_documents(request.app.mongodb["threads"])
    modified_threads = []
    for doc in threads:
        thread_content = jsonable_encoder(doc)
        user = get_user_by_id(thread_content['creator'])
        thread_content['creator'] = jsonable_encoder(user)['user_name']
        modified_threads.append(jsonable_encoder(thread_content))
    return threads
