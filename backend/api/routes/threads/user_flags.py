import logging
from fastapi.encoders import jsonable_encoder
from routes.threads.models import UserThreadFlagModel
from utils.db import create_mongo_document, create_mongo_document_sync, get_mongo_document, syncdb, get_mongo_document_sync, update_mongo_document_fields, update_mongo_document_fields_sync

logger = logging.getLogger(__name__)


def update_user_flags(thread_id, user_id, tenant_id, unread=None, upvote=None, bookmark=None, unfollow=None, mention=None):
    try:

        user_thread_flag = get_mongo_document_sync({"thread_id": thread_id, "user_id": user_id},
                                                    syncdb.user_thread_flags_collection, tenant_id=tenant_id)

        if not user_thread_flag:
            user_thread_flag_doc = UserThreadFlagModel(
                user_id=user_id,
                thread_id=thread_id,
                tenant_id=tenant_id,
                unread=unread if unread else None,
                unfollow=unfollow if unfollow else None,
                bookmark=bookmark if bookmark else None,
                upvote=upvote if upvote else None,
                mention=mention if mention else None
            )
            user_thread_flag_jsonable = jsonable_encoder(user_thread_flag_doc)
            create_mongo_document_sync(
                id=user_thread_flag_doc.id,
                document=user_thread_flag_jsonable,
                collection=syncdb.user_thread_flags_collection)

            return user_thread_flag_jsonable

        user_thread_flag["unread"] = unread if unread is not None else user_thread_flag["unread"]
        user_thread_flag["unfollow"] = unfollow if unfollow is not None else user_thread_flag["unfollow"]
        user_thread_flag["bookmark"] = bookmark if bookmark is not None else user_thread_flag["bookmark"]
        user_thread_flag["upvote"] = upvote if upvote is not None else user_thread_flag["upvote"]
        if mention is not None:
            user_thread_flag["mention"] = mention

        updated_user_thread_flag =  update_mongo_document_fields_sync({"_id": user_thread_flag["_id"]}, user_thread_flag,
                                                                      syncdb.user_thread_flags_collection)

        return updated_user_thread_flag
    except Exception as e:
        logger.error(e, exc_info=True)
        return None

def set_unread_other_users(thread_id, user_id, tenant_id):
    other_users =  list(syncdb.users_collection.find({"tenant_id": tenant_id, "_id": {"$ne": user_id}}))
    syncdb.user_thread_flags_collection.update_many({"thread_id": thread_id, "user_id": {"$in": other_users}}, {"$set": {"unread": True}})
    
# Set flags true for all other users in the thread except the user_id
def set_flags_true_other_users(thread_id, user_id, tenant_id, unread=None, upvote=None, bookmark=None, unfollow=None, mention=None):
    try:
        if thread_id is None or user_id is None or tenant_id is None:
            print("\n ❌ [ERROR]: thread_id, user_id or tenant_id is None",
                  thread_id, user_id, tenant_id)

            return None
        users =  list(syncdb.users_collection.find({"tenant_id": tenant_id}))
        for user in users:
            other_user_id = user["_id"]
            if other_user_id == user_id:
                continue
            update_user_flags(thread_id, other_user_id, tenant_id, unread=unread, upvote=upvote, bookmark=bookmark, unfollow=unfollow, mention=mention)
    except Exception as e:
        logger.error(e, exc_info=True)
        return None
