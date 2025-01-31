import re
from fastapi import HTTPException
import logging

from fastapi import APIRouter, Depends
from fastapi import status, Request
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.recipe.session.framework.fastapi import verify_session


from routes.threads.models import LinkMetaModel, MessageCreate, MessageDb, MessageResponse, MessagesResponse, ThreadCreate, ThreadDb, ThreadResponse, ThreadsResponse, UserMap, UserModel
from utils.milvus_vector import milvus_semantic_search
from utils.scrapper import getLinkMeta
from utils.db import create_mongo_doc_sync, get_aggregate_async, get_mongo_document_async, get_mongo_documents_async, get_mongo_documents_sync, get_tenant_id, asyncdb, syncdb

from utils.relevance import get_relevant_thread_ids

router = APIRouter()
logger = logging.getLogger(__name__)


def extract_link_meta(content: str):
    
    linkMeta = None
    lastUrlAvailableInContent = ''
    
    # if content is not None or empty.
    # then check if there is valid url in the content text. If there are multiple url available then take the last one
    
    if content is not None:
        urls = re.findall(
            'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', content)
        if len(urls) > 0:
            print(f'\n 👉 Link detected count: {len(urls)} ')
            lastUrlAvailableInContent = urls[-1]
        else:
            print(f'\n 👉 No link detected in the content {content}')

        
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
                
    return linkMeta

@router.post("/message", 
             response_model=MessageResponse, 
             response_description="Newly created message",
             operation_id="create_message",
             summary="Create a new message in a thread",
             description="The api will create a new message in a thread and return the newly created message")
async def create_message(message: MessageCreate, session: SessionContainer = Depends(verify_session())):
    try:
        user_id = session.get_user_id()
        tenant_id = await get_tenant_id(session)
        message_db = MessageDb(content=message.content,  
                            thread_id=message.thread_id, 
                            tenant_id=tenant_id, 
                            creator_id=user_id)
        if message.content.link_meta is None:
            # see if there are any links in the message text and extract links
            linkMeta = extract_link_meta(message.content.text)
            message_db.content.link_meta = linkMeta
        inserted_doc = create_mongo_doc_sync(document=jsonable_encoder(message_db),
                            collection=syncdb.messages_collection)
        
        # Convert the MongoDB document to a dictionary and modify the 'id' field
        
        inserted_doc['id'] = str(inserted_doc['_id'])  # Convert ObjectId to string

        # Create the MessageResponse object with the modified dictionary
        response = MessageResponse(**inserted_doc)
        
    except Exception as e:
        logger.error(e, exc_info=True)
        raise HTTPException(status_code=500, detail="Internal Server Error")
    
    return JSONResponse(status_code=status.HTTP_200_OK, content=jsonable_encoder(response))

@router.get("/messages",
            response_model=MessagesResponse,
            response_description="List of messages in a thread",
            operation_id="get_messages",
            summary="Get all messages in a thread",
            description="The api will return all messages in a thread")
async def get_messages(thread_id: str, request: Request,
                      session: SessionContainer = Depends(verify_session())):
    tenant_id = await get_tenant_id(session)
    messages_collection = asyncdb.messages_collection
    messages = await get_mongo_documents_async(
        collection=messages_collection, 
        tenant_id=tenant_id,
        filter={"thread_id": thread_id})
    messages_response = []
    for message in messages:
        message['id'] = str(message['_id'])
        messages_response.append(MessageResponse(**message))
    
    return JSONResponse(status_code=status.HTTP_200_OK, content=jsonable_encoder(MessagesResponse(messages=messages_response)))

@router.post("/thread", 
             response_model=ThreadResponse,
             response_description="Newly created thread",
             operation_id="create_thread",
             summary="Create a new thread",
             description="The api will create a new thread and return the newly created thread")
async def create_thread(thread: ThreadCreate, 
                        session: SessionContainer = Depends(verify_session())):
    try:
        user_id = session.get_user_id()
        tenant_id = await get_tenant_id(session)
        thread_db = ThreadDb(content=thread.content, 
                            tenant_id=tenant_id, 
                            creator_id=user_id)
        inserted_doc = create_mongo_doc_sync(
            document= jsonable_encoder(thread_db),
            collection=syncdb.threads_collection)
        
        # Convert the MongoDB document to a dictionary and modify the 'id' field
        
        inserted_doc['id'] = str(inserted_doc['_id'])  # Convert ObjectId to string

        response = ThreadResponse(**inserted_doc) 
        
        
    except Exception as e:
        logger.error(e, exc_info=True)
        raise HTTPException(status_code=500, detail="Internal Server Error")

    return JSONResponse(status_code=status.HTTP_200_OK, content=jsonable_encoder(response))

@router.get("/threads",
            response_model=ThreadsResponse,
            response_description="List of threads",
            operation_id="get_threads",
            summary="Get all threads",
            description="The api will return all threads")
async def get_threads(request: Request,
                      session: SessionContainer = Depends(verify_session())):
    tenant_id = await get_tenant_id(session)
    threads_collection = asyncdb.threads_collection
    threads = await get_mongo_documents_async(
        collection=threads_collection, 
        tenant_id=tenant_id)
    #threads_response = json_util.dumps(threads)
    threads_response = []
    for thread in threads:
        thread['id'] = str(thread['_id'])
        threads_response.append(ThreadResponse(**thread))
    
    return JSONResponse(status_code=status.HTTP_200_OK, 
                        content=jsonable_encoder(ThreadsResponse(threads=threads_response)))

async def keyword_search(query, collection):
    
    pipeline = [
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
    ]
    threads = await get_aggregate_async(pipeline=pipeline, collection=collection)

    return threads


@router.get("/users", response_model=UserMap, 
            operation_id="get_users",
            summary="Get all users",
            description="The api will return all users")
async def all_users(request: Request,
                    session: SessionContainer = Depends(verify_session())
                    ):
    tenant_id = await get_tenant_id(session)
    # get all users
    final_user_map = {}

    
    user_list = get_mongo_documents_async(asyncdb.users_collection, tenant_id=tenant_id)
    for user in user_list:
        final_user_map[user["_id"]] = UserModel(**user)

    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(UserMap(users=final_user_map)))


@router.get("/user", response_model=UserMap,
            operation_id="get_user",
            summary="Get user information",
            description="The api will return user information")
async def get_user(request: Request, user_id: str, session: SessionContainer = Depends(verify_session())):
    tenant_id = await get_tenant_id(session)
    user_collection = asyncdb.users_collection
    user = await get_mongo_document_async(filter={"_id": user_id},
                                         collection=user_collection,
                                         tenant_id=tenant_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return JSONResponse(status_code=status.HTTP_200_OK,
                        content=jsonable_encoder(UserModel(**user)))

@router.get("/searchThreads", response_model=ThreadsResponse,
            operation_id="search_threads",
            summary="Search threads in plain english and get top 3 matching threads",
            description="The api will return top 3 threads matching the query")
async def search_threads(request: Request, query: str, session: SessionContainer = Depends(verify_session())):
    # Search threads in MongoDB by query
    threads_collection = request.app.mongodb["threads"]
    tenant_id = await get_tenant_id(session)
    # threads = await keyword_search(query, threads_collection)
    #result = await thread_semantic_search_mongo(query)
    collection_name = f"threads_{tenant_id}"
    results = milvus_semantic_search(collection_name, query, limit=3)
    
    filtered_threads_ids = []
    for result in results[0]:
        filtered_threads_ids.append(result['id'])

    filtered_threads = []
    for id in filtered_threads_ids:
        thread = await get_mongo_document_async( filter={"thread_id": id},
                                                         collection=threads_collection,
                                                         tenant_id=tenant_id)
        if thread is not None:
            thread['id'] = str(thread['_id'])   
            filtered_threads.append(ThreadResponse(**thread))
    return_threads = jsonable_encoder(ThreadsResponse(threads=filtered_threads))
    # print(return_threads)
    return JSONResponse(status_code=status.HTTP_200_OK, content=return_threads)





def semantic_filter_threads(user_id, tenant_id):
    user_collection = syncdb.users_collection
    user = user_collection.find_one({"_id": user_id})
    if user is None:
        return None
    user_name = user["name"]
    print(f'\n 👉 User name: {user_name}')
    news_feed_filter_collection = syncdb.user_news_feed_filter_collection
    user_filter = news_feed_filter_collection.find_one({"user_id": user_id})

    if user_filter is None:
        return None

    user_preference = user_filter["searchQuery"]
    print(f'\n 👉 User preference: {user_preference}')
    threads_collection = syncdb.threads_collection
    thread_ids_dict = get_mongo_documents_sync(collection=threads_collection, tenant_id=tenant_id, projection={'_id': 1, '_id': '$_id'})
    
    thread_ids = [thread["_id"] for thread in thread_ids_dict]
    print(f'\n 👉 Thread ids: {thread_ids}')

    relevant_thread_ids = get_relevant_thread_ids(
        user_name, user_preference, thread_ids)

    return relevant_thread_ids
