import asyncio
import pprint

from pymongo import MongoClient
from config import settings
from utils.headline import generate_headline
import os 


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




def startup_db_client():
    app.mongodb_client = MongoClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]



def shutdown_db_client():
    app.mongodb_client.close()
    
    
def generate_single_thread_headline(thread_doc):   
    blocks = thread_doc['content']
    text = ""
    for block in blocks:
        #print(block['content'])
        text += block['content'] + " " 
    headline = generate_headline(text)
    return headline

def generate_all_thread_headlines(num_thread_limit):
    thread_collection = app.mongodb["threads"]
    headline_collection = app.mongodb["thread_headlines"]
    for doc in thread_collection.find({'title':{"$exists": True}}).limit(num_thread_limit):
        headline = generate_single_thread_headline(doc)
        title = doc['title']
        headline_collection.update_one({'_id': doc['_id']}, 
                                      {'$set': {'headline': headline['text'], 
                                                'title': title}}, upsert=True)
        pprint.pprint(headline['text'])

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
        "content": user_text
        }
    ],
    temperature=1,
    max_tokens=256,
    top_p=1
    )
    return response.choices[0].message.content

   
async def main() :
    startup_db_client()
    assistant_text = openai_completion(system_text, user_text)
    print(assistant_text)
    
    shutdown_db_client()
    
    
    
if __name__ == "__main__":
    asyncio.run(main())