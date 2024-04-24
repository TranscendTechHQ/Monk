import random

from pymongo import MongoClient
from slack_sdk import WebClient
import asyncio
import json
import uuid

from config import settings
from routes.threads.models import UpdateBlockModel
from routes.threads.child_thread import create_new_thread
from routes.threads.routers import create_new_block
from routes.slack.models import ChannelModel, PublicChannelList

from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

from utils.db import startup_async_db_client, shutdown_async_db_client, asyncdb, get_mongo_document

overall_list = []


class App:
    pass


app = App()


def startup_db_client():
    app.mongodb_client = MongoClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]


def shutdown_db_client():
    app.mongodb_client.close()


# count = 0

# Function to fetch and print replies to a message in a Slack channel
def fetch_and_print_replies(slack_client, channel_id, message_ts):
    try:
        reply_count = 0
        parent_message_id = ""

        # Call conversations.replies method using the WebClient
        result = slack_client.conversations_replies(channel=channel_id, ts=message_ts)

        message_list = []
        # Print the replies
        for reply in result['messages']:
            if "subtype" in reply and reply["subtype"] == "bot_message":
                continue

            if "reply_count" in reply and reply["reply_count"] > 0:
                reply_count = reply["reply_count"]

            # global count
            # count += 1
            select_message_data = {}
            message_id = str(uuid.uuid4())
            if "reply_count" in reply and reply["reply_count"] > 0:
                parent_message_id = message_id
            # print(reply["text"])
            select_message_data["creator_id"] = reply['user']
            select_message_data["text"] = reply["text"]
            select_message_data['message_id'] = message_id
            select_message_data["reply"] = True if "parent_user_id" in reply else False
            if "parent_user_id" in reply:
                select_message_data["parent_message_id"] = parent_message_id
            else:
                select_message_data["reply_count"] = reply_count

            # if 'attachments' in reply.keys():
            #    select_message_data["attachments"] = reply["attachments"]
            message_list.append(select_message_data)
            overall_list.append(select_message_data)
            # print(reply.keys())
            # print(reply["user"] + '---' + reply["text"])  # Adjust this based on the structure of your messages
        # print('\n\n')

    except SlackApiError as e:
        print(f"Error fetching replies: {e.response['error']}")


def get_channel_messages(slack_client, channel_id, write_to_json=False, limit=1000):
    try:
        # Call conversations.history to retrieve messages
        response = slack_client.conversations_history(channel=channel_id, limit=limit)

        if response["ok"]:
            messages = response["messages"]
            messages.reverse()

            # Print each message with timestamp and username
            for message in messages:
                # print(message["text"])
                # print(message.keys())
                # if 'blocks' in message.keys():
                #    print(message['blocks'])
                # print(f"{message['ts']} - {message['user']}: {message['text']}")
                # pprint.pprint(json.dumps(message))
                fetch_and_print_replies(slack_client, channel_id, message['ts'])
                # print('\n\n')
            # Specify the file path to write the array

            overall_messages = {}
            overall_messages["messages"] = overall_list

            if write_to_json:
                # File path to write the JSON data
                file_path = "messages.json"

                # Write the dictionary as JSON to the file
                with open(file_path, "w") as outfile:
                    json.dump(overall_messages, outfile)
                # print(overall_list)
                # print(count)
            return overall_list

        else:
            print(f"Error: {response['error']}")
            return None

    except SlackApiError as e:
        print(f"Error: {e}")


def get_channel_list(slack_client):
    try:
        channel_list = []
        # channel_map = {}
        # Call conversations.list method using the WebClient
        # print("Fetching channel list...")
        result = slack_client.conversations_list()
        # print("Channel list fetched successfully.")
        # Print the list of channels
        for channel in result['channels']:
            # print(channel.keys())
            # print(channel['name'] + ' - ' + channel['id'])
            this_channel = ChannelModel(id=channel['id'], name=channel['name'], creator=channel["creator"])
            channel_list.append(this_channel)
            # print(channel['name'] + ' - ' + channel['id'])
        return PublicChannelList(public_channels=channel_list)
    except SlackApiError as e:
        print(f"Error fetching channel list: {e.response['error']}")


def get_user_info(slack_client, user_id):
    try:
        # Call the users.info method using the WebClient
        result = slack_client.users_info(
            user=user_id
        )
        print(result)
        return result

    except SlackApiError as e:
        print("Error fetching conversations: {}".format(e))


async def main():
    print("Starting db client...")
    await startup_async_db_client()
    print("DB client started successfully.")
    # print(db.mongodb_client.list_database_names())
    print("Fetching tenant...")
    tenants_collection = asyncdb.tenants_collection
    threads_collection = asyncdb.threads_collection
    tenants = await tenants_collection.find({}).to_list(length=None)

    for tenant in tenants:
        if "bot_user_id" not in tenant:
            continue

        if tenant["tenant_name"] == "Monk":
            continue

        print("Tenant found successfully.")
        SLACK_USER_TOKEN = tenant["user_token"]
        SLACK_BOT_TOKEN = tenant["bot_token"]

        # Create a Slack client instance
        print("Creating Slack client...")
        slack_client = WebClient(token=SLACK_USER_TOKEN)
        slack_client_for_user_info = WebClient(token=SLACK_BOT_TOKEN)
        print("Slack client created successfully.")
        # fetch all public channels
        channel_list = get_channel_list(slack_client)
        print(channel_list)
        for channel in channel_list.public_channels:
            overall_list.clear()
            thread_title = channel.name
            channel_id = channel.id
            print(f"Fetching messages from channel {channel_id}...")
            # get or create user with slack user ID who created the channel
            users_collection = asyncdb.users_collection
            user = await users_collection.find_one({"thirdparty_user_id": channel.creator})
            if not user:
                slack_user_info = get_user_info(slack_client_for_user_info, channel.creator)

                user_id = uuid.uuid4()
                update_result = await users_collection.update_one({"_id": user_id},
                                                                  {"$set":
                                                                      {
                                                                          "name":
                                                                              slack_user_info["user"]["profile"][
                                                                                  "real_name"],
                                                                          "picture":
                                                                              slack_user_info["user"]["profile"][
                                                                                  "image_original"],
                                                                          "email":
                                                                              slack_user_info["user"]["profile"][
                                                                                  "email"],
                                                                          "tenant_id": tenant["tenant_id"],
                                                                          "super_token_id": "",
                                                                          "thirdparty_provider": "slack",
                                                                          "thirdparty_user_id":
                                                                              slack_user_info["user"]["id"],
                                                                          "thirdparty_team_id":
                                                                              slack_user_info["user"]["profile"][
                                                                                  "team"],
                                                                      }}, upsert=True)

                user = users_collection.find_one({"_id": user_id})

            # create threads for each public channel
            thread_type = "/new-thread"
            user_id = user["_id"]

            new_thread = await create_new_thread(user_id=user_id, tenant_id=tenant["tenant_id"], title=thread_title,
                                                 thread_type=thread_type)
            thread_id = new_thread["_id"]

            # fetch 100 messages per channel
            message_list = get_channel_messages(slack_client, channel_id, write_to_json=False, limit=100)
            # check if user exists else create new user
            for message in message_list:
                thirdparty_user_id = message['creator_id']
                message_user = await users_collection.find_one({"thirdparty_user_id": thirdparty_user_id})
                if not message_user:
                    slack_user_info = get_user_info(slack_client_for_user_info, thirdparty_user_id)

                    user_id = uuid.uuid4()
                    update_result = await users_collection.update_one({"_id": user_id},
                                                                      {"$set":
                                                                          {
                                                                              "name":
                                                                                  slack_user_info["user"]["profile"][
                                                                                      "real_name"],
                                                                              "picture":
                                                                                  slack_user_info["user"]["profile"][
                                                                                      "image_original"],
                                                                              "email":
                                                                                  slack_user_info["user"]["profile"][
                                                                                      "email"],
                                                                              "tenant_id": tenant["tenant_id"],
                                                                              "super_token_id": "",
                                                                              "thirdparty_provider": "slack",
                                                                              "thirdparty_user_id":
                                                                                  slack_user_info["user"]["id"],
                                                                              "thirdparty_team_id":
                                                                                  slack_user_info["user"]["profile"][
                                                                                      "team"],
                                                                          }}, upsert=True)

                    message_user = users_collection.find_one({"_id": user_id})

                if "reply_count" in message:
                    if message["reply_count"] > 0:
                        new_thread = await create_new_thread(
                            user_id=message_user["_id"],
                            tenant_id=tenant["tenant_id"],
                            title=f"Reply{thread_title}{random.randrange(200, 999)}",
                            thread_type=thread_type)

                        new_thread_title = new_thread["title"]

                        new_block = UpdateBlockModel(content=message["text"])
                        print(new_block)
                        await create_new_block(thread_id=new_thread["_id"], block=new_block, user_id=message_user["_id"])
                    else:
                        new_block = UpdateBlockModel(content=message["text"])
                        print(new_block)
                        await create_new_block(thread_id=thread_id, block=new_block, user_id=message_user["_id"])

                elif "parent_message_id" in message:
                    parent_message = {}
                    for msg in message_list:
                        if msg["message_id"] == message["parent_message_id"]:
                            parent_message = msg
                            break

                    parent_thread = await threads_collection.find_one({"title": new_thread_title})

                    thread_id = parent_thread["_id"]
                    new_block = UpdateBlockModel(content=message["text"])
                    print(new_block)
                    await create_new_block(thread_id=parent_thread["_id"], block=new_block, user_id=message_user["_id"])

    await shutdown_async_db_client()


if __name__ == "__main__":
    asyncio.run(main())
