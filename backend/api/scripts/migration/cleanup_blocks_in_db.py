import asyncio

from fastapi.encoders import jsonable_encoder
from pymongo import MongoClient

from routes.threads.models import BlockModel
from utils.db import asyncdb, create_mongo_document, shutdown_async_db_client, startup_async_db_client
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


async def add_new_field():
    # Define the fields to add
    fields_to_add = [
        {'field': 'creator_id', 'default_value': 'a4983b11-3465-4d00-9281-ec89048ce082'},
        {'field': 'child_thread_id', 'default_value': ''}
    ]

    # Add new field to documents
    result = await asyncdb.threads_collection.update_many(
        {},  # Empty filter to update all documents
        {'$set': {f'content.$[].{field_info["field"]}': field_info["default_value"]
                  for field_info in fields_to_add}}
    )

    print(f'Added new field to {result.modified_count} documents.')


async def migrate_blocks_to_new_collection():
    threads_collection = asyncdb.threads_collection
    blocks_collection = asyncdb.blocks_collection
    threads = await threads_collection.find({}).to_list(length=None)
    for thread in threads:
        blocks = thread['content']
        pos = 0
        for block in blocks:
            doc = await blocks_collection.find_one({"_id": block['_id']})
            if doc:  # check if block exists
                print("Block already exists")
                # this is the child block
                doc['child_thread_id'] = thread['_id']
                await asyncdb.blocks_collection.replace_one({"_id": block['_id']}, doc, upsert=True)
            else:
                new_block = BlockModel(**block)
                new_block.main_thread_id = thread['_id']
                new_block.position = pos
                new_block.tenant_id = thread['tenant_id']
                new_block.last_modified = thread['last_modified']

                await create_mongo_document(jsonable_encoder(new_block), blocks_collection)

            pos += 1


async def remove_blocks_from_threads():
    result = await asyncdb.threads_collection.update_many(
        {},  # Empty filter to update all documents
        {'$unset': {'content': ''}}
    )

    print(f'Removed blocks from {result.modified_count} documents.')


async def remove_blocks_from_blocks_collection():
    result = await asyncdb.blocks_collection.find({}).to_list(length=None)
    for block in result:
        if not block['main_thread_id'] == "0e87e9bb-27c5-4e2c-9f0b-c7d80f97cc2a":
            await asyncdb.blocks_collection.delete_one({"_id": block["_id"]})


async def add_num_blocks_to_threads():
    threads = await asyncdb.threads_collection.find({}).to_list(length=None)
    for thread in threads:
        blocks = thread['content']
        num_blocks = len(blocks)
        await asyncdb.threads_collection.update_one({"_id": thread['_id']}, {'$set': {'num_blocks': num_blocks}})


async def main():
    await startup_async_db_client()
    # await print_block_keys()
    # await remove_some_fields()
    # await add_new_field()
    # await migrate_blocks_to_new_collection()
    # await remove_blocks_from_blocks_collection()
    await add_num_blocks_to_threads()
    await shutdown_async_db_client()


if __name__ == "__main__":
    asyncio.run(main())
