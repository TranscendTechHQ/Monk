import datetime
import pprint
from pymongo import MongoClient
import asyncio
import json
import uuid

from config import settings
from routes.threads.models import CreateBlockModel, UpdateBlockModel
from routes.threads.child_thread import create_child_thread, create_new_thread
from routes.threads.routers import create_new_block
from routes.slack.models import ChannelModel, PublicChannelList

from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

from utils.db import startup_async_db_client, shutdown_async_db_client, asyncdb, update_block_child_id

overall_list = []



def convert_unix_timestamp_to_iso_string(unix_timestamp):
    # Convert the unix_timestamp from a string to a float
    unix_timestamp_float = float(unix_timestamp)
    
    # Create a datetime object from the unix timestamp
    datetime_obj = datetime.datetime.fromtimestamp(unix_timestamp_float)
    
    # Convert the datetime object to an ISO-formatted string
    return datetime_obj.isoformat()

# Function to fetch and print replies to a message in a Slack channel
def fetch_and_print_replies(slack_client, channel_id, message_ts):
    try:
        

        # Call conversations.replies method using the WebClient
        result = slack_client.conversations_replies(channel=channel_id, ts=message_ts)

        message_list = []
        
        parent_message_id = ""
        
        # Print the replies
        for reply in result['messages']:
            
            reply_count = 0
            if "subtype" in reply and reply["subtype"] == "bot_message":
                continue

            if "reply_count" in reply and reply["reply_count"] > 0:
                reply_count = reply["reply_count"]
            
            # global count
            # count += 1
            select_message_data = {}
            if 'client_msg_id' in reply.keys():
                message_id = reply['client_msg_id']
            else:
                message_id = str(uuid.uuid4())
            if 'ts' in reply.keys():
                message_ts = reply['ts']
            if "reply_count" in reply and reply["reply_count"] > 0:
                print(f"reply_count: {reply_count}")
                parent_message_id = message_id
                select_message_data["reply_count"] = reply_count
                select_message_data["parent_message_id"] = parent_message_id
                if 'thread_ts' in reply.keys():
                    select_message_data["child_thread_created_at"] = reply['thread_ts']
            
            select_message_data["creator_id"] = reply['user']
            select_message_data["text"] = reply["text"]
            select_message_data['message_id'] = message_id
            select_message_data['created_at'] = message_ts
            select_message_data["reply"] = True if "parent_user_id" in reply else False
            if "parent_user_id" in reply:
                select_message_data["parent_message_id"] = parent_message_id
                select_message_data["parent_user_id"] = reply["parent_user_id"]

            if not 'subtype' in reply.keys():
            # if 'attachments' in reply.keys():
            #    select_message_data["attachments"] = reply["attachments"]
                message_list.append(select_message_data)
                overall_list.append(select_message_data)
                print(reply.keys())
                thread_ts = ""
                client_msg_id = ""
            
                if 'thread_ts' in reply.keys():
                    thread_ts = reply['thread_ts']
                if 'client_msg_id' in reply.keys():
                    client_msg_id = reply['client_msg_id']
                parent_user_id = ""
                if 'parent_user_id' in reply.keys():
                    parent_user_id = reply['parent_user_id']
                print(f"{reply['user']} + --- + {reply['text']} reply_count: {reply_count} parent_user_id: {parent_user_id} , thread_ts {thread_ts} client_msg_id:{client_msg_id}")  # Adjust this based on the structure of your messages
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
                #print(f"{message['ts']} - {message['user']}: {message['text']}")
                
                fetch_and_print_replies(slack_client, channel_id, message['ts'])
                print('\n\n')
            # Specify the file path to write the array

            overall_messages = {"messages": overall_list}

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
            #print(channel.keys())
           
            # print(channel['name'] + ' - ' + channel['id'])
            this_channel = ChannelModel(id=channel['id'], 
                                        name=channel['name'], 
                                        creator=channel["creator"], 
                                        created_at=convert_unix_timestamp_to_iso_string(channel["created"]))
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

async def update_third_party_user_info(third_party_id, tenant_id, slack_client_for_user_info):

    users_collection = asyncdb.users_collection
    user = await users_collection.find_one({"thirdparty_user_id": third_party_id})
    if not user:
        slack_user_info = get_user_info(slack_client_for_user_info, third_party_id)
        email = 'unknown email'
        if 'email'  in slack_user_info["user"]["profile"]:
            email = slack_user_info["user"]["profile"]["email"]
        user_id = str(uuid.uuid4())
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
                                                                        email,
                                                                    "tenant_id": tenant_id,
                                                                    "super_token_id": "",
                                                                    "thirdparty_provider": "slack",
                                                                    "thirdparty_user_id":
                                                                        slack_user_info["user"]["id"],
                                                                    "thirdparty_team_id":
                                                                        slack_user_info["user"]["profile"][
                                                                            "team"],
                                                                }}, upsert=True)

        user = await users_collection.find_one({"_id": user_id})
    return user

async def cleanup_slack_data():
    # cleanup all slack data
    
    threads = await asyncdb.threads_collection.find({"type": "/new-slack-thread"}).to_list(length=None)
    for thread in threads:
        thread_id = thread["_id"]
        await asyncdb.blocks_collection.delete_many({"main_thread_id": thread_id})
        await asyncdb.blocks_collection.delete_many({"child_thread_id": thread_id})
    await asyncdb.threads_collection.delete_many({"type": "/new-slack-thread"})
    #await asyncdb.users_collection.delete_many({"thirdparty_provider": "slack"})
    raise ValueError("cleanup slack data")

async def main():
    print("Starting db client...")
    await startup_async_db_client()
    #await cleanup_slack_data()
    
    print("DB client started successfully.")
    # print(db.mongodb_client.list_database_names())
    print("Fetching tenant...")
    tenants_collection = asyncdb.tenants_collection
    threads_collection = asyncdb.threads_collection
    tenants = await tenants_collection.find({}).to_list(length=None)

    for tenant in tenants:
        if "bot_user_id" not in tenant:
            continue

        tenant_id = tenant["tenant_id"]
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
        #print(channel_list)
        for channel in channel_list.public_channels:
            overall_list.clear()
            thread_title = channel.name
            if channel.name != "ailearning":
                continue
            channel_id = channel.id
            print(f"Fetching messages from channel {channel_id}...")
            # fetch max 10000 messages per channel
            message_list = get_channel_messages(slack_client, channel_id, write_to_json=False, limit=10000)
            #continue
            
            
            # get or create user with slack user ID who created the channel
            user = await update_third_party_user_info(channel.creator, tenant_id, slack_client_for_user_info)

            # create threads for each public channel
            thread_type = "/new-slack-thread"
            user_id = user["_id"]

            new_thread = await create_new_thread(user_id=user_id, tenant_id=tenant_id, title=thread_title,
                                                 thread_type=thread_type, created_at=channel.created_at)
            main_thread_id = new_thread["_id"]
            

            current_slack_thread_id=""
            current_thread_id = {}
            # check if user exists else create new user
            for i, message in enumerate(message_list):
                thirdparty_user_id = message['creator_id']
                message_user = await update_third_party_user_info(thirdparty_user_id, tenant_id, slack_client_for_user_info)
                block_thread_id = main_thread_id # this is default unless there are child threads
                
                if "reply" in message and message["reply"]:
                    #this means this is a reply message
                    if not 'parent_message_id' in message:
                        raise ValueError("Parent message id not found")
                    if not message["parent_message_id"] in current_thread_id:
                        raise ValueError("Parent thread id not found")
                    block_thread_id = current_thread_id[message["parent_message_id"]]

                # create a new block either in the main thread or the child thread
                new_block = CreateBlockModel(
                content=message["text"], main_thread_id=block_thread_id)
                    
                created_block = await create_new_block(block=new_block, 
                                                       user_id=message_user["_id"], 
                                                       tenant_id=tenant_id, 
                                                       id=message['message_id'], 
                                                       created_at=convert_unix_timestamp_to_iso_string(message['created_at']))   
                
                if "reply_count" in message:
                    #this means this is a parent message
                    
                    new_parent_block_id = created_block.id
                    current_slack_thread_id=message['parent_message_id']
                    new_thread_title = f"Reply{thread_title}{new_parent_block_id[0:4].replace('-', '')}"
                    #  we need to get the user who created the next message
                    if (i+1) >= len(message_list):
                        raise ValueError("Next message not found, was a reply deleted?")
                    thirdparty_user_id = message_list[i+1]['creator_id']
                    new_thread_creator = await update_third_party_user_info(thirdparty_user_id, tenant_id, slack_client_for_user_info)
                    new_thread_creator_id = new_thread_creator["_id"]
                    child_thread_created_at = convert_unix_timestamp_to_iso_string(message['child_thread_created_at'])
                    #start a new thread
                    child_thread = await create_child_thread(thread_collection=threads_collection,
                                                parent_block_id=new_parent_block_id,
                                                main_thread_id=main_thread_id,
                                                thread_title=new_thread_title,
                                                thread_type=thread_type,
                                                user_id=new_thread_creator_id,
                                                tenant_id=tenant_id,
                                                parentBlock=created_block,
                                                created_at=child_thread_created_at)
                    current_thread_id[current_slack_thread_id] = child_thread['_id']
                    

    await shutdown_async_db_client()


if __name__ == "__main__":
    asyncio.run(main())
