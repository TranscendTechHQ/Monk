import asyncio

from bson import ObjectId
from fastapi.encoders import jsonable_encoder
from pymongo import MongoClient

from config import settings
from routes.threads.models import Message, MessageDb, ThreadDb
from utils.db import create_mongo_doc_sync


from utils.db import asyncdb

class App:
    pass


app = App()


def startup_db_client():
    app.mongodb_client = MongoClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]


def shutdown_db_client():
    app.mongodb_client.close()
async def print_block_keys():
    cursor = asyncdb.threads_collection.find({})
    documents = await cursor.to_list(length=None)
    for doc in documents:
        block_list = doc['content']
        for block in block_list:
            print(block.keys())


async def print_user_keys():
    cursor = asyncdb.users_collection.find({})
    documents = await cursor.to_list(length=None)
    for doc in documents:
        print(doc.keys())

async def rename_fields():
    # Define the field renames
    field_renames = {
        'user_name': 'name',
        'user_picture': 'picture'
    }

    # Rename the fields
    result = await asyncdb.users_collection.update_many(
        {},  # Empty filter to update all documents
        {'$rename': {old_field: new_field for old_field, new_field in field_renames.items()}}
    )

    print(f'Renamed fields in {result.modified_count} documents.')

async def rename_read_to_unread():
    # Define the field renames
    field_renames = {
        'read': 'unread'
    }

    # Rename the fields
    result = await asyncdb.user_thread_flags_collection.update_many(
        {},  # Empty filter to update all documents
        {'$rename': {old_field: new_field for old_field, new_field in field_renames.items()}}
    )

    print(f'Renamed fields in {result.modified_count} documents.')
    
    
async def add_field():
    # Define the field to add
    field_to_add = {
        'field': 'last_login',
        'default_value': ''
    }

    # Rename the fields and add the new field
    result = await asyncdb.users_collection.update_many(
        {},  # Empty filter to update all documents
        {'$set': {f'{field_to_add["field"]}': field_to_add["default_value"]}}
        
    )

    print(f'Updated {result.modified_count} documents.')   

async def cleanup_extra_users():
    yogesh_user_id = "a4983b11-3465-4d00-9281-ec89048ce082"
    users_cursor =   asyncdb.users_collection.find({})
    users_documents = await users_cursor.to_list(length=None)
    user_ids = [ doc['_id'] for doc in users_documents]
    threads_cursor =  asyncdb.threads_collection.find({})
    threads_documents = await threads_cursor.to_list(length=None)
    for doc in threads_documents:
        creator_id = doc['creator_id']
        if creator_id not in user_ids:
            # change the creator id to yogesh_user_id
            await asyncdb.threads_collection.update_one({"_id": doc['_id']}, {'$set': {
                'creator_id': yogesh_user_id
            }})
            print(f"Changed creator_id from {creator_id} to {yogesh_user_id} in thread {doc['_id']}")
    
    blocks_cursor =  asyncdb.blocks_collection.find({})
    blocks_documents = await blocks_cursor.to_list(length=None)
    
    for doc in blocks_documents:
        creator_id = doc['creator_id']
        if creator_id not in user_ids:
            # change the creator id to yogesh_user_id
            await asyncdb.blocks_collection.update_one({"_id": doc['_id']}, {'$set': {
                'creator_id': yogesh_user_id
            }})
            print(f"Changed creator_id from {creator_id} to {yogesh_user_id} in block {doc['_id']}")
    
    user_thread_flags_cursor =  asyncdb.user_thread_flags_collection.find({})
    user_thread_flags_documents = await user_thread_flags_cursor.to_list(length=None)
    
    for doc in user_thread_flags_documents:
        user_id = doc['user_id']
        if user_id not in user_ids:
            # change the creator id to yogesh_user_id
            await asyncdb.user_thread_flags_collection.update_one({"_id": doc['_id']}, {'$set': {
                'user_id': yogesh_user_id
            }})
            print(f"Changed user_id from {user_id} to {yogesh_user_id} in user_thread_flag {doc['_id']}")
    
    
    

async def remove_some_fields():
    # Define the fields to drop
    fields_to_drop = ['created_by', 'creator_email', 'creator_picture']

    # Drop fields from documents
    result = await asyncdb.threads_collection.update_many(
        {},  # Empty filter to update all documents
        {'$unset': {f'content.$[].{field}': '' for field in fields_to_drop}}
    )

    print(f'Dropped fields from {result.modified_count} documents.')


async def drop_field():
    # Define the field to drop
    field_to_drop = 'block_pos_in_child'
    asyncdb.blocks_collection.update_many({}, {"$unset": {field_to_drop: ""}})


async def add_new_field():
    # Define the fields to add
    fields_to_add = [
        {'field': 'creator_id', 'default_value': 'a4983b11-3465-4d00-9281-ec89048ce082'},
        {'field': 'child_thread_id', 'default_value': ''}
    ]

    # Add new field to documents
    result = await asyncdb.threads_collection.update_many(
        {},  # Empty filter to update all documents
        {'$set': {f'content.$[].{field_info["field"]}': field_info["default_value"]
                  for field_info in fields_to_add}}
    )

    print(f'Added new field to {result.modified_count} documents.')




async def remove_blocks_from_threads():
    result = await asyncdb.threads_collection.update_many(
        {},  # Empty filter to update all documents
        {'$unset': {'content': ''}}
    )

    print(f'Removed blocks from {result.modified_count} documents.')


async def remove_blocks_from_blocks_collection():
    result = await asyncdb.blocks_collection.find({}).to_list(length=None)
    for block in result:
        if not block['main_thread_id'] == "0e87e9bb-27c5-4e2c-9f0b-c7d80f97cc2a":
            await asyncdb.blocks_collection.delete_one({"_id": block["_id"]})



def rename_last_modified_to_headline_last_modified():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        threads_collection.update_one({"_id": thread_id}, {'$rename': {
            'headline_last_modified': 'last_modified'
        }})

def rename_creator_to_creator_id():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        threads_collection.update_one({"_id": thread_id}, {'$rename': {
            'creator': 'creator_id'
        }})
        
def remove_thread_content_data():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        threads_collection.update_one({"_id": thread_id}, {'$unset': {
            'content': ''
        }})

def update_last_modified():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        if 'last_modified' not in doc:
            print('no last_modified')
            doc['last_modified'] = doc['created_at']
        threads_collection.update_one({"_id": thread_id}, {'$set': {
            'last_modified': doc['last_modified']
        }}, upsert=True)
        
def rename_created_date_to_created_at():
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        threads_collection.update_one({"_id": thread_id}, {'$rename': {
            'created_date': 'created_at'
        }})
        
            
def delete_thread(thread_id):
    threads_collection = app.mongodb["threads"]
    blocks_collection = app.mongodb["blocks"]
    thread = threads_collection.find_one({"_id": thread_id})
    user_thread_flags_collection = app.mongodb["user_thread_flags"]
    if thread:
        blocks_collection.delete_many({"main_thread_id": thread_id})
        blocks = blocks_collection.find({"child_thread_id": thread_id})
        for block in blocks:
            blocks_collection.update_one({"_id": block["_id"]}, {'$set': {
                'child_thread_id': ''
            }})
        flags = user_thread_flags_collection.find({"thread_id": thread_id})
        for flag in flags:
            user_thread_flags_collection.delete_one({"_id": flag["_id"]})
            
        threads_collection.delete_one({"_id": thread_id})
        print(f"Deleted thread {thread_id} named {thread['topic']}")
    else:
        print(f"Thread {thread_id} not found") 
        
def delete_threads_with_less_than_n_blocks(n):
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        num_blocks = doc['num_blocks']
        if num_blocks < n:
            #print(f"Thread {doc['topic']} has {num_blocks} blocks")
            delete_thread(thread_id)

def delete_threads_with_type(type):
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        if doc['type'] == type:
            #print(f"Thread {doc['topic']} has {num_blocks} blocks")
            delete_thread(thread_id)

def delete_threads_with_topic_pattern(pattern):
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection.find():
        thread_id = doc['_id']
        if pattern in doc['topic']:
            #print(f"Thread {doc['topic']} has {num_blocks} blocks")
            delete_thread(thread_id)

def fix_messages_thread_id():

    messages_collection = app.mongodb["messages"]
    threads_old_collection = app.mongodb["threads_back"]
    
    for doc in messages_collection.find():
        #print(doc)
        old_thread_id = doc['thread_id']
        thread = threads_old_collection.find_one({"_id": ObjectId(old_thread_id)})
        if thread:
            #print("hey")
            correct_thread_id = thread["thread_id"]
            #print(correct_thread_id)
            messages_collection.update_one(
                {"_id": doc["_id"]},
                {"$set": {"thread_id": correct_thread_id}}
            )
      

def change_messages_model():
    messages_collection_old = app.mongodb["messages_old"]
    messages_collection = app.mongodb["messages"]
    for doc in messages_collection_old.find():
        #print(doc)
        message_db = MessageDb(
            #id = doc['_id'],
            text=doc['content']['text'],
            image=doc['content']['image'],
            link_meta=doc['content']['link_meta'],
            #tenant_id=doc['tenant_id'],
            tenant_id="T048F0ANS1M",
            creator_id=doc['creator_id'],
            created_at=doc['created_at'],
            last_modified=doc['last_modified'],
            thread_id=doc['thread_id']
        )
        create_mongo_doc_sync(
            document= jsonable_encoder(message_db),
            collection=messages_collection)
        
    
def change_thread_model():
    threads_collection_old = app.mongodb["threads_bak"]
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection_old.find():
        #print(doc)
        thread_db = ThreadDb(
            id = doc['_id'],
            text=doc['headline']['text'],
            image=doc['headline']['image'],
            link_meta=doc['headline']['link_meta'],
            topic = doc['topic'],
            tenant_id=doc['tenant_id'],
            creator_id=doc['creator_id'],
            created_at=doc['created_at'],
            last_modified=doc['last_modified']
        )
        create_mongo_doc_sync(
            document= jsonable_encoder(thread_db),
            collection=threads_collection)
        
        #thread_id = doc['_id']
        #delete_thread(thread_id)

def add_thread_id_to_threads():
    threads_collection_old = app.mongodb["threads_old"]
    threads_collection = app.mongodb["threads"]
    for doc in threads_collection_old.find():
        #print(doc)
        topic = doc['topic']
        thread = threads_collection.find_one({"content.topic": topic})
        if thread:
            thread_id = doc['_id']
            new_thread_id = thread['_id']
            threads_collection.update_one({"_id": new_thread_id}, {'$set': {
                'thread_id': thread_id
            }})
            print(f"Added thread_id to thread {thread_id} named {topic}")
        else:
            print(f"Thread {topic} not found")
        
        #thread_id = doc['_id']
        #delete_thread(thread_id)
                   
def delete_thread_with_id(id):
    threads_collection = app.mongodb["threads"]
    doc = threads_collection.find_one({"_id": id})
    if doc:
        delete_thread(id)
    else:
        print(f"Thread {id} not found")

def migrate_blocks_to_messages():
    blocks_collection = app.mongodb["blocks"]
    threads_collection = app.mongodb["threads"]
    threads_collection_old = app.mongodb["threads_old"]
    messages_collection = app.mongodb["messages"]
    for doc in threads_collection_old.find():
        thread_id_old = doc['_id']
        thread_topic = doc['topic']
        thread = threads_collection.find_one({"content.topic": thread_topic})
        thread_id = thread['_id']
        if thread:
            blocks = blocks_collection.find({"main_thread_id": thread_id_old})
            for block in blocks:
                image = None
                link_meta = None
                content = None
                if 'image' in block:
                    image = block['image']
                if 'link_meta' in block:
                    link_meta = block['link_meta']
                if 'content' in block:
                    content = block['content']
                msg = MessageDb(
                    content=Message(
                        text=content,
                        image=image,
                        link_meta=link_meta
                    ),
                    creator_id=block['creator_id'],
                    created_at=block['created_at'],
                    last_modified=block['last_modified'],
                    tenant_id=block['tenant_id'],
                    thread_id=str(thread_id)
                )
                create_mongo_doc_sync(
                    document=jsonable_encoder(msg),
                    collection=messages_collection,
                )
                
def modify_thread_fields():
    threads_collection = app.mongodb["threads_back"]
    ## move the fields inside content object outside it
    

        
    for thread in threads_collection.find():
            
        thread_id = thread["_id"]
        if 'content' in thread.keys():
            topic = thread['content']['topic']
            threads_collection.update_one(
                    filter={"_id": ObjectId(thread_id)},
                    update={"$set": {"topic": topic}},
                )
            headline = thread['content']['headline']
            threads_collection.find_one_and_update(
                    filter={"_id": ObjectId(thread_id)},
                    update={"$set": {"headline": headline}},
                )
            threads_collection.find_one_and_update(
                filter={"_id": ObjectId(thread_id)},
                update = {"$unset": {"content":""}}
            )
            threads_collection.find_one_and_update(
                    filter={"_id": ObjectId(thread_id)},
                    update={"$set": {"tenant_id": "T048F0ANS1M"}},
                )
           
def cleanup_image_urls():
    messages_collection = app.mongodb["messages"]
    for doc in messages_collection.find():
        message_id = doc['_id']
        if 'image' in doc and doc['image'] is not None:
            image = doc['image']
            print(image)
            ## if image is a string and contains https://assets.heymonk.app/, remove https://assets.heymonk.app/ and just keep the filename
            if isinstance(image, str) and "https://assets.heymonk.app/" in image:
                image = image.replace("https://assets.heymonk.app/", "")
                print(f"modified image: {image}")
                messages_collection.update_one(
                    {"_id": message_id},
                    {"$set": {"image": image}}
                )
            
async def main():
    startup_db_client()
    #remove_thread_content_data()
    #update_last_modified()
    #rename_created_date_to_created_at()
    #rename_thread_types()
    #delete_threads_with_less_than_n_blocks(5)
    #delete_thread_with_id("4510d5bf-ed75-477a-90b4-fea734d3c6ad")
    #delete_threads_with_type("slack")
    #delete_threads_with_type("todo")
    #delete_threads_with_topic_pattern("Reply")
    #change_thread_model()
    #change_messages_model()
    #migrate_blocks_to_messages()
    #add_thread_id_to_threads()
    #modify_thread_fields()
    #fix_messages_thread_id()
    cleanup_image_urls()
    shutdown_db_client()


if __name__ == "__main__":
    asyncio.run(main())
