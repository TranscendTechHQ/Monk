from typing import List

from fastapi.encoders import jsonable_encoder

from utils.db import create_mongo_document, get_block_by_id, get_mongo_document, get_user_name, update_block_child_id, \
    asyncdb
from utils.headline import generate_single_thread_headline
from .models import BlockModel, ThreadModel, ThreadType


# creates a new thread or returns an existing thread. Content
# is blank for the new thread
async def create_new_thread(user_id, title: str, thread_type: ThreadType, content: List[BlockModel] = []):
    old_thread = await get_mongo_document({"title": title}, asyncdb.threads_collection)
    if not old_thread:

        full_name = await get_user_name(user_id, asyncdb.users_collection)
        new_thread = ThreadModel(creator=full_name, title=title, type=thread_type,
                                 content=content)
        new_thread_jsonable = jsonable_encoder(new_thread)
        created_thread = await create_mongo_document(new_thread_jsonable,
                                                     asyncdb.threads_collection)

        userinfo = await asyncdb.users_collection.find_one({"_id": user_id})
        if not userinfo:
            print("User not found")
            return None
        creator = {}
        if userinfo is not None:
            creator["id"] = userinfo["_id"]
            creator["name"] = userinfo["user_name"]
            creator["picture"] = userinfo["user_picture"]
            creator["email"] = userinfo["email"]

        meta = {}
        meta["_id"] = new_thread_jsonable["_id"]
        meta["title"] = new_thread_jsonable["title"]
        meta["type"] = new_thread_jsonable["type"]
        meta["created_date"] = new_thread_jsonable["created_date"]
        meta["creator"] = creator

        # metadata = (metadata_model).model_dump()
        await asyncdb.metadata_collection.replace_one(
            filter={"_id": meta["_id"]},
            replacement=meta,
            upsert=True
            )
        
        generate_single_thread_headline(created_thread, asyncdb.threads_collection, use_ai=False)
    else:
        created_thread = old_thread

    return created_thread


async def create_child_thread(thread_collection, parent_block_id, parent_thread_id, thread_title, thread_type, user_id):
    # fetch the parent block
    block = await get_block_by_id(parent_block_id, thread_collection)
    if not block:
        print("block with id ${parent_block_id} not found")
    # print(block)
    block = block["content"]
    if "child_id" in block.keys():
        if block["child_id"] != "":
            print("block already has a child thread")
            return
    # print(block)
    # create a new child thread

    parent_block = BlockModel(**block)
    blocks = [jsonable_encoder(parent_block)]

    created_child_thread = await create_new_thread(user_id, thread_title, thread_type, blocks)

    child_thread_id = created_child_thread["_id"]

    # now update the parent block with the child thread id
    await update_block_child_id(
        thread_collection, parent_block_id, parent_thread_id, child_thread_id)

    return created_child_thread
