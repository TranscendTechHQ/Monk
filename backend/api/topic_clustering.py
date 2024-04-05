import asyncio
import json
import pprint

from pymongo import MongoClient
from config import settings
from utils.headline import generate_headline
import os 
import re

from openai import OpenAI


system_text = """

You are an expert linguist, specializing in clustering messages into topics.

When you are presented a list of messages, you go through them and group messages that you think belong to a common topic. (It's a good idea to double check if the messages are logically related to each other)

Below is an example of how the input looks like.
```
- <message_id> : message_content
- <message_id>: message_content
```
You should ignore the <message_id> etc while sorting the messages into topics. Just focus on the message_content

Then you print the message_id of clustered messages in json format like below.

```
{
"topics":
[
  {"topic": "topic name 1",
   "message_ids:
   [
       "message_id",
        "message_id",
        "message_id"
    ]
 },

]
}


```
"""
user_text = """
- <id01>:hey how is the weather looking today?
- <id02>:there is forecast of some rain
- <id03>:do you plan to play tennis today?
- <id04>:weather app shows 70% chance of rain
- <id05>:yeah i can play.
- <id06>:but we have to run if it rains.
- <id07>:Do you like to cook you own food?
- <id08>:No i don't like cooking.
- <id09>:but I still cook, because it is healthier.
- <id10>:I believe in the weather app. It has been making some good predictions off-late.
- <id11>:I'll cook lasagna for you after we finish playing.
"""


os.environ["OPEN_API_GPT_MODEL"] = settings.OPEN_API_GPT_MODEL
os.environ["OPENAI_API_KEY"] = settings.OPENAI_API_KEY
os.environ["OPENAI_API_ENDPOINT"] = settings.OPENAI_API_ENDPOINT
os.environ["OPENAI_API_VERSION"] = settings.OPENAI_API_VERSION

class App:
    pass

app = App()




def remove_triple_quote_blocks(text):
    pattern = r'```(.*?)```'
    cleaned_text = re.sub(pattern, '', text, flags=re.DOTALL)
    return cleaned_text




def startup_db_client():
    app.mongodb_client = MongoClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]



def shutdown_db_client():
    app.mongodb_client.close()
    


def openai_completion(system_text, user_text):
    client = OpenAI()

    response = client.chat.completions.create(
    model=settings.OPEN_API_GPT_MODEL,
    messages=[
        {
        "role": "system",
        "content": system_text
        },
        {
        "role": "user",
        "content": user_text[:16385]  # Limiting the user text to 16385 characters because of openai limit
        }
    ],
    temperature=1,
    max_tokens=4096,
    top_p=1
    )
    return response.choices[0].message.content

def messages_to_topics():
    topics = []
    topic = {}
    topic["topic"] = "topic name 1"
    topic["message_ids"] = []
     # File path to write the JSON data
    file_path = "messages.json"  # Replace with your desired file name
    data = {}
    user_text = ""
    # Write the dictionary as JSON to the file
    with open(file_path, "r") as infile:
        data = json.load(infile)
    messages = data["messages"]
    for message in messages:
        cleaned_text = remove_triple_quote_blocks(message["text"])
        user_text= user_text + "- " + message["message_id"] +":" + cleaned_text +"\n"
    #print(user_text)
    return user_text

def print_clustered_messages():
    topics = []
    
     # File path to write the JSON data
    message_file_path = "messages.json"  # Replace with your desired file name
    data = {}
    assistant_file_path = "assistant_text.json"
    with open(assistant_file_path, "r") as assistant_file, open(message_file_path, "r") as infile:
        file_data = json.load(assistant_file)
        #print(file_data.keys())
        topics = file_data["topics"]
        file_data = json.load(infile)
        messages = file_data["messages"]
        for topic in topics:
            print(topic["topic"])
            for msgid in topic["message_ids"]:
                for message in messages:
                    if message["message_id"] == msgid:
                        print(message["text"])
                        break
            #print(topic["message_ids"])
            print("\n\n")
    
        
  

async def main() :
    startup_db_client()

    sample_text = """
    This is a sample text.
    ```
    This is a block of text inside triple quotes.
    ```
    Another paragraph of text.
    ```
    Another block of text inside triple quotes.
    ```
    """

    #cleaned_text = remove_triple_quote_blocks(sample_text)
    #print(cleaned_text)
    user_text = messages_to_topics()
    assistant_text = openai_completion(system_text, user_text)
    with open("assistant_text.json", "w") as json_file:
        json_file.write(assistant_text)
    #print(assistant_text)
    print_clustered_messages()
    shutdown_db_client()
    
    
    
if __name__ == "__main__":
    asyncio.run(main())