import asyncio
import pprint
import threading

from pymongo import MongoClient, UpdateOne

from config import settings
from routes.threads.search import thread_semantic_search
from utils.embedding import generate_embedding


def start_timer(delay, func):
    # Simulate your event triggering the timer
    print("Event triggered, starting timer!")
    timer = threading.Timer(delay, func)
    timer.start()


class App:
    pass


app = App()


def startup_db_client():
    app.mongodb_client = MongoClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]


def shutdown_db_client():
    app.mongodb_client.close()


def update_thread_creator():
    collection = app.mongodb["threads"]
    requests = []
    for doc in collection.find({'title': {"$exists": True}}).limit(500):
        # print(doc['content'])

        requests.append(UpdateOne({'_id': doc['_id']}, {'$set': {'creator': "Yogesh K. Soni"}}))

    collection.bulk_write(requests)


def generate_single_thread_embedding(thread_doc):
    embeddings = {}
    embeddings_collection = app.mongodb["thread_embeddings"]
    user_collection = app.mongodb["users"]

    title = thread_doc['title']
    text = "This is the content of the thread with title " + title + ". "
    threadType = thread_doc['type']
    text += "The type of the thread is " + threadType + ". "
    createdAt = thread_doc['created_date']
    text += "The thread was created on " + createdAt + ". "
    creator = thread_doc['creator']
    text += "The creator of the thread is " + creator + ". "
    userDoc = user_collection.find_one({'name': creator})
    email = userDoc['email']
    text += "The email of the creator is " + email + ". "
    # print(text)
    embeddings['title'] = title

    # return

    blocks = thread_doc['content']

    for block in blocks:
        # print(block['content'])
        text += block['content'] + " "
    # print (text)

    embeddings['embedding'] = generate_embedding(text)
    embeddings_collection.update_one({'_id': thread_doc['_id']},
                                     {'$set': embeddings}, upsert=True)


def generate_all_threads_embedding():
    thread_collection = app.mongodb["threads"]
    # Update the collection with the embeddings
    # requests = []

    for thread_doc in thread_collection.find({'title': {"$exists": True}}).limit(500):
        # print(doc['content'])
        generate_single_thread_embedding(thread_doc)

        # requests.append(ReplaceOne({'_id': doc['_id']}, doc))

    # collection.bulk_write(requests)


def generate_all_threads_embedding_delayed(delay):
    start_timer(delay, generate_all_threads_embedding)


def move_thread_embedding():
    collection = app.mongodb["threads"]
    dest_collection = app.mongodb["thread_embeddings"]
    embeddings = {}
    requests = []
    for doc in collection.find({'title': {"$exists": True}}).limit(500):
        title = doc['title']
        if 'thread_embedding' in doc:
            embeddings[title] = doc["thread_embedding"]
            # dest_collection.insert_one(embeddings)
            collection.update_one({'_id': doc['_id']}, {'$unset': {'thread_embedding': 1}}, upsert=True)
        # requests.append(UpdateOne({'_id': doc['_id']}, {'$set': {'thread_embedding': embeddings}}))
        # requests.append(ReplaceOne({'_id': doc['_id']}, doc))

    # collection.bulk_write(requests)


async def main():
    startup_db_client()
    # update_thread_creator()
    # generate_embedding_new_api(
    #    "The food was delicious and the waiter was very friendly.")
    # print(embedding)
    # generate_thread_embedding()
    # move_thread_embedding()
    # generate_all_threads_embedding()
    result = await thread_semantic_search(
        "thread about monk next steps")
    pprint.pprint(result)

    shutdown_db_client()


if __name__ == "__main__":
    asyncio.run(main())
