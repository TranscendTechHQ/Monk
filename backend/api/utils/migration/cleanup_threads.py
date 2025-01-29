import asyncio

from fastapi.encoders import jsonable_encoder
from pymongo import MongoClient

from config import settings
from routes.threads.models import Message, Thread, ThreadDb
from utils.db import create_mongo_doc_sync


class App:
    pass


app = App()


def startup_db_client():
    app.mongodb_client = MongoClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]


def shutdown_db_client():
    app.mongodb_client.close()


def copy_creator_from_metadata_to_thread():
    metadata_collection = app.mongodb["threads_metadata"]
    threads_collection = app.mongodb["threads"]
    for doc in metadata_collection.find():
        thread_id = doc['_id']
        thread = threads_collection.update_one({"_id": thread_id}, {'$set': {
            'creator_id': doc['creator']['id']
        }}, upsert=True)

def rename_last_modified_to_headline_last_modified():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        threads_collection.update_one({"_id": thread_id}, {'$rename': {
            'headline_last_modified': 'last_modified'
        }})

def rename_creator_to_creator_id():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        threads_collection.update_one({"_id": thread_id}, {'$rename': {
            'creator': 'creator_id'
        }})
        
def remove_thread_content_data():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        threads_collection.update_one({"_id": thread_id}, {'$unset': {
            'content': ''
        }})

def update_last_modified():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        if 'last_modified' not in doc:
            print('no last_modified')
            doc['last_modified'] = doc['created_at']
        threads_collection.update_one({"_id": thread_id}, {'$set': {
            'last_modified': doc['last_modified']
        }}, upsert=True)
        
def rename_created_date_to_created_at():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        threads_collection.update_one({"_id": thread_id}, {'$rename': {
            'created_date': 'created_at'
        }})
        
def rename_thread_types():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        if 'type' in doc:
            if "slack_thread_ts" in doc:
                #print('slack')
                threads_collection.update_one({"_id": thread_id}, {'$set': {
                    'type': 'slack'}})
            
def delete_thread(thread_id):
    threads_collection = app.mongodb["threads"]
    blocks_collection = app.mongodb["blocks"]
    thread = threads_collection.find_one({"_id": thread_id})
    user_thread_flags_collection = app.mongodb["user_thread_flags"]
    if thread:
        blocks_collection.delete_many({"main_thread_id": thread_id})
        blocks = blocks_collection.find({"child_thread_id": thread_id})
        for block in blocks:
            blocks_collection.update_one({"_id": block["_id"]}, {'$set': {
                'child_thread_id': ''
            }})
        flags = user_thread_flags_collection.find({"thread_id": thread_id})
        for flag in flags:
            user_thread_flags_collection.delete_one({"_id": flag["_id"]})
            
        threads_collection.delete_one({"_id": thread_id})
        print(f"Deleted thread {thread_id} named {thread['topic']}")
    else:
        print(f"Thread {thread_id} not found") 
        
def delete_threads_with_less_than_n_blocks(n):
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        num_blocks = doc['num_blocks']
        if num_blocks < n:
            #print(f"Thread {doc['topic']} has {num_blocks} blocks")
            delete_thread(thread_id)

def delete_threads_with_type(type):
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        if doc['type'] == type:
            #print(f"Thread {doc['topic']} has {num_blocks} blocks")
            delete_thread(thread_id)

def delete_threads_with_topic_pattern(pattern):
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        if pattern in doc['topic']:
            #print(f"Thread {doc['topic']} has {num_blocks} blocks")
            delete_thread(thread_id)


    
def change_thread_model():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        #print(doc)
        thread_db = ThreadDb(
            content=Thread(
                headline=Message(
                    text=doc['headline']
                ),
                topic=doc['topic']
            ),
            tenant_id=doc['tenant_id'],
            creator_id=doc['creator_id'],
            created_at=doc['created_at'],
            last_modified=doc['last_modified']
        )
        create_mongo_doc_sync(
            document= jsonable_encoder(thread_db),
            collection=threads_collection)
        
        thread_id = doc['_id']
        delete_thread(thread_id)
            
def delete_thread_with_id(id):
    threads_collection = app.mongodb["threads"]
    doc = threads_collection.find_one({"_id": id})
    if doc:
        delete_thread(id)
    else:
        print(f"Thread {id} not found")
                   
async def main():
    startup_db_client()
    #remove_thread_content_data()
    #update_last_modified()
    #rename_created_date_to_created_at()
    #rename_thread_types()
    #delete_threads_with_less_than_n_blocks(5)
    #delete_thread_with_id("4510d5bf-ed75-477a-90b4-fea734d3c6ad")
    #delete_threads_with_type("slack")
    #delete_threads_with_type("todo")
    #delete_threads_with_topic_pattern("Reply")
    change_thread_model()
    shutdown_db_client()


if __name__ == "__main__":
    asyncio.run(main())
