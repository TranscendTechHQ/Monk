
import json
import time
import random

import numpy as np

from pymilvus import MilvusClient
from pymilvus import DataType

from config import settings
from pymilvus import model
from utils.embedding import generate_embedding
#ef = model.DefaultEmbeddingFunction()


milvus_uri = settings.MILVUS_URI
token = settings.MILVUS_TOKEN
milvus_client = MilvusClient(uri=milvus_uri, token=token)
print(f"Connected to DB: {milvus_uri}")




def clean_collection(collection_name):
    milvus_client.drop_collection(collection_name)
    print("Success to drop the existing collection %s" % collection_name)
    
def create_thread_collection(collection_name, dim):
    
    check_collection = milvus_client.has_collection(collection_name)
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
    

def store_milvus_thread_embedding(collection_name,thread_id, tenant_id, thread_embedding):

    
    # insert data with customized ids
    row = {
        "thread_id": thread_id,
        "tenant_id": tenant_id,
        "thread_embedding": thread_embedding
    }

    milvus_client.insert(collection_name, row)

    print("Flushing...")
    start_flush = time.time()
    milvus_client.flush(collection_name)
    end_flush = time.time()
    print(f"Succeed in {round(end_flush - start_flush, 4)} seconds!")

def milvus_semantic_search(collection_name, query, limit=1):

    query_embedding = generate_embedding(query)
    
    results = milvus_client.search(collection_name=collection_name,   
        data=[query_embedding], 
        anns_field="thread_embedding", 
        #search_params = {"metric_type": "L2"},
        limit=limit,
        output_fields=["thread_id"]
    )
    return results




def main():
    dim = 1536
    collection_name = "threads"
    clean_collection(collection_name)
    create_thread_collection(collection_name, dim)
    
    thread_id = "sahi-jawab-90fe-44bf-90e2-b17e2871a2df"
    tenant_id = "T048F0ANS1M"
    thread_content = "Hey are you there? I am here. What is your name? Anthony Gonsalves"
    thread_embedding = generate_embedding(thread_content)
    store_milvus_thread_embedding(collection_name, thread_id, tenant_id, thread_content)


    thread_id = "ghanta-90fe-44bf-90e2-b17e2871a2df"
    tenant_id = "T048F0ANS1M"
    thread_content = "Lets party tonight"
    thread_embedding = generate_embedding(thread_content)
    store_milvus_thread_embedding(collection_name, thread_id, tenant_id, thread_embedding)

    thread_id = "doing-90fe-44bf-90e2-b17e2871a2df"
    tenant_id = "T048F0ANS1M"
    thread_content = "I will eat idli for lunch"
    thread_embedding = generate_embedding(thread_content)
    store_milvus_thread_embedding(collection_name, thread_id, tenant_id, thread_content)

    query = "What is the last name of the person?"
    results = milvus_semantic_search(collection_name, query, limit=1)
    print(results)
    
    
if __name__ == "__main__":
    main()



