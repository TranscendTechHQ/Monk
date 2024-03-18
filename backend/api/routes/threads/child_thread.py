from .models import BlockModel, ThreadModel
from utils.db import create_mongo_document, get_block_by_id, update_block_child_id


async def create_child_thread(thread_collection, 
                       parent_block_id, 
                       parent_thread_id, 
                       thread_title,
                       thread_type,
                       creator_name):
    

    
    # fetch the parent block
    block = await get_block_by_id(parent_block_id, thread_collection)
    if not block:
        print("block with id ${parent_block_id} not found")
        
    block = block["content"]
    if "child_id" in block.keys():
        if block["child_id"] != "":
            print("block already has a child thread")
            return
    #print(block)
    # create a new child thread

    parent_block = BlockModel(**block)
    blocks = []
    blocks.append(parent_block)
    
    new_thread = ThreadModel(creator=creator_name, title=thread_title, type=thread_type,
                                 content=blocks)
    created_child_thread = await create_mongo_document(new_thread.model_dump(), 
                                          thread_collection)
    
    child_thread_id = created_child_thread["id"]
    
    # now update the parent block with the child thread id
    await update_block_child_id(
        thread_collection, parent_block_id, parent_thread_id, child_thread_id)