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


async def main():
    startup_db_client()
    copy_creator_from_metadata_to_thread()
    shutdown_db_client()


if __name__ == "__main__":
    asyncio.run(main())
