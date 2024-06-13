import logging
from fastapi.encoders import jsonable_encoder
from routes.threads.models import UserFilterPreferenceModel, UserThreadFlagModel
from utils.db import create_mongo_document, create_mongo_document_sync, create_or_replace_mongo_doc, get_mongo_document, syncdb, get_mongo_document_sync, update_mongo_document_fields, update_mongo_document_fields_sync, asyncdb

logger = logging.getLogger(__name__)


def update_user_flags(thread_id, user_id, tenant_id, unread=None, upvote=None, bookmark=None, unfollow=None, mention=None, assigned=None):
    try:
        if thread_id is None or user_id is None or tenant_id is None:
            print(
                f"\n ❌ [ERROR]: thread_id:{thread_id}, user_id:{user_id} or tenant_id:{tenant_id} is None",)
            return None
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
                mention=mention if mention else None,
                assigned=assigned if assigned else None
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
        # user_thread_flag["mention"] = mention if mention is not None else user_thread_flag["mention"]
        user_thread_flag["assigned"] = assigned if assigned is not None else user_thread_flag["assigned"]
        if mention is not None:
            user_thread_flag["mention"] = mention

        updated_user_thread_flag = update_mongo_document_fields_sync({"_id": user_thread_flag["_id"]}, user_thread_flag,
                                                                     syncdb.user_thread_flags_collection)

        return updated_user_thread_flag
    except Exception as e:
        logger.error(e, exc_info=True)
        return None


def set_unread_other_users(thread_id, user_id, tenant_id):
    other_users = list(syncdb.users_collection.find(
        {"tenant_id": tenant_id, "_id": {"$ne": user_id}}))
    syncdb.user_thread_flags_collection.update_many(
        {"thread_id": thread_id, "user_id": {"$in": other_users}}, {"$set": {"unread": True}})

# Set flags true for all other users in the thread except the user_id


def set_flags_true_other_users(thread_id, user_id, tenant_id, unread=None, upvote=None, bookmark=None, unfollow=None, mention=None, assigned=None):
    try:
        if thread_id is None or user_id is None or tenant_id is None:
            print("\n ❌ [ERROR]: thread_id, user_id or tenant_id is None",
                  thread_id, user_id, tenant_id)

            return None
        users = list(syncdb.users_collection.find({"tenant_id": tenant_id}))
        for user in users:
            other_user_id = user["_id"]
            if other_user_id == user_id:
                continue
            update_user_flags(thread_id, other_user_id, tenant_id, unread=unread,
                              upvote=upvote, bookmark=bookmark, unfollow=unfollow, mention=mention, assigned=assigned)
    except Exception as e:
        logger.error(e, exc_info=True)
        return None


# Save user filter preferences to db
def save_user_filter_preferences(user_id, tenant_id, filter_preferences: UserFilterPreferenceModel):
    try:
        user_filter_preferences_doc = {
            "user_id": user_id,
            "tenant_id": tenant_id,
            'bookmark': filter_preferences.bookmark,
            'mention': filter_preferences.mention,
            'unfollow': filter_preferences.unfollow,
            'unread': filter_preferences.unread,
            'upvote': filter_preferences.upvote,
            'searchQuery': filter_preferences.searchQuery,
            'assigned': filter_preferences.assigned
        }
        # user_filter_preferences_jsonable = jsonable_encoder(user_filter_preferences_doc)
        create_or_replace_mongo_doc(id=user_id,
                                    document=user_filter_preferences_doc,
                                    collection=asyncdb.user_news_feed_filter_collection)

        return user_filter_preferences_doc
    except Exception as e:
        logger.error(e, exc_info=True)
        return None

# Function to retrieve user filter preferences


async def get_user_filter_preferences_from_db(user_id, tenant_id):
    try:
        user_filter_preferences = await get_mongo_document({"user_id": user_id},
                                                           asyncdb.user_news_feed_filter_collection, tenant_id=tenant_id)
        if user_filter_preferences:
            return UserFilterPreferenceModel(**user_filter_preferences)
        else:
            return None
    except Exception as e:
        logger.error(e, exc_info=True)
        return None
