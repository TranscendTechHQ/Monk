import json
import pandas as pd
from uuid import uuid4
from pprint import pprint
from pymongo import MongoClient
from argparse import ArgumentParser
from config import settings
# from ..dedicated_server.main import MONGO_ARCHIVE_FIELDS

parser = ArgumentParser(description='to parse json file name')
parser.add_argument('-f', '--json_filename')
parser.add_argument('-c', '--collection_name')

args = parser.parse_args()
json_filename = args.json_filename
collection_name = args.collection_name

df = pd.read_json(json_filename)
df['_id'] = df.apply(lambda _: str(uuid4()), axis=1)
json_content = json.loads(df[['_id', 'content', 'created_at', 'creator_id']].to_json(orient='records'))


connection_string = settings.MONGO_CONNECTION_STRING
client = MongoClient(connection_string)
print("Connected to MongoDB successfully!")

db = client.archive
result = db[collection_name].insert_many(json_content)

print(result.inserted_ids)