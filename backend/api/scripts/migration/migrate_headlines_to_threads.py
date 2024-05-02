import asyncio

from pymongo import MongoClient

from utils.db import shutdown_async_db_client, startup_async_db_client
from scripts.db.thread_headline import generate_all_thread_headlines
from config import settings
from utils.headline import generate_single_thread_headline




async def main():
    await startup_async_db_client()
    #generate_all_thread_headlines(500, use_ai=False)
    await generate_single_thread_headline(
        "af6f0744-0679-47d4-8838-db02312cc61e", use_ai=False
    )
    await shutdown_async_db_client()


if __name__ == "__main__":
    asyncio.run(main())
