from pymongo import MongoClient
from pprint import pprint
from config import settings
connection_string = settings.MONGO_CONNECTION_STRING

client = MongoClient(connection_string)
db = client.archive
collection = db.t4

print("Connected to MongoDB successfully!")
result = collection.find({'topic': None})
result = [res for res in result]
print(len(result), len(result) / 16978)
