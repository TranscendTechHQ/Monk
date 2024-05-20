import logging
from fastapi.encoders import jsonable_encoder
from routes.threads.models import UserThreadFlagModel
from utils.db import create_mongo_document, get_mongo_document, asyncdb, update_mongo_document_fields

logger = logging.getLogger(__name__)


async def update_user_flags(thread_id, user_id, tenant_id, unread=None, upvote=None, bookmark=None, unfollow=None):
    try:

        user_thread_flag = await get_mongo_document({"thread_id": thread_id, "user_id": user_id},
                                                    asyncdb.user_thread_flags_collection, tenant_id=tenant_id)

        if not user_thread_flag:
            user_thread_flag_doc = UserThreadFlagModel(
                user_id=user_id,
                thread_id=thread_id,
                tenant_id=tenant_id,
                unread=unread if unread else None,
                unfollow=unfollow if unfollow else None,
                bookmark=bookmark if bookmark else None,
                upvote=upvote if upvote else None
            )
            user_thread_flag_jsonable = jsonable_encoder(user_thread_flag_doc)
            await create_mongo_document(
                id=user_thread_flag_doc.id,
                document=user_thread_flag_jsonable,
                collection=asyncdb.user_thread_flags_collection)

            return user_thread_flag_jsonable

        user_thread_flag["unread"] = unread if unread is not None else user_thread_flag["unread"]
        user_thread_flag["unfollow"] = unfollow if unfollow is not None else user_thread_flag["unfollow"]
        user_thread_flag["bookmark"] = bookmark if bookmark is not None else user_thread_flag["bookmark"]
        user_thread_flag["upvote"] = upvote if upvote is not None else user_thread_flag["upvote"]

        updated_user_thread_flag = await update_mongo_document_fields({"_id": user_thread_flag["_id"]}, user_thread_flag,
                                                                      asyncdb.user_thread_flags_collection)

        return updated_user_thread_flag
    except Exception as e:
        logger.error(e, exc_info=True)
        return None


async def set_unread_true_other_users(thread_id, user_id, tenant_id):
    try:
        if thread_id is None or user_id is None or tenant_id is None:
            print("\n ❌ [ERROR]: thread_id, user_id or tenant_id is None",
                  thread_id, user_id, tenant_id)

            return None
        users = await asyncdb.users_collection.find({"tenant_id": tenant_id}).to_list(None)
        for user in users:
            other_user_id = user["_id"]
            if other_user_id == user_id:
                continue
            await update_user_flags(thread_id, other_user_id, tenant_id, unread=True)
    except Exception as e:
        logger.error(e, exc_info=True)
        return None
