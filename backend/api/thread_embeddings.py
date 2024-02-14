

from utils.embedding import generate_embedding
from config import settings
from pymongo import MongoClient, UpdateOne
from pymongo import ReplaceOne
import os


class App:
    pass

app = App()




def startup_db_client():
    app.mongodb_client = MongoClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]



def shutdown_db_client():
    app.mongodb_client.close()
    
def update_thread_creator() :
    collection = app.mongodb["threads"]
    requests = []
    for doc in collection.find({'title':{"$exists": True}}).limit(500):
        #print(doc['content'])
        
        requests.append(UpdateOne({'_id': doc['_id']}, {'$set': {'creator': "Yogesh K. Soni"}}))

    collection.bulk_write(requests)

def generate_thread_embedding():
    collection = app.mongodb["threads"]
    # Update the collection with the embeddings
    #requests = []
    dest_collection = app.mongodb["thread_embeddings"]
    user_collection = app.mongodb["users"]
    
    embeddings = { }
    for doc in collection.find({'title':{"$exists": True}}).limit(500):
        #print(doc['content'])
        
        title = doc['title']
        text = "This is the content of the thread with title " + title + ". "
        threadType = doc['type']
        text += "The type of the thread is " + threadType + ". "
        createdAt = doc['created_date']
        text += "The thread was created on " + createdAt + ". "
        creator = doc['creator']
        text += "The creator of the thread is " + creator + ". "
        userDoc = user_collection.find_one({'user_name': creator})
        email = userDoc['email']
        text += "The email of the creator is " + email + ". "
        #print(text)
        embeddings['title'] = title
        
        #return
        
        blocks = doc['content']
        
        for block in blocks:
            #print(block['content'])
            text += block['content'] + " "
        #print (text)
        
        embeddings['embedding'] = generate_embedding(text)
        dest_collection.update_one({'_id': doc['_id']},
                                   {'$set':embeddings}, upsert=True)
        
        #requests.append(ReplaceOne({'_id': doc['_id']}, doc))

    #collection.bulk_write(requests)

def move_thread_embedding():
    collection = app.mongodb["threads"]
    dest_collection = app.mongodb["thread_embeddings"]
    embeddings = { }
    requests = []
    for doc in collection.find({'title':{"$exists": True}}).limit(500):
        title = doc['title']
        if 'thread_embedding' in doc:
            embeddings[title] = doc["thread_embedding"]
            #dest_collection.insert_one(embeddings)
            collection.update_one({'_id': doc['_id']}, {'$unset': {'thread_embedding': 1}}, upsert=True)
        #requests.append(UpdateOne({'_id': doc['_id']}, {'$set': {'thread_embedding': embeddings}}))
        #requests.append(ReplaceOne({'_id': doc['_id']}, doc))

    #collection.bulk_write(requests)
 
def main() :
    startup_db_client()
    #update_thread_creator()
    #generate_embedding_new_api(
    #    "The food was delicious and the waiter was very friendly.")
    #print(embedding)
    #generate_thread_embedding()
    #move_thread_embedding()
    shutdown_db_client()

main()