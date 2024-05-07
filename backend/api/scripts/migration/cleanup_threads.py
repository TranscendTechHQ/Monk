import asyncio

from pymongo import MongoClient

from config import settings


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
            
       
        
async def main():
    startup_db_client()
    #remove_thread_content_data()
    #update_last_modified()
    #rename_created_date_to_created_at()
    rename_thread_types()
    shutdown_db_client()


if __name__ == "__main__":
    asyncio.run(main())
