import asyncio
import pprint
import threading

from pymongo import MongoClient

from config import settings
from routes.threads.semantic_search_mongo import thread_semantic_search_mongo
from utils.db import get_mongo_document_async, get_mongo_document_sync, asyncdb,get_mongo_documents_async, get_mongo_documents_sync, shutdown_async_db_client, startup_async_db_client
from utils.embedding import generate_embedding
from utils.milvus_vector import create_thread_collection, milvus_semantic_search, store_milvus_thread_embedding




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
    #print (text)

    embedding = generate_embedding(text)
    return embedding
    #print(embedding)
    

async def generate_all_threads_embedding_and_store_to_milvus(tenant_id, collection_name):
    threads_collection = asyncdb.threads_collection
    # Update the collection with the embeddings
    # requests = []
    threads = await get_mongo_documents_async(
        collection=threads_collection, 
        tenant_id=tenant_id, 
        filter={})
    
    create_thread_collection(collection_name, dim=1536)
    for thread_doc in threads:
        # print(doc['content'])
        thread_embedding = await generate_single_thread_embedding(
            thread_id=thread_doc['_id'], 
            tenant_id=tenant_id)
        store_milvus_thread_embedding(
            collection_name=collection_name,
            thread_id=thread_doc['_id'], 
            tenant_id=tenant_id,
            thread_embedding=thread_embedding)

        # requests.append(ReplaceOne({'_id': doc['_id']}, doc))

    # collection.bulk_write(requests)

async def gen_and_store_test_thread_embedding_to_milvus(tenant_id, collection_name):
    create_thread_collection(collection_name, dim=1536)
    thread_id = "f8ff71be-cbc2-4d7f-80cf-750d7d50db84"
    thread_embedding = await generate_single_thread_embedding(thread_id, tenant_id)
    store_milvus_thread_embedding(
        collection_name=collection_name,
        thread_id=thread_id, 
        tenant_id=tenant_id,
        thread_embedding=thread_embedding)


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
    
    tenant_id = "T048F0ANS1M"
    collection_name = f"threads_{tenant_id}"
    #await gen_and_store_test_thread_embedding_to_milvus(tenant_id, collection_name)
    await generate_all_threads_embedding_and_store_to_milvus(
        tenant_id=tenant_id, 
        collection_name=collection_name)
    
    query = "Thread about Jira"
    results = milvus_semantic_search(collection_name, query, limit=3)
    print(results)

    await shutdown_async_db_client()


if __name__ == "__main__":
    asyncio.run(main())
