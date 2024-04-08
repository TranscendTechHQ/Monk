import asyncio
import pprint

from pymongo import MongoClient
from config import settings
from utils.headline import generate_headline, generate_single_thread_headline

text = """

Despite its title this isn't meant to be the best essay. My goal here is to figure out what the best essay would be like.

It would be well-written, but you can write well about any topic. What made it special would be what it was about.

Obviously some topics would be better than others. It probably wouldn't be about this year's lipstick colors. But it wouldn't be vaporous talk about elevated themes either. A good essay has to be surprising. It has to tell people something they don't already know.

The best essay would be on the most important topic you could tell people something surprising about.

That may sound obvious, but it has some unexpected consequences. One is that science enters the picture like an elephant stepping into a rowboat. For example, Darwin first described the idea of natural selection in an essay written in 1844. [1] Talk about an important topic you could tell people something surprising about. If that's the test of a great essay, this was surely the best one written in 1844. And indeed, the best possible essay at any given time would usually be one describing the most important scientific or technological discovery it was possible to make. [2]

Another unexpected consequence: I imagined when I started writing this that the best essay would be fairly timeless — that the best essay you could write in 1844 would be much the same as the best one you could write now. But in fact the opposite seems to be true. It might be true that the best painting would be timeless in this sense. But it wouldn't be impressive to write an essay introducing natural selection now. The best essay now would be one describing a great discovery we didn't yet know about.

If the question of how to write the best possible essay reduces to the question of how to make great discoveries, then I started with the wrong question. Perhaps what this exercise shows is that we shouldn't waste our time writing essays but instead focus on making discoveries in some specific domain. But I'm interested in essays and what can be done with them, so I want to see if there's some other question I could have asked.

There is, and on the face of it, it seems almost identical to the one I started with. Instead of asking what would the best essay be? I should have asked how do you write essays well? Though these seem only phrasing apart, their answers diverge. The answer to the first question, as we've seen, isn't really about essay writing. The second question forces it to be.

Writing essays, at its best, is a way of discovering ideas. How do you do that well? How do you discover by writing?

An essay should ordinarily start with what I'm going to call a question, though I mean this in a very general sense: it doesn't have to be a question grammatically, just something that acts like one in the sense that it spurs some response.

How do you get this initial question? It probably won't work to choose some important-sounding topic at random and go at it. Professional traders won't even trade unless they have what they call an edge — a convincing story about why in some class of trades they'll win more than they lose. Similarly, you shouldn't attack a topic unless you have a way in — some new insight about it or way of approaching it.

You don't need to have a complete thesis; you just need some kind of gap you can explore. In fact, merely having questions about something other people take for granted can be edge enough.

If you come across a question that's sufficiently puzzling, it could be worth exploring even if it doesn't seem very momentous. Many an important discovery has been made by pulling on a thread that seemed insignificant at first. How can they all be finches?
"""

class App:
    pass

app = App()




def startup_db_client():
    app.mongodb_client = MongoClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]



def shutdown_db_client():
    app.mongodb_client.close()
    
    


def generate_all_thread_headlines(num_thread_limit, useAI=False):
    thread_collection = app.mongodb["threads"]
    headline_collection = app.mongodb["thread_headlines"]
    for doc in thread_collection.find({'title':{"$exists": True}}).limit(num_thread_limit):
        content = doc['content']
        #if len(content) < 1:
        #    continue
        generate_single_thread_headline(doc, 
                                        headline_collection,
                                        useAI=useAI)

        #pprint.pprint(headline['text'])

def cleanup_zombie_threads():
    thread_collection = app.mongodb["threads"]
    headline_collection = app.mongodb["thread_headlines"]
    metadata_collection = app.mongodb["threads_metadata"]
    
    for doc in thread_collection.find({}):
        if len(doc["content"]) < 2:
            print(f"Deleting thread {doc['_id']}, {doc['title']}")
            thread_collection.delete_one({'_id': doc['_id']})
            headline_collection.delete_one({'_id': doc['_id']})
            metadata_collection.delete_one({'_id': doc['_id']})
            #print(f"Deleted thread {doc['_id']}")
    for doc in metadata_collection.find({}):
        if doc['_id'] not in [x['_id'] for x in thread_collection.find({})]:
            print(f"Deleting metadata {doc['_id']}, {doc['_id']}")
            metadata_collection.delete_one({'_id': doc['_id']})
            #print(f"Deleted metadata {doc['_id']}")

def detect_zombie_threads():
    thread_collection = app.mongodb["threads"]
    metadata_collection = app.mongodb["threads_metadata"]
    for doc in thread_collection.find({}):
        if doc["_id"] not in [x['_id'] for x in metadata_collection.find({})]:
            print(f"Zombie thread {doc['_id']}, {doc['title']}")
            thread_collection.delete_one({'_id': doc['_id']})
            #print(f"Deleted thread {doc['_id']}")
    
    for doc in metadata_collection.find({}):
        if doc['_id'] not in [x['_id'] for x in thread_collection.find({})]:
            print(f"Zombie thread {doc['_id']}, {doc['_id']}")
            metadata_collection.delete_one({'_id': doc['_id']})
            #print(f"Deleted metadata {doc['_id']}")
async def main() :
    startup_db_client()
    #result =  generate_headline(text)
    #pprint.pprint(result)
    generate_all_thread_headlines(500, useAI=False)
    #detect_zombie_threads()
    #cleanup_zombie_threads()
    shutdown_db_client()
    
    
if __name__ == "__main__":
    asyncio.run(main())