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


def rename_last_modified_to_headline_last_modified():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        threads_collection.update_one({"_id": thread_id}, {'$rename': {
            'headline_last_modified': 'last_modified'
        }})


async def main():
    startup_db_client()
    rename_last_modified_to_headline_last_modified()
    shutdown_db_client()


if __name__ == "__main__":
    asyncio.run(main())
