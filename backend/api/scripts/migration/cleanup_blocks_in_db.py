import asyncio

from pymongo import MongoClient

from utils.db import asyncdb, shutdown_async_db_client, startup_async_db_client
from config import settings



async def print_block_keys():
    cursor = asyncdb.threads_collection.find({})
    documents = await cursor.to_list(length=None)
    for doc in documents:
        block_list = doc['content']
        for block in block_list:
            print(block.keys())

async def remove_some_fields():
    # Define the fields to drop
    fields_to_drop = ['created_by', 'creator_email', 'creator_picture']

    # Drop fields from documents
    result = await asyncdb.threads_collection.update_many(
        {},  # Empty filter to update all documents
        {'$unset': {f'content.$[].{field}': '' for field in fields_to_drop}}
    )

    print(f'Dropped fields from {result.modified_count} documents.')

async def main():
    await startup_async_db_client()
    await print_block_keys()
    #await remove_some_fields()
    await shutdown_async_db_client()


if __name__ == "__main__":
    asyncio.run(main())
