import datetime as dt
import json
import uuid
import logging
import motor.motor_asyncio

import pymongo

from config import custom_exception_handler, settings
from utils.caching import get_cache, set_cache

logger = logging.getLogger(__name__)
class SyncDbClient:
    pass


syncdb = SyncDbClient()


def startup_sync_db_client():
    syncdb.mongodb_client = pymongo.MongoClient(
        settings.DB_URL)
    # print(app.mongodb_client.list_database_names())
    syncdb.mongodb = syncdb.mongodb_client[settings.DB_NAME]
    syncdb.threads_collection = syncdb.mongodb["threads"]
    syncdb.blocks_collection = syncdb.mongodb["blocks"]
    syncdb.users_collection = syncdb.mongodb["users"]
    syncdb.tenants_collection = syncdb.mongodb["tenants"]
    # syncdb.metadata_collection = syncdb.mongodb["threads_metadata"]
    # syncdb.headlines_collection = syncdb.mongodb["thread_headlines"]
    syncdb.subscribed_channels_collection = syncdb.mongodb["subscribed_channels"]
    syncdb.whitelisted_users_collection = syncdb.mongodb["whitelisted_users"]
    # syncdb.thread_reads_collection = syncdb.mongodb["thread_reads"]
    syncdb.user_thread_flags_collection = syncdb.mongodb["user_thread_flags"]
    syncdb.user_news_feed_filter_collection = syncdb.mongodb["user_news_feed_filter"]
    syncdb.messages_collection = syncdb.mongodb["messages"]

def shutdown_sync_db_client():
    syncdb.mongodb_client.close()


class AsyncDbClient:
    pass


asyncdb = AsyncDbClient()


async def startup_async_db_client():
    asyncdb.mongodb_client = motor.motor_asyncio.AsyncIOMotorClient(
        settings.DB_URL)
    # print(app.mongodb_client.list_database_names())
    asyncdb.mongodb = asyncdb.mongodb_client[settings.DB_NAME]
    asyncdb.threads_collection = asyncdb.mongodb["threads"]
    asyncdb.blocks_collection = asyncdb.mongodb["blocks"]
    asyncdb.users_collection = asyncdb.mongodb["users"]
    asyncdb.tenants_collection = asyncdb.mongodb["tenants"]
    # asyncdb.metadata_collection = asyncdb.mongodb["threads_metadata"]
    # asyncdb.headlines_collection = asyncdb.mongodb["thread_headlines"]
    asyncdb.subscribed_channels_collection = asyncdb.mongodb["subscribed_channels"]
    asyncdb.whitelisted_users_collection = asyncdb.mongodb["whitelisted_users"]
    # asyncdb.thread_reads_collection = asyncdb.mongodb["thread_reads"]
    asyncdb.user_thread_flags_collection = asyncdb.mongodb["user_thread_flags"]
    asyncdb.user_news_feed_filter_collection = asyncdb.mongodb["user_news_feed_filter"]
    asyncdb.messages_collection = asyncdb.mongodb["messages"]

async def shutdown_async_db_client():
    asyncdb.mongodb_client.close()

def get_user_id(session):
    user_id = session.get_user_id()
    return user_id

async def get_user_info(user_id):
    try:
        used_id_uuid = uuid.UUID(user_id).bytes
        user_info_json = get_cache(used_id_uuid)
        if user_info_json is None:
            user_info = await asyncdb.users_collection.find_one({"_id": user_id})
            user_info_json = json.dumps(user_info)
            set_cache(used_id_uuid, user_info_json)
        return json.loads(user_info_json)
    except Exception as e:
        logger.error(e, exc_info=True)

async def list_tenants():
    return await asyncdb.tenants_collection.find().to_list(length=None)

async def get_tenant_id(session):
    try:
        user_id = session.get_user_id()
        user_info = await get_user_info(user_id)
        assert user_info is not None
        assert user_info["tenant_id"] is not None
        tenant_id = user_info["tenant_id"]
        return tenant_id
    except Exception as e:
        custom_exception_handler(type(e), e, e.__traceback__)
        
        logger.error(f"User info not found for user {user_id}")
        return None


def get_tenant_id_sync(session):
    user_id = session.get_user_id()
    user_info = syncdb.users_collection.find_one({"_id": user_id})
    return user_info["tenant_id"]


async def get_user_name(user_id, collection) -> str:
    if (doc := await collection.find_one({"_id": user_id})) is not None:
        return doc["name"]
    return "Unknown user"


async def get_user_email(user_id, collection) -> str:
    if (doc := await collection.find_one({"_id": user_id})) is not None:
        return doc["email"]
    return "Unknown email"


async def get_user_metadata(user_id, collection) -> dict:
    if (doc := await collection.find_one({"_id": user_id})) is not None:
        return doc
    return None


async def get_user_last_login(user_id, collection) -> dt.datetime:
    if (doc := await collection.find_one({"_id": user_id})) is not None:
        return doc["last_login"]
    return None


# first argument should be a dictionary to query the db
async def get_mongo_document_async(filter: dict, collection, tenant_id):
    filter["tenant_id"] = tenant_id
    if (doc := await collection.find_one(filter)) is not None:
        return doc
    return None


def get_mongo_document_sync(filter: dict, collection, tenant_id):
    filter["tenant_id"] = tenant_id
    if (doc := collection.find_one(filter)) is not None:
        return doc
    return None


async def get_mongo_documents_async(collection, tenant_id, filter: dict = {}, projection: dict = {}, sort=None):

    filter["tenant_id"] = tenant_id
    docs = []
    cursor = collection.find(filter, projection=projection, sort=sort)
    # Convert cursor to list of dictionaries
    docs = await cursor.to_list(length=None)
    # async for doc in collection.find(query):
    #     docs.append(doc)
    return docs

def get_mongo_documents_sync(collection, tenant_id, filter: dict = {}, projection: dict = {}, sort=None):

    filter["tenant_id"] = tenant_id
    docs = []
    cursor = collection.find(filter, projection=projection, sort=sort)
    # Convert cursor to list of dictionaries
    #docs =  cursor.to_list(length=None)
    docs = list(cursor)
    # async for doc in collection.find(query):
    #     docs.append(doc)
    return docs

async def get_mongo_documents_by_date(date: dt.datetime, collection, tenant_id):
    # async for doc in collection.find({"metadata.createdAt": date}):
    #    docs.append(doc)

    d = date.date()
    from_date = dt.datetime.combine(d, dt.datetime.min.time())
    to_date = dt.datetime.combine(d, dt.datetime.max.time())

    query = {"created_at": {"$gte": from_date.isoformat(
    ), "$lt": to_date.isoformat()}, "tenant_id": tenant_id}

    cursor = collection.find(query)
    batch_size = 100
    # Convert cursor to list of dictionaries
    documents = await cursor.to_list(length=batch_size)

    return documents


async def delete_mongo_document(query: dict, collection):
    if (doc := await collection.find_one(query)) is not None:
        await collection.delete_one(query)
        return doc


def create_mongo_doc_sync(document: dict, collection):
    insert_id =collection.insert_one(document)
    if insert_id is not None:
        inserted_doc = collection.find_one({"_id": insert_id.inserted_id})
        return inserted_doc
    return None


def create_or_replace_mongo_doc(id: str, document: dict, collection):
    # print(document)
    # print(collection)

    if collection is None:
        print("collection is none")
        return None
    if document is None:
        print("document is none")
        return None
    collection.replace_one({"_id": id}, document, upsert=True)


def find_or_insert_mongo_doc_sync(id: str, document: dict, collection):
    # print(document)
    # print(collection)

    if collection is None:
        print("collection is none")
    if document is None:
        print("document is none")

    result = collection.find_one({"_id": id})

    if result is not None:
        # if the document already exists, return the existing document
        return result

    new_document = collection.insert_one(document)

    created_document = collection.find_one(
        {"_id": new_document.inserted_id})

    return created_document


async def create_mongo_document_async(id: str, document: dict, collection):
    # print(document)
    # print(collection)

    if collection is None:
        print("collection is none")
    if document is None:
        print("document is none")

    result = await collection.find_one({"_id": id})

    if result is not None:
        # if the document already exists, return the existing document
        return result

    new_document = await collection.insert_one(document)

    created_document = await collection.find_one(
        {"_id": new_document.inserted_id})

    return created_document

async def get_aggregate_async(pipeline, collection, length=None):
    return await collection.aggregate(pipeline).to_list(length=length)

async def get_block_by_id(block_id, thread_collection):
    try:
      # Filter with unwind and match
        print("block_id: ", block_id)
        pipeline = [
            {
                "$match": {"_id": block_id}
            },
        ]
        print("pipeline: ", pipeline)
        result = await get_aggregate_async(pipeline=pipeline, collection=thread_collection)
        # result = result.to_list(None)
        # Fetch the first element (assuming there's only one matching block)
        print(result.__len__() > 0)
        block = result[0]

        # Access block content
        return block
    except Exception as e:
        print(e)

        return None


# Function to return the block with creator
async def get_creator_block_by_id(block_id, block_collection):
    try:
      # Filter with unwind and match
        print("block_id: ", block_id)
        pipeline = [
            {
                '$match': {
                    '_id': block_id
                }
            }, {
                '$lookup': {
                    'from': 'users',
                    'localField': 'creator_id',
                    'foreignField': '_id',
                    'as': 'creator'
                }
            }, {
                '$unwind': {
                    'path': '$creator',
                    'includeArrayIndex': 'string'
                }
            }, {
                '$lookup': {
                    'from': 'users',
                    'localField': 'assigned_to_id',
                    'foreignField': '_id',
                    'as': 'assigned_to'
                }
            }, {
                '$unwind': {
                    'path': '$assigned_to',
                    'preserveNullAndEmptyArrays': True
                }
            }
        ]
        print("pipeline: ", pipeline)

        result = await get_aggregate_async(pipeline=pipeline, collection=block_collection)
        # result = result.to_list(None)
        # Fetch the first element (assuming there's only one matching block)
        print(result.__len__() > 0)
        block = result[0]

        # Access block content
        return block
    except Exception as e:
        print(e)

        return None

#



def update_fields_mongo_simple(query: dict, fields: dict, collection):
    collection.update_one(query, {"$set": fields}, upsert=True)


def update_mongo_document_fields_sync(query: dict, fields: dict, collection):
    fields_dict = {k: v for k, v in fields.items() if v is not None}

    if len(fields_dict) >= 1:
        update_result = collection.update_one(
            query, {"$set": fields_dict}
        )

        if update_result.modified_count == 1:
            if (
                    updated_doc := collection.find_one(query)
            ) is not None:
                return updated_doc

    if (
            existing_doc := collection.find_one(query)
    ) is not None:
        return existing_doc

    return None


async def update_mongo_document_fields(query: dict, fields: dict, collection):
    fields_dict = {k: v for k, v in fields.items() if v is not None}

    if len(fields_dict) >= 1:
        update_result = await collection.update_one(
            query, {"$set": fields_dict}
        )

        if update_result.modified_count == 1:
            if (
                    updated_doc := await collection.find_one(query)
            ) is not None:
                return updated_doc

    if (
            existing_doc := await collection.find_one(query)
    ) is not None:
        return existing_doc

    return None

# Get document count in a collection
