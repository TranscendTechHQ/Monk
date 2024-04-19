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
    
async def main():
    await startup_async_db_client()
    await rename_fields()
    await add_field()
    await print_user_keys()
    #await remove_some_fields()
    #await add_new_field()
    await shutdown_async_db_client()


if __name__ == "__main__":
    asyncio.run(main())
