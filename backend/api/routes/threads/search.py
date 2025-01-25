from motor.motor_asyncio import AsyncIOMotorClient

from config import settings
from utils.db import get_aggregate_async
from utils.embedding import generate_embedding


class Search:
    pass


search: Search = Search()


def startup_db_client():
    search.mongoClient = AsyncIOMotorClient(settings.DB_URL)
    search.db = search.mongoClient[settings.DB_NAME]
    search.threads_collection = search.db["threads"]
    search.embedding_collection = search.db["thread_embeddings"]


def shutdown_db_client():
    search.mongoClient.close()


async def thread_semantic_search(query):
    startup_db_client()
    embedding = generate_embedding(query)
    pipeline = [

        {"$vectorSearch": {
            "queryVector": embedding,
            "path": "embedding",
            "numCandidates": 100,
            "limit": 3,
            "index": "thread_index",
        }},

        {'$project': {
            'topic': 1,
            'score': {
                '$meta': 'vectorSearchScore'
            }
        }},

        {'$sort': {
            'score': -1
        }}

    ]

    results = await get_aggregate_async(pipeline=pipeline, collection=search.embedding_collection)

    # for doc in cursor:
    #    print(doc)
    shutdown_db_client()
    return results
