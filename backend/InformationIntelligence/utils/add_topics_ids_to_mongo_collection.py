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
docs = db[collection_name].find().sort({'created_at': -1})
df = pd.DataFrame(list(docs)[::-1])

topic_to_id = {topic: str(uuid4())[:8] for topic in df['topic'].unique()}

df['main_thread_id'] = df['topic'].map(topic_to_id)


json_content = json.loads(df.to_json(orient='records'))
result = db['blocks'].insert_many(json_content)
print(len(result.inserted_ids))



# print(result.inserted_ids)