
import json
import time
import random

import numpy as np

from pymilvus import MilvusClient
from pymilvus import DataType

from config import settings
from pymilvus import model
from embedding import generate_embedding
ef = model.DefaultEmbeddingFunction()


milvus_uri = settings.MILVUS_URI
token = settings.MILVUS_TOKEN
milvus_client = MilvusClient(uri=milvus_uri, token=token)
print(f"Connected to DB: {milvus_uri}")


# Check if the collection exists
collection_name = "threads"
milvus_client.drop_collection(collection_name)
print("Success to drop the existing collection %s" % collection_name)
check_collection = milvus_client.has_collection(collection_name)

dim = 1536 
if not check_collection:
    print("Preparing schema")
    schema = milvus_client.create_schema()
    schema.add_field("thread_id", DataType.VARCHAR, is_primary=True, description="primary thread id", max_length=65535)
    schema.add_field("tenant_id", DataType.VARCHAR, description="Tenant id", max_length=65535)
    schema.add_field("thread_embedding", DataType.FLOAT_VECTOR, dim=dim, description="thread embedding")
    print("Preparing index parameters with default AUTOINDEX")
    index_params = milvus_client.prepare_index_params()
    index_params.add_index("thread_embedding", metric_type="L2")

    print(f"Creating example collection: {collection_name}")
    # create collection with the above schema and index parameters, and then load automatically
    milvus_client.create_collection(collection_name, dimension=dim, schema=schema, index_params=index_params)
    collection_property = milvus_client.describe_collection(collection_name)
    print("Show collection details: %s" % collection_property)


thread_id = "12262259-90fe-44bf-90e2-b17e2871a2df"
tenant_id = "T048F0ANS1M"
thread_data = "Hey are you there? I am here. What is your name? Anthony Gonsalves"
#thread_embedding = ef([thread_data])
#thread_embedding_np = np.array(thread_embedding, dtype=np.float32)
thread_embedding = generate_embedding(thread_data)


# insert data with customized ids
row = {
    "thread_id": "12262259-90fe-44bf-90e2-b17e2871a2df",
    "tenant_id": "T048F0ANS1M",
    "thread_embedding": thread_embedding
}

milvus_client.insert(collection_name, row)

thread_id = "woh-wala"
tenant_id = "T048F0ANS1M"
thread_data = "kaka ki kaki ko kaaku ne kaaka"
#thread_embedding = ef([thread_data])
#thread_embedding_np = np.array(thread_embedding, dtype=np.float32)
thread_embedding = generate_embedding(thread_data)


# insert data with customized ids
row = {
    "thread_id": "12262259-90fe-44bf-90e2-b17e2871a2df",
    "tenant_id": "T048F0ANS1M",
    "thread_embedding": thread_embedding
}

milvus_client.insert(collection_name, row)
print("Flushing...")
start_flush = time.time()
milvus_client.flush(collection_name)
end_flush = time.time()
print(f"Succeed in {round(end_flush - start_flush, 4)} seconds!")

# search
nq = 1

topk = 1

query = "What is the last name of the person?"
#query_embedding = ef([query])
#query_embedding_np = np.array(query_embedding, dtype=np.float32).tolist()
query_embedding = generate_embedding(query)
#print("HEY")
#print(query_embedding)
#print("HEY")
#exit()
#search_params = {"metric_type": "L2",  "params": {"level": 2}}
#search_params = { "metric_type": "L2","nprobe": 10, "level": 2}

results = milvus_client.search(collection_name=collection_name,   
    data=[query_embedding], 
    anns_field="thread_embedding", 
    #search_params = {"metric_type": "L2"},
    limit=1,
    output_fields=["thread_id"]
)
# Convert the output to a formatted JSON string
result = json.dumps(results, indent=4)
print(result)



