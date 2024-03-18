

import pprint
from uuid import UUID
import uuid
from routes.threads.models import BlockModel, ThreadModel
from routes.threads.search import thread_semantic_search
from utils.embedding import generate_embedding
from config import settings
from pymongo import MongoClient, UpdateOne
from pymongo import ReplaceOne
import os
import asyncio
import threading
from utils.db import create_mongo_document, get_block_by_id, update_block_child_id


def start_timer(delay, func):
  # Simulate your event triggering the timer
  print("Event triggered, starting timer!")
  timer = threading.Timer(delay, func)
  timer.start()

class App:
    pass

app = App()


async def child_thread(thread_collection, 
                       parent_block_id, 
                       parent_thread_id):
    

    
    # fetch the parent block
    block = await get_block_by_id(parent_block_id, thread_collection)
    if not block:
        print("block with id ${parent_block_id} not found")
        
    
    block = block["content"]
    #print(block)
    # create a new child thread
    thread_title = "kuchbhi"
    thread_type = "/new-thread"
    parent_block = BlockModel(**block)
    blocks = []
    blocks.append(parent_block)
    
    new_thread = ThreadModel(creator="yogesh", title=thread_title, type=thread_type,
                                 content=blocks)
    created_child_thread = await create_mongo_document(new_thread.model_dump(), 
                                          thread_collection)
    
    child_thread_id = created_child_thread["id"]
    
    # now update the parent block with the child thread id
    await update_block_child_id(
        thread_collection, parent_block_id, parent_thread_id, child_thread_id)
    
    

def startup_db_client():
    app.mongodb_client = MongoClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]



def shutdown_db_client():
    app.mongodb_client.close()

    
    
def update_block() :
    threads_collection = app.mongodb["threads"]
    query = {'_id': "713059f7-b4ca-49ed-a35c-d28e6569da81"}
    update = {'$set': {'content.$[elem].content': 'howdy'}}
    # Find the document with the "_id" of "385029"
    
    threads_collection.update_one(query, update, 
                                  array_filters=[{'elem.id': "605f037a-89a1-4d0a-8134-a1d6cbc240f9"}])
    
    
    
async def main() :
    startup_db_client()
    #update_block()
    #await update_block_child_id(app.mongodb["threads"],
                           # "b342a310-cd4e-444e-8f0f-8e511d908b7f",
                            #"713059f7-b4ca-49ed-a35c-d28e6569da81",
                            #"4564")
    
    await child_thread(app.mongodb["threads"],
                            "b342a310-cd4e-444e-8f0f-8e511d908b7f",
                            "713059f7-b4ca-49ed-a35c-d28e6569da81")
    shutdown_db_client()

if __name__ == "__main__":
    asyncio.run(main())