from slack_sdk import WebClient
import asyncio
import json
import uuid

from routes.threads.models import UpdateBlockModel
from routes.threads.child_thread import create_new_thread
from routes.threads.routers import create_new_block
from routes.slack.models import ChannelModel, PublicChannelList

from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

from utils.db import startup_async_db_client, shutdown_async_db_client, asyncdb

overall_list = []


# count = 0

# Function to fetch and print replies to a message in a Slack channel
def fetch_and_print_replies(slack_client, channel_id, message_ts):
    try:
        # Call conversations.replies method using the WebClient
        result = slack_client.conversations_replies(channel=channel_id, ts=message_ts)

        message_list = []
        # Print the replies
        for reply in result['messages']:
            # global count
            # count += 1
            select_message_data = {}
            message_id = str(uuid.uuid4())
            # print(reply["text"])
            select_message_data["creator_id"] = reply['user']
            select_message_data["text"] = reply["text"]
            select_message_data['message_id'] = message_id

            # if 'attachments' in reply.keys():
            #    select_message_data["attachments"] = reply["attachments"]
            message_list.append(select_message_data)
            overall_list.append(select_message_data)
            # print(reply.keys())
            #print(reply["user"] + '---' + reply["text"])  # Adjust this based on the structure of your messages
        #print('\n\n')

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
        #channel_map = {}
        # Call conversations.list method using the WebClient
        #print("Fetching channel list...")
        result = slack_client.conversations_list()
        #print("Channel list fetched successfully.")
        # Print the list of channels
        for channel in result['channels']:
            #print(channel.keys())
            #print(channel['name'] + ' - ' + channel['id'])
            this_channel = ChannelModel(id=channel['id'], name=channel['name'])
            channel_list.append(this_channel)
            #print(channel['name'] + ' - ' + channel['id'])
        return PublicChannelList(public_channels=channel_list)
    except SlackApiError as e:
        print(f"Error fetching channel list: {e.response['error']}")
        

async def main():
    print("Starting db client...")
    await startup_async_db_client()
    print("DB client started successfully.")
    # print(db.mongodb_client.list_database_names())
    print("Fetching tenant...")
    doc = await asyncdb.tenants_collection.find_one({"tenant_name": "Monk"})
    if doc is None:
        print("No tenant found")
        return
    print("Tenant found successfully.")
    SLACK_USER_TOKEN = doc["user_token"]
    CHANNEL_ID = "C06SRQHNQDR"  # monk_zignite
    # Create a Slack client instance
    print("Creating Slack client...")
    slack_client = WebClient(token=SLACK_USER_TOKEN)
    print("Slack client created successfully.")
    channel_list = get_channel_list(slack_client)
    print(channel_list)
    thread_title = channel_list.public_channels[0].name
    channel_id = channel_list.public_channels[0].id
    print(f"Fetching messages from channel {channel_id}...")
    message_list = get_channel_messages(slack_client, channel_id, write_to_json=False, limit=1000)
    
    #print(message_block)
    thread_type = "/new-thread"
    user_id = "a4983b11-3465-4d00-9281-ec89048ce082" ##yogesh hardcoded. This should be fetched from slack and mapped to our own user id
    new_thread = await create_new_thread(user_id=user_id, title=thread_title, thread_type=thread_type)
    thread_id = new_thread["_id"]
    new_block = UpdateBlockModel(content=message_list[0]["text"])
    await create_new_block(thread_id=thread_id, block=new_block, user_id=user_id)
    
    #slack_collection = asyncdb.slack_collection()
    

    await shutdown_async_db_client()


if __name__ == "__main__":
    asyncio.run(main())
