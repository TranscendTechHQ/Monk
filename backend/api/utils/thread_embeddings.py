import asyncio
import pprint
import threading

from pymongo import MongoClient

from config import settings
from routes.threads.semantic_search_mongo import thread_semantic_search_mongo
from utils.db import get_mongo_document_async, get_mongo_document_sync, asyncdb,get_mongo_documents_async, get_mongo_documents_sync, shutdown_async_db_client, startup_async_db_client
from utils.embedding import generate_embedding




async def generate_single_thread_embedding(thread_id, tenant_id):
    
    thread_collection = asyncdb.threads_collection
    thread_doc = await get_mongo_document_async(
        filter={'_id': thread_id}, 
        collection=thread_collection, 
        tenant_id=tenant_id)
    user_collection = asyncdb.users_collection

    topic = thread_doc['topic']
    text = "This is the content of the thread with topic " + topic + ". "
    threadType = thread_doc['type']
    text += "The type of the thread is " + threadType + ". "
    createdAt = thread_doc['created_at']
    text += "The thread was created on " + createdAt + ". "
    creator_id = thread_doc['creator_id']
    
    userDoc = await get_mongo_document_async(
        filter={'_id': creator_id}, 
        collection=user_collection, 
        tenant_id=tenant_id)
    
    text += "The creator of the thread is " + userDoc['name'] + ". "
    email = userDoc['email']
    text += "The email of the creator is " + email + ". "
    
    blocks_collection = asyncdb.blocks_collection
    blocks = await get_mongo_documents_async(
        collection=blocks_collection, 
        tenant_id=tenant_id, 
        filter={'main_thread_id': thread_doc['_id']}, 
        sort=[('created_at', 1)])
    

    for block in blocks:
        # print(block['content'])
        text += block['content'] + " "
    print (text)

    embedding = generate_embedding(text)
    print(embedding)
    

async def generate_all_threads_embedding(tenant_id):
    threads_collection = asyncdb.threads_collection
    # Update the collection with the embeddings
    # requests = []
    threads = await get_mongo_documents_async(
        collection=threads_collection, 
        tenant_id=tenant_id, 
        filter={'topic': {"$exists": True}})
    for thread_doc in threads:
        # print(doc['content'])
        await generate_single_thread_embedding(thread_doc)

        # requests.append(ReplaceOne({'_id': doc['_id']}, doc))

    # collection.bulk_write(requests)




async def main():
    await startup_async_db_client()
    
    # update_thread_creator()
    # generate_embedding_new_api(
    #    "The food was delicious and the waiter was very friendly.")
    # print(embedding)
    # generate_thread_embedding()
    # move_thread_embedding()
    # generate_all_threads_embedding()
    #result = await thread_semantic_search_mongo(
    #    "thread about monk next steps")
    #pprint.pprint(result)
    
    await generate_single_thread_embedding(
        thread_id="12262259-90fe-44bf-90e2-b17e2871a2df", 
        tenant_id="T048F0ANS1M")

    await shutdown_async_db_client()


if __name__ == "__main__":
    asyncio.run(main())
