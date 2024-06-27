import asyncio

from pymongo import MongoClient

from utils.db import asyncdb, shutdown_async_db_client, startup_async_db_client
from config import settings



async def print_user_keys():
    cursor = asyncdb.users_collection.find({})
    documents = await cursor.to_list(length=None)
    for doc in documents:
        print(doc.keys())

async def rename_fields():
    # Define the field renames
    field_renames = {
        'user_name': 'name',
        'user_picture': 'picture'
    }

    # Rename the fields
    result = await asyncdb.users_collection.update_many(
        {},  # Empty filter to update all documents
        {'$rename': {old_field: new_field for old_field, new_field in field_renames.items()}}
    )

    print(f'Renamed fields in {result.modified_count} documents.')

async def rename_read_to_unread():
    # Define the field renames
    field_renames = {
        'read': 'unread'
    }

    # Rename the fields
    result = await asyncdb.user_thread_flags_collection.update_many(
        {},  # Empty filter to update all documents
        {'$rename': {old_field: new_field for old_field, new_field in field_renames.items()}}
    )

    print(f'Renamed fields in {result.modified_count} documents.')
    
    
async def add_field():
    # Define the field to add
    field_to_add = {
        'field': 'last_login',
        'default_value': ''
    }

    # Rename the fields and add the new field
    result = await asyncdb.users_collection.update_many(
        {},  # Empty filter to update all documents
        {'$set': {f'{field_to_add["field"]}': field_to_add["default_value"]}}
        
    )

    print(f'Updated {result.modified_count} documents.')   

async def cleanup_extra_users():
    yogesh_user_id = "a4983b11-3465-4d00-9281-ec89048ce082"
    users_cursor =   asyncdb.users_collection.find({})
    users_documents = await users_cursor.to_list(length=None)
    user_ids = [ doc['_id'] for doc in users_documents]
    threads_cursor =  asyncdb.threads_collection.find({})
    threads_documents = await threads_cursor.to_list(length=None)
    for doc in threads_documents:
        creator_id = doc['creator_id']
        if creator_id not in user_ids:
            # change the creator id to yogesh_user_id
            await asyncdb.threads_collection.update_one({"_id": doc['_id']}, {'$set': {
                'creator_id': yogesh_user_id
            }})
            print(f"Changed creator_id from {creator_id} to {yogesh_user_id} in thread {doc['_id']}")
    
    blocks_cursor =  asyncdb.blocks_collection.find({})
    blocks_documents = await blocks_cursor.to_list(length=None)
    
    for doc in blocks_documents:
        creator_id = doc['creator_id']
        if creator_id not in user_ids:
            # change the creator id to yogesh_user_id
            await asyncdb.blocks_collection.update_one({"_id": doc['_id']}, {'$set': {
                'creator_id': yogesh_user_id
            }})
            print(f"Changed creator_id from {creator_id} to {yogesh_user_id} in block {doc['_id']}")
    
    user_thread_flags_cursor =  asyncdb.user_thread_flags_collection.find({})
    user_thread_flags_documents = await user_thread_flags_cursor.to_list(length=None)
    
    for doc in user_thread_flags_documents:
        user_id = doc['user_id']
        if user_id not in user_ids:
            # change the creator id to yogesh_user_id
            await asyncdb.user_thread_flags_collection.update_one({"_id": doc['_id']}, {'$set': {
                'user_id': yogesh_user_id
            }})
            print(f"Changed user_id from {user_id} to {yogesh_user_id} in user_thread_flag {doc['_id']}")
    
    
    
async def main():
    await startup_async_db_client()
    #await rename_fields()
    #await add_field()
    #await print_user_keys()
    #await remove_some_fields()
    #await add_new_field()
    #await rename_read_to_unread()
    await cleanup_extra_users()

    await shutdown_async_db_client()
    
    

if __name__ == "__main__":
    asyncio.run(main())
