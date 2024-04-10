import asyncio

from pymongo import MongoClient

from config import settings
from utils.headline import generate_single_thread_headline


class App:
    pass


app = App()


def startup_db_client():
    app.mongodb_client = MongoClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]


def shutdown_db_client():
    app.mongodb_client.close()


def generate_all_thread_headlines(num_thread_limit, use_ai=False):
    thread_collection = app.mongodb["threads"]
    # headline_collection = app.mongodb["thread_headlines"]
    for doc in thread_collection.find({'title': {"$exists": True}}).limit(num_thread_limit):
        content = doc['content']
        # if len(content) < 1:
        #    continue
        generate_single_thread_headline(doc, thread_collection, use_ai=use_ai)

        # pprint.pprint(headline['text'])


async def main():
    startup_db_client()
    generate_all_thread_headlines(500, use_ai=False)
    shutdown_db_client()


if __name__ == "__main__":
    asyncio.run(main())
