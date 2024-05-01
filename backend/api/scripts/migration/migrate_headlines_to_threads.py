import asyncio

from pymongo import MongoClient

from scripts.db.thread_headline import generate_all_thread_headlines
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




async def main():
    startup_db_client()
    generate_all_thread_headlines(500, use_ai=False)
    shutdown_db_client()


if __name__ == "__main__":
    asyncio.run(main())
