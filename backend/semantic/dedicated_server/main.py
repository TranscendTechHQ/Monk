from fastapi.security import APIKeyHeader
import pathlib
import asyncio
import io
import json
import sys
import pandas as pd
from textwrap import wrap
from tqdm import tqdm
from typing import Union
from fastapi.responses import StreamingResponse
from fastapi import FastAPI, File, Form, UploadFile, HTTPException, Security, status, Query
from preprocessing import (
    get_batches, get_topics_messages_from_mongo, format_topics_batches_into_chats, process_batches_and_get_llm_outputs, split_topic_messages_into_batches,
    add_unique_ids_and_topic_column, get_mistral_response, get_streaming_response_init, parse_jsons_from_llm_outputs, parse_topics_ids_from_prompt,
    format_topics_batch_into_chat_for_likeliness, call_llm, parse_text_in_tripple_quotes, get_topics_summaries_from_mongo, parse_json
)
from pprint import pprint
from pymongo import MongoClient, DESCENDING
import uuid
import os
import traceback
import requests
# from transformers import PreTrainedTokenizerFast
# tokenizer = PreTrainedTokenizerFast(tokenizer_file="tokenizer.json")
# tokenizer = AutoTokenizer.from_pretrained("mistralai/Mistral-7B-Instruct-v0.3")
from config import settings



# os.environ["RUNPOD_OR_ENDPOINT"] = "endpoint"
# DIRECT_NAMING_MAPPING = {
#     # 'id': '_id',
#     'message.1': 'content',
#     'time': 'created_at',
#     'user': 'creator_id',
#     # 'topic': 'topic'
# }
# INVERSE_NAMING_MAPPING = {
#     'content': 'message.1',
#     'created_at': 'time',
#     'creator_id': 'user'
# }
BATCH_SIZE = 16
OVERLAP = 8

CLOUDFLARE_ACCOUNT_ID = settings.CLOUDFLARE_ACCOUNT_ID
CLOUDFLARE_AUTH_TOKEN = settings.CLOUDFLARE_AUTH_TOKEN
MISTRAL_API_KEY = settings.MISTRAL_API_KEY




connection_string = settings.MONGO_CONNECTION_STRING
client = MongoClient(connection_string)
#print(f"DB_NAME {settings.DB_NAME}")
archive_db = client[settings.DB_NAME]


api_keys = [
    settings.RELEVANCE_API_KEY
]
dir_names = {
    settings.RELEVANCE_API_KEY: "user1"
}

app = FastAPI()
api_key_header = APIKeyHeader(name="X-API-Key")

print("\n\nApp is ready\n")



def get_api_key(api_key_header: str = Security(api_key_header)) -> str:
    if api_key_header in api_keys:
        return api_key_header
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or missing API Key",
    )


def read_from_json(file_contents):
    stream_file_contents = io.BytesIO(file_contents)
    return pd.read_json(stream_file_contents)


def read_from_mongo(archive_db, collection_name, n_records):
    archive = archive_db[collection_name].find().sort({'created_at': -1}).limit(n_records)
    return pd.DataFrame(list(archive)[::-1])

def read_from_mongo_for_maybe_existing_chat(current_df, chat_name, archive_db, write_to_mongo):
    global BATCH_SIZE
    if chat_name in archive_db.list_collection_names():
        messages_for_consideration = archive_db[chat_name].count_documents({}) % BATCH_SIZE
        archive = archive_db[chat_name].find().sort({'created_at': -1}).limit(messages_for_consideration)
        

        df_old = pd.DataFrame(list(archive)[::-1])
        ids_to_delete = df_old['_id'].tolist()
        # df_old.rename(columns=INVERSE_NAMING_MAPPING, inplace=True)
    
        current_df = pd.concat([df_old, current_df], axis=0).reset_index(drop=True)
        
        if write_to_mongo:
            deleted = archive_db[chat_name].delete_many({'_id': {'$in': ids_to_delete}})
            print(deleted.deleted_count)
        
    return current_df



    
    
    
    
    




print("\n\nApp is ready\n")


@app.post("/generate_topics/")
async def generate_topics(
    api_key: str = Security(get_api_key),
    read_from: str = Query("json", enum=["json", "mongo"]),
    input_json_if_needed: UploadFile = File(None), 
    collection_name_to_read_from_mongo_if_needed: str = Form(None),
    n_records_to_read_from_mongo_if_needed: int = Form(None),
    model_type: str = Query("runpod", enum=["runpod", "cloudflare_endpoint"]), 
    write_to_mongo: bool = Query(False),
    chat_name_aka_collection_name_to_write_to_mongo_if_needed: str = Form(None)
    ):
    print(write_to_mongo)
    print()
    print('-' * 100)
    global archive_db

    dir_name = dir_names[api_key]
    dir_path = pathlib.Path(dir_name)
    dir_path.mkdir(parents=True, exist_ok=True)

    
    try:
        
        if read_from == 'json':
            print('Reading from json')
            file_contents = await input_json_if_needed.read()
            current_df = read_from_json(file_contents)
            current_df = read_from_mongo_for_maybe_existing_chat(current_df, chat_name_aka_collection_name_to_write_to_mongo_if_needed, archive_db, write_to_mongo)
        elif read_from == 'mongo':
            print('Reading from mongo')
            current_df = read_from_mongo(archive_db, collection_name_to_read_from_mongo_if_needed, n_records_to_read_from_mongo_if_needed)
            print(current_df)

        current_df = add_unique_ids_and_topic_column(current_df)
        batches = get_batches(current_df, batch_size=BATCH_SIZE, overlap=OVERLAP, model_type=model_type)
        
        if model_type == 'runpod':
            return StreamingResponse(
                get_streaming_response_init(batches, current_df, write_to_mongo, archive_db, chat_name_aka_collection_name_to_write_to_mongo_if_needed),
                media_type="text/json",
                headers={"Content-Disposition": f"attachment; filename=data.json"}
            )
        elif model_type == 'cloudflare_endpoint':
            response = get_mistral_response(batches, current_df, write_to_mongo, archive_db, chat_name_aka_collection_name_to_write_to_mongo_if_needed)
            return response
        
        
        
        
        if False:
            current_df.to_csv(dir_path / 'df.csv', index=False)

    except Exception as e:
        return {"success": False, "error": str(e), 'traceback': f"{traceback.format_exc()}"}


def classify_relevance_method(user_profile_and_preferences, mongo_name_of_collection_with_topics, topics_ids, model_name):
    global archive_db, tokenizer
    
    
    max_tokens_for_topics_batch = 3_000
    #print(mongo_name_of_collection_with_topics)
    topic_messages = get_topics_messages_from_mongo(archive_db[mongo_name_of_collection_with_topics], topics_ids)
    print(f"Number of topics: {len(topic_messages)}")
    topics_batches = split_topic_messages_into_batches(topic_messages, max_tokens_for_topics_batch)
    input_remaining_batches = format_topics_batches_into_chats(topics_batches, user_profile_and_preferences)
    
    final_answer_json = {}
    num_tries = 0

    while input_remaining_batches:

        if num_tries >= 3:
            print('Unfortunately, not all batches were processed correclty.\nBelow are bad topics')
            for failed_batch, failed_llm_output in zip(input_remaining_batches, failed_llm_outputs):
                print(f"Topics ids from the input batch:\n{parse_topics_ids_from_prompt(failed_batch[-1]['content'])}")
                # print(f"The input batch:\n{failed_batch[-1]['content']}")
                print(f'LLM output:\n{failed_llm_output}')
                print('-' * 100)
            break
        num_tries += 1
        

        llm_outputs = process_batches_and_get_llm_outputs(input_remaining_batches)
        final_answer_json, input_remaining_batches, failed_llm_outputs = parse_jsons_from_llm_outputs(llm_outputs, input_remaining_batches, final_answer_json)
    
    print(f"It took me {num_tries} num tries to process all initial batches (topics)")
    
    

    return final_answer_json



    
@app.post("/classify_relevance/")
async def classify_relevance(
    api_key: str = Security(get_api_key),
    user_profile_and_preferences: Union[str, UploadFile] = Form(...),
    mongo_name_of_collection_with_topics: str = Form(None),
    topics_ids: list[str] = Form(...),
    # topics_ids: list[str] = Form(None),
    model_name: Union[str, None] = Query("Mistral", enum=["Mistral", "Llama-3"]),
    ):
    if False:
        # 41 topics
        topics_ids = [
        '018658', '0257c3', '07807d', '09e0bd',
        '0e620d', '190061', '199c34', '1af0e0',
        '1b3652', '22a66b', '271f07', '2a0cc3',
        '3b0ebf', '3ffd05', '4b0065', '6946b3',
        '6c9f78', '6e364e', '6fbc03', '70737b',
        '714e81', '716c6e', '786abf', '808935',
        '94fa2d', '96c1af', '9703ca', '98b75f',
        '9d3e7c', 'aa3e21', 'ad280f', 'b3c255',
        'b4fad4', 'c40fab', 'c680d4', 'c89633',
        'cfe87f', 'daab1c', 'e07e36', 'e264d1',
        'f0c9ed'
        ]
    else:
        topics_ids = topics_ids[0].split(',')

    return classify_relevance_method(user_profile_and_preferences, mongo_name_of_collection_with_topics, topics_ids, model_name)
    


@app.post("/classify_likeliness/")
async def classify_likeliness(
    api_key: str = Security(get_api_key),
    # like_map: Union[str, dict] = Form(...),
    user_name: str = Form(...),
    mongo_name_of_collection_with_topics: str = Form(None),
    liked_topics_ids: list[str] = Form(...),
    topics_to_classify_ids: list[str] = Form(...),
    model_name: Union[str, None] = Query("Mistral", enum=["Mistral", "Llama-3"]),
    verbose: bool = Query(False),
    represent_topics_as: str = Query(..., enum=["raw_messages", "summaries"]),
    ):
    global archive_db, tokenizer
    
    max_tokens_for_topics_batch = 1_000

    use_cloudflare = False
    if use_cloudflare:
        model_address = f"https://api.cloudflare.com/client/v4/accounts/{CLOUDFLARE_ACCOUNT_ID}/ai/run/@cf/meta/llama-3-8b-instruct" if model_name == 'Llama' else \
            f"https://api.cloudflare.com/client/v4/accounts/{CLOUDFLARE_ACCOUNT_ID}/ai/run/@hf/mistral/mistral-7b-instruct-v0.2"
    else:
        MISTRAL_ENDPOINT = "https://api.mistral.ai/v1/chat/completions"
        model_address = MISTRAL_ENDPOINT


    liked_topics_ids = liked_topics_ids[0].split(',')
    topics_to_classify_ids = topics_to_classify_ids[0].split(',')
    # topics_to_classify_ids = ['199c34', '1af0e0', '1b3652', '22a66b']
    
    if represent_topics_as == 'raw_messages':
        topics = get_topics_messages_from_mongo(archive_db[mongo_name_of_collection_with_topics], liked_topics_ids, format_for='likeliness')
    elif represent_topics_as == 'summaries':
        topics = get_topics_summaries_from_mongo(archive_db[mongo_name_of_collection_with_topics], liked_topics_ids, format_for='likeliness')
    else:
        topics = None

    topics_batches = split_topic_messages_into_batches(topics, max_tokens_for_topics_batch)

    user_summary = [
        f'{user_name} preferences could be described as:'
    ]
    
    for topics_batch in tqdm(topics_batches):
        # print(f'User profile {user_profile_and_preferences}')
        chat = format_topics_batch_into_chat_for_likeliness(topics_batch, user_name)

        if verbose:
            print('The following batch look like:')
            print(chat[-1]['content'])
        user_profile_and_preferences = call_llm(use_cloudflare, model_address, chat, verbose=False).strip()
        
        # user_profile_and_preferences = parse_text_in_tripple_quotes(user_profile_and_preferences)
        user_profile_and_preferences = parse_json(user_profile_and_preferences)
        user_profile_and_preferences = user_profile_and_preferences.get('preference', '')
        
        user_summary.append(user_profile_and_preferences)
        if verbose:
            print()
            print('-' * 70)
            print(user_profile_and_preferences)

    # user_summary = wrap('\n'.join(user_summary))
    user_summary = '\n'.join(user_summary)
    
    print(user_summary)
    print()

    
    res = classify_relevance_method(user_summary, 'blocks', topics_to_classify_ids, 'Mistral')
    return res
    # return {'user_summary': user_summary}
