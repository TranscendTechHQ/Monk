import asyncio

from pymongo import MongoClient

from utils.db import asyncdb, shutdown_async_db_client, startup_async_db_client
from config import settings


async def print_block_keys():
    threads_collection = asyncdb.threads_collection
    cursor = threads_collection.find({})
    documents = await cursor.to_list(length=None)
    for doc in documents:
        block_list = doc['content']
        for block in block_list:
            print(block.keys())


async def main():
    await startup_async_db_client()
    await print_block_keys()
    await shutdown_async_db_client()


if __name__ == "__main__":
    asyncio.run(main())
