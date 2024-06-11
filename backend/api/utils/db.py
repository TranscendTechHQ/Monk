import datetime as dt

import motor.motor_asyncio

import pymongo

from config import settings


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


async def shutdown_async_db_client():
    asyncdb.mongodb_client.close()


async def get_user_info(session):
    user_id = session.get_user_id()
    user_info = await asyncdb.users_collection.find_one({"_id": user_id})
    return user_info


async def get_tenant_id(session):
    user_id = session.get_user_id()
    user_info = await asyncdb.users_collection.find_one({"_id": user_id})
    return user_info["tenant_id"]


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
async def get_mongo_document(query: dict, collection, tenant_id):
    query["tenant_id"] = tenant_id
    if (doc := await collection.find_one(query)) is not None:
        return doc
    return None


def get_mongo_document_sync(query: dict, collection, tenant_id):
    query["tenant_id"] = tenant_id
    if (doc := collection.find_one(query)) is not None:
        return doc
    return None


async def get_mongo_documents(collection, tenant_id, filter: dict = {}, projection: dict = {}):

    filter["tenant_id"] = tenant_id
    docs = []
    cursor = collection.find(filter, projection=projection)
    # Convert cursor to list of dictionaries
    docs = await cursor.to_list(length=None)
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


def create_mongo_doc_simple(document: dict, collection):
    return collection.insert_one(document)


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


def create_mongo_document_sync(id: str, document: dict, collection):
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


async def create_mongo_document(id: str, document: dict, collection):
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
        result = await thread_collection.aggregate(pipeline).to_list(length=None)
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
            }
        ]
        print("pipeline: ", pipeline)
        result = await block_collection.aggregate(pipeline).to_list(length=None)
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


async def update_block_child_id(blocks_collection,
                                parent_block_id,
                                thread_id,
                                child_thread_id):
    print("\n 5c.1 Updating block with child_thread_id: ", child_thread_id)
    result = await blocks_collection.update_one(
        {"_id": parent_block_id},
        {"$set": {"child_thread_id": child_thread_id}}
    )
    # query = {'_id': thread_id}

    # Fetch the document and find the block with "id" "3493"
    # document = threads_collection.find_one(query)
    # print(parent_block_id)

    # update = {'$set': {'content.$[elem].child_thread_id': child_thread_id}}
    # Find the document with the "_id" of "385029"

    # result = await threads_collection.update_one(query, update,
    #                                              array_filters=[{'elem._id': parent_block_id}],
    #                                              upsert=True)

    if result.modified_count > 0:
        print("\n 5.c.2 Child thread id updated in block")
    else:
        print("could not update the block with block_id: ", parent_block_id)


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
