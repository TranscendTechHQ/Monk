import asyncio
import threading

import motor.motor_asyncio

from config import settings


def start_timer(delay, func):
    # Simulate your event triggering the timer
    print("Event triggered, starting timer!")
    timer = threading.Timer(delay, func)
    timer.start()


class App:
    pass


app = App()


async def startup_db_client():
    app.mongodb_client = motor.motor_asyncio.AsyncIOMotorClient(settings.DB_URL)
    # print(app.mongodb_client.list_database_names())
    app.mongodb = app.mongodb_client[settings.DB_NAME]


async def shutdown_db_client():
    app.mongodb_client.close()


def update_block():
    threads_collection = app.mongodb["threads"]
    query = {'_id': "713059f7-b4ca-49ed-a35c-d28e6569da81"}
    update = {'$set': {'content.$[elem].content': 'howdy'}}
    # Find the document with the "_id" of "385029"

    threads_collection.update_one(query, update,
                                  array_filters=[{'elem._id': "605f037a-89a1-4d0a-8134-a1d6cbc240f9"}])


async def fix_block_ids():
    collection = app.mongodb["threads"]
    # query = {"title":"myidea"}
    # Find the document
    # document = await collection.find_one(query)
    async for document in collection.find({}):
        id = document["_id"]
        for content_item in document['content']:
            # print(content_item)
            if 'id' in content_item:
                content_item['_id'] = content_item.pop('id')
                # print("hey")
            # print(content_item)
        query = {'_id': id}
        result = await collection.update_one(query, {"$set": document})
        print(result.modified_count)


async def main():
    await startup_db_client()

    # update_block()
    # await update_block_child_id(app.mongodb["threads"],
    # "b342a310-cd4e-444e-8f0f-8e511d908b7f",
    # "713059f7-b4ca-49ed-a35c-d28e6569da81",
    # "4564")

    # child_thread = await create_child_thread(
    #                         "b342a310-cd4e-444e-8f0f-8e511d908b7f",
    #                         "713059f7-b4ca-49ed-a35c-d28e6569da81",
    #                         "childThread",
    #                         "chat",
    #                         "yogesh")

    await fix_block_ids()
    await shutdown_db_client()


if __name__ == "__main__":
    asyncio.run(main())
