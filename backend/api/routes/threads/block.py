
import datetime as dt
from typing import Any
from routes.threads.user_flags import set_flags_true_other_users
from utils.db import create_mongo_document, get_block_by_id, get_mongo_document, asyncdb, update_mongo_document_fields
import logging

logger = logging.getLogger(__name__)

# Function to update block in db


async def updateBlock(block_in_db, user_id: str, tenant_id: str, block_content: str = None, bloc_position: int = None):
    try:
        if (block_content is None and bloc_position is None):
            return block_in_db

        block_collection = asyncdb.blocks_collection
        update_block = block_in_db
        if (block_content is not None):
            print("\n 👉 Updating block content")
            update_block["content"] = block_content

        if (bloc_position is not None):
            print("\n 👉 Updating block position")
            update_block["position"] = bloc_position

        update_block["last_modified"] = str(dt.datetime.now())

        print("\n 👉 Updating block in db",)

        updated_block = await update_mongo_document_fields({"_id": update_block["_id"]}, update_block, block_collection)

        thread_id = updated_block["main_thread_id"]
        set_flags_true_other_users(thread_id, user_id, tenant_id, unread=True)

        return updated_block
    except Exception as e:
        logger.error(e, exc_info=True)
        return None
