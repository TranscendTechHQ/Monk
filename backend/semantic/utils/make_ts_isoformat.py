import datetime
import json
import pandas as pd
from uuid import uuid4
from pprint import pprint
from pymongo import MongoClient
from argparse import ArgumentParser
from config import settings
# from ..dedicated_server.main import MONGO_ARCHIVE_FIELDS

parser = ArgumentParser(description='to parse json file name')
# parser.add_argument('-f', '--json_filename')
parser.add_argument('-c', '--collection_name')

args = parser.parse_args()
# json_filename = args.json_filename
collection_name = args.collection_name

# df = pd.read_json(json_filename)

connection_string = settings.MONGO_CONNECTION_STRING
client = MongoClient(connection_string)
print("Connected to MongoDB successfully!")

db = client.archive
collection = db[collection_name]

# Update the created_at field with ISO format
for doc in collection.find():
    created_at = doc.get('created_at')
    if created_at:
        
        unix_timestamp_float = float(created_at)
        #print(unix_timestamp_float)
        # Create a datetime object from the unix timestamp
        created_at_datetime = datetime.datetime.fromtimestamp(unix_timestamp_float/1000)
        
        iso_created_at = created_at_datetime.isoformat()
        collection.update_one(
            {'_id': doc['_id']},
            {'$set': {'created_at': iso_created_at}}
        )



# print(result.inserted_ids)