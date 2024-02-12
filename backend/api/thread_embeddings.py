import openai
from config import settings
from pymongo import MongoClient, UpdateOne
from pymongo import ReplaceOne

class App:
    pass

app = App()

# Setting up the deployment name
deployment_name = settings.AZURE_OPENAI_EMB_DEPLOYMENT

# This is set to `azure`
openai.api_type = "azure"

# The API key for your Azure OpenAI resource.
openai.api_key = settings.AZURE_OPENAI_KEY

# The base URL for your Azure OpenAI resource. e.g. "https://<your resource name>.openai.azure.com"
openai.api_base = settings.AZURE_OPENAI_ENDPOINT

# Currently OPENAI API have the following versions available: 2022-12-01
openai.api_version = settings.API_VERSION

#engine=os.getenv('DEPLOYMENT_NAME'),
#embeddings = openai.embeddings.create(model=deployment_name, input="The food was delicious and the waiter...")

# Number of embeddings    
#len(embeddings)

# Print embeddings
#print(embeddings.data[0].embedding)

def generate_embedding(text):
    #text = text.replace("\n", " ")
    result =  openai.embeddings.create(
                                   input = [text], 
                                   model=deployment_name)
    embeddings = result.data[0].embedding
    #print(embeddings)
    return embeddings

def startup_db_client():
    app.mongodb_client = MongoClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]



def shutdown_db_client():
    app.mongodb_client.close()
    

def generate_thread_embedding():
    collection = app.mongodb["threads"]
    # Update the collection with the embeddings
    requests = []
    text = ""
    for doc in collection.find({'title':{"$exists": True}}).limit(500):
        #print(doc['content'])
        blocks = doc['content']
        for block in blocks:
            #print(block['content'])
            text += block['content'] + " "
        #print (text)
        doc["thread_embedding"] = generate_embedding(text)
        requests.append(ReplaceOne({'_id': doc['_id']}, doc))

    collection.bulk_write(requests)

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
            collection.update_one({'_id': doc['_id']}, {'$unset': {'thread_embedding': 1}})
        #requests.append(UpdateOne({'_id': doc['_id']}, {'$set': {'thread_embedding': embeddings}}))
        #requests.append(ReplaceOne({'_id': doc['_id']}, doc))

    #collection.bulk_write(requests)
 
def main():
    startup_db_client()
    #generate_thread_embedding()
    move_thread_embedding()
    shutdown_db_client()

main()