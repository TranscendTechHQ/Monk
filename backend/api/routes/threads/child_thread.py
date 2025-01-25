import datetime
import logging
from fastapi import HTTPException
from fastapi.encoders import jsonable_encoder

from routes.threads.user_flags import set_flags_true_other_users
from utils.db import create_mongo_document_async, get_mongo_document_async, update_block_child_id, \
    asyncdb
from utils.headline import generate_single_thread_headline
from .models import BlockModel, ThreadModel, ThreadType

logger = logging.getLogger(__name__)


# creates a new thread or returns an existing thread. Content
# is blank for the new thread
async def create_new_thread(user_id, tenant_id, topic: str, thread_type: ThreadType,
                            parent_block_id: str = None,
                            created_at=None, slack_thread_ts: float = None,
                            assigned_to_id: str = None
                            ):
    try:
        old_thread = await get_mongo_document_async(filter={"topic": topic}, collection=asyncdb.threads_collection, tenant_id=tenant_id)
        if not old_thread:
            # userinfo = await asyncdb.users_collection.find_one({"_id": user_id})
            # if not userinfo:
            #     print("User not found")
            #     return None
            # creator = {}
            # if userinfo is not None:
            #     creator["id"] = userinfo["_id"]
            #     creator["name"] = userinfo["name"]
            #     creator["picture"] = userinfo["picture"]
            #     creator["email"] = userinfo["email"]

            print("\n\n 👉 5.a.1 Creating new thread Model",
                  parent_block_id, "\n\n")
            if created_at is None:
                created_at = datetime.datetime.now()
            new_thread = ThreadModel(creator_id=user_id, topic=topic, type=thread_type,
                                     tenant_id=tenant_id, parent_block_id=parent_block_id,
                                     created_at=created_at, slack_thread_ts=slack_thread_ts, last_modified=str(
                                         created_at),
                                     assigned_to_id=assigned_to_id,
                                     )

            print("\n\n 👉 5.a.1.1 Created new thread Model", new_thread, "\n\n")
            new_thread_jsonable = jsonable_encoder(new_thread)
            created_thread = await create_mongo_document_async(
                id=new_thread.id,
                document=new_thread_jsonable,
                collection=asyncdb.threads_collection)

            print("\n 5.a.2 Created thread\n", created_thread)

            generate_single_thread_headline(thread_id=created_thread["_id"], use_ai=False, tenant_id=tenant_id)
            asyncdb.threads_collection.update_one({'_id': created_thread['_id']},
                                                  {'$set': {'headline': 'blank thread'}}, upsert=True)
            thread_id = created_thread["_id"]
            set_flags_true_other_users(thread_id, user_id, tenant_id, unread=True)
        else:
            print("\n 5.a.3 Thread already exists")
            created_thread = old_thread

        print("\n 5.a.4 Returning thread")
        return created_thread
    except Exception as e:
        # print("\n❌ Error in create_new_thread()\n",e)
        logger.error("❌ Error in create_new_thread()", exc_info=True)
        raise HTTPException(status_code=500, detail="Internal Server Error")

# TODO: cleanup unused code here. thread colleciton not needed. parent_block_id or parentBlock, one of them not needed.


async def create_child_thread(parent_block_id, main_thread_id, thread_topic, thread_type, user_id,
                              tenant_id, parentBlock: BlockModel, created_at=None, slack_thread_ts: float = None):
    print("\n 5.a Inside create_child_thread", parentBlock)

    # print("Initiating create new thread")
    created_child_thread = await create_new_thread(user_id, tenant_id, thread_topic, thread_type, parent_block_id=parentBlock.id, created_at=created_at, slack_thread_ts=slack_thread_ts)
    print("\n 5.b Created child thread")
    child_thread_id = created_child_thread["_id"]

    blocks_collection = asyncdb.blocks_collection

    print("\n 5.c Updating parent block with child thread id")
    # now update the parent block with the child thread id
    await update_block_child_id(
        blocks_collection, parent_block_id, main_thread_id, child_thread_id)

    return created_child_thread
