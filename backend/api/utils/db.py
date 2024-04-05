import datetime as dt

from .embedding import generate_embedding
from config import settings
import motor.motor_asyncio

class AsyncDbClient:
    pass

asyncdb = AsyncDbClient()


async def startup_async_db_client():
    asyncdb.mongodb_client =   motor.motor_asyncio.AsyncIOMotorClient(settings.DB_URL)
    #print(app.mongodb_client.list_database_names())
    asyncdb.mongodb =  asyncdb.mongodb_client[settings.DB_NAME]



async def shutdown_async_db_client():
    asyncdb.mongodb_client.close()


async def get_user_name(user_id, collection) -> str:
    if (doc := await collection.find_one({"_id": user_id})) is not None:
        return doc["user_name"]
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


## first argument should be a dictionary to query the db
async def get_mongo_document(query: dict, collection):
    if (doc := await collection.find_one(query)) is not None:
        return doc
    return None

async def get_mongo_documents(collection):
    docs = []
    async for doc in collection.find():
        docs.append(doc)
    return docs

async def get_mongo_documents_by_date(date: dt.datetime, collection):

   # async for doc in collection.find({"metadata.createdAt": date}):
    #    docs.append(doc)
    d = date.date()
    from_date = dt.datetime.combine(d, dt.datetime.min.time())
    to_date = dt.datetime.combine(d, dt.datetime.max.time())
    
    query = {"created_at": {"$gte": from_date.isoformat(), "$lt": to_date.isoformat()}}
    
    cursor =  collection.find(query)
    batch_size = 100
    # Convert cursor to list of dictionaries
    documents = await cursor.to_list(length=batch_size)
    
    return documents

async def delete_mongo_document(query:dict, collection):
    if (doc := await collection.find_one(query)) is not None:
        await collection.delete_one(query)
        return doc

async def create_mongo_document(document: dict, collection):
    #print(document)
    #print(collection)
    
    if collection is None:
        print("collection is none")
    if document is None:
        print("document is none")
    result =  await collection.find_one(document)
    
    if result is not None:
    ## if the document already exists, return the existing document
        return result
    
    
    new_document =  await collection.insert_one(document)
    
    
    created_document = await collection.find_one(
        {"_id": new_document.inserted_id})
    
    return created_document

async def get_block_by_id(block_id, thread_collection):
    # Filter with unwind and match
    pipeline = [
        {
            "$match": {"content._id": block_id}
        },
        {
            "$unwind": "$content"
        },
        {
            "$match": {"content._id": block_id}
        }
    ]

    result =  thread_collection.aggregate(pipeline)

    # Fetch the first element (assuming there's only one matching block)
    block = await result.next()

    # Access block content
    return block

async def update_block_child_id(threads_collection, 
                                parent_block_id, 
                                thread_id, 
                                child_thread_id) :
    
    query = {'_id': thread_id}
    
    
    # Fetch the document and find the block with "id" "3493"
    document = threads_collection.find_one(query)
    #print(parent_block_id)
    

    update = {'$set': {'content.$[elem].child_id': child_thread_id}}
    # Find the document with the "_id" of "385029"
    
    result = await threads_collection.update_one(query, update, 
                                  array_filters=[{'elem._id': parent_block_id}],
                                  upsert=True)
    
    if result.modified_count > 0:
        print("Updated successfully")
    else:
        print("could not update the block with block_id: ", parent_block_id)
        
async def update_mongo_document_fields(query:dict, fields: dict, collection):
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


