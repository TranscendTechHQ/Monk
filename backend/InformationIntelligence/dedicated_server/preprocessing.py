import uuid
import pandas as pd
import uuid
import os
import re
import json
import io
import requests
from pprint import pprint
import numpy as np
import sys
if sys.platform != "darwin":
    from transformers import AutoTokenizer
    from huggingface_hub import login
    from vllm import LLM, SamplingParams
from pymongo import MongoClient, DESCENDING
from langchain_text_splitters import CharacterTextSplitter
from transformers import AutoTokenizer
from tqdm import tqdm
import traceback
from huggingface_hub import login
#tokenizer = AutoTokenizer.from_pretrained("mistralai/Mistral-7B-Instruct-v0.2")
from config import settings

MONGO_ARCHIVE_FIELDS = ['_id', 'content', 'created_at', 'creator_id', 'topic']

CLOUDFLARE_ACCOUNT_ID = settings.CLOUDFLARE_ACCOUNT_ID
CLOUDFLARE_AUTH_TOKEN = settings.CLOUDFLARE_AUTH_TOKEN
MISTRAL_API_KEY = settings.MISTRAL_API_KEY


model_name='mistralai/Mistral-7B-Instruct-v0.2'

login(token=settings.HF_ACCESS_TOKEN)
tokenizer = AutoTokenizer.from_pretrained(model_name, token=settings.HF_ACCESS_TOKEN)

if sys.platform != "darwin":
    sampling_params = SamplingParams(max_tokens=1200, temperature=0.4)



def retrieve_info(row):

    # date = row["created_at"][:10]
    # time = row["created_at"][-10:-5]
    # date = str(row["created_at"])[:10]
    # time = str(row["created_at"])[-10:-5]
    user = row["creator_id"]
    message = str(row["content"]).replace('\n', ' ')
    id = row["id"]

    return f"{id}, {str(user)[:6]}: {message};"


def build_chat_vllm(messages):
    system_message = """
    <System>
    You are expert at analyzing conversations. User will give you a few messages with corresponding senders and UniqueIDs.
    You have to determine which topic does the messages belong to. Each message should belong to exactly one topic. Don't skip or miss messages.
    You can consider how the new conversations is related to the topics and also the message sender. Your goal is to group 
    UniqueIDs of messages into distinct topics. Pay close attention to the following input format:

    "
    <UniqueID>, <sender>: <message>;
    <UniqueID>, <sender>: <message>;
    <UniqueID>, <sender>: <message>;
    <UniqueID>, <sender>: <message>;
    "
    
    And also pay attention to to the output format, it must be a JSON-formatted list, a list of dicts of json format, which would be parsed by python, 
    so avoid mistakes. Give the final output in the following format:

    "
    [
        {"topic": "suggested topic", 
         "<UniqueID>": [
                "<UniqueID> of some message",
                "<UniqueID> of some message",
            ],
         "reason": "reason why these messages belong the suggested topic"},
        {"topic": "suggested topic", 
            "<UniqueID>": [
                "<UniqueID> of some message",
                "<UniqueID> of some message",
            ],
         "reason": "reason why these messages belong the suggested topic"},
    ]
    "
    <System>
    
    <User's messages>
    fc096c95, Bob: Go programming is great for building web server;
    d7d85d62, Tom: I agree. However it has a steep learning curve;
    ffff2749, John: who is working on the clustering problem?;
    9c89fc12, Robert: Taras;
    9d5ce6b6, Bob: Yes;
    <User's messages>

    """
    
    assistant_oneshot_message = """
    [
        {"topic": "Go programming", 
         "messages": [
                "fc096c95",
                "d7d85d62",
                "9d5ce6b6"
            ],
         "reason": "Bob and Tom are discussing Go programming and its nuances"},
        {"topic": "Clustering problem", 
            "UniqueID": [
                "ffff2749",
                "9c89fc12",
            ],
         "reason": "John and Robert are talking about clustering problem"},
    ]
    """
    
    chat = [
        # {"role": "system", "content": system_message},
        {"role": "user", "content": system_message},
        {"role": "assistant", "content": assistant_oneshot_message},
        {"role": "user", "content": f"\n<User's messages>\n{messages}\n<User's messages>"}
    ]
    
    return chat


def build_chat_cloudflare(messages):
    system_message = """
    You are expert at analyzing conversations. User will give you a few messages with corresponding senders and UniqueIDs.
    You have to determine which topic does the messages belong to. Each message should belong to exactly one topic. Don't skip or miss messages.
    You can consider how the new conversations is related to the topics and also the message sender. Your goal is to group 
    UniqueIDs of messages into distinct topics. Pay close attention to the following input format:

    "
    <UniqueID>, <sender>: <message>;
    <UniqueID>, <sender>: <message>;
    <UniqueID>, <sender>: <message>;
    <UniqueID>, <sender>: <message>;
    "
    
    And also pay attention to to the output format, it must be a JSON-formatted list, a list of dicts of json format, which would be parsed by python, 
    so avoid mistakes. Give the final output in the following format:

    "
    [
        {"topic": "suggested topic", 
         "<UniqueID>": [
                "<UniqueID> of some message",
                "<UniqueID> of some message",
            ],
         "reason": "reason why these messages belong the suggested topic"},
        {"topic": "suggested topic", 
            "<UniqueID>": [
                "<UniqueID> of some message",
                "<UniqueID> of some message",
            ],
         "reason": "reason why these messages belong the suggested topic"},
    ]
    "
    """
    
    user_oneshot_message = """
    fc096c95, Bob: Go programming is great for building web server;
    d7d85d62, Tom: I agree. However it has a steep learning curve;
    ffff2749, John: who is working on the clustering problem?;
    9c89fc12, Robert: Taras;
    9d5ce6b6, Bob: Yes;
    """
    
    assistant_oneshot_message = """
    [
        {"topic": "Go programming", 
         "messages": [
                "fc096c95",
                "d7d85d62",
                "9d5ce6b6"
            ],
         "reason": "Bob and Tom are discussing Go programming and its nuances"},
        {"topic": "Clustering problem", 
            "UniqueID": [
                "ffff2749",
                "9c89fc12",
            ],
         "reason": "John and Robert are talking about clustering problem"},
    ]
    """
    
    chat = [
        {"role": "system", "content": system_message},
        {"role": "user", "content": user_oneshot_message},
        {"role": "assistant", "content": assistant_oneshot_message},
        {"role": "user", "content": messages}
    ]

    
    return chat




def get_batches(current_df, batch_size=40, overlap=0, model_type='runpod'):
    global tokenizer
    chat_templates = {
        'runpod': build_chat_vllm,
        'cloudflare_endpoint': build_chat_cloudflare,
    }

    current_df["all_info"] = current_df[["created_at", "creator_id", "content", "id"]].apply(retrieve_info, axis=1)
    list_of_messages = current_df["all_info"].tolist()
    list_of_messages = [str(message)[:380] for message in list_of_messages]

    batches = []
    
    print('-' * 50)
    print('Batches')
    step = batch_size - overlap
    for i in range(0, len(list_of_messages) - step + 1, step):
        print(i, i+batch_size)
        
        messages = "\n".join(list_of_messages[i:i+batch_size])
        print(len(messages.split('\n')))
        
        #print(messages)
        # Apply different chat building functions
        chat = chat_templates[model_type](messages=messages)
        if model_type == 'runpod':
            model_input = tokenizer.apply_chat_template(chat, tokenize=False)
        else:
            
            model_input = chat
        batches.append(model_input)

    return batches


def find_start_of_brackets(input_string):
    for i, char in enumerate(input_string):
        if char == "[":
            return i
    return -1


def find_end_of_brackets(input_string):
    for i, char in enumerate(input_string[::-1]):
        if char == "]":
            return len(input_string) - i
    return -1


def json_preprocess(outputs):

    try:
        start = find_start_of_brackets(outputs)
        end = find_end_of_brackets(outputs)
    
        json_unformatted = outputs[start:end]
        json_unformatted = json_unformatted.replace('\n', '').strip()

        exceptions = ",{}[]'\":"
        pattern = r'[^\w\s' + re.escape(exceptions) + ']'
        json_unformatted = re.sub(pattern, '', json_unformatted)
        
        if json_unformatted.endswith(",]"):
            json_unformatted = f"{json_unformatted[:-2]}]"
    
        json_formatted = json_unformatted.strip()
        return json.loads(json_formatted)
    except Exception as e:
        pass
        print(f"Sorry, eRror occurred: {e}\n\n{outputs}\n")

    try:
        start = find_start_of_brackets(outputs)
        end = find_end_of_brackets(outputs)
    
        json_unformatted = outputs[start:end]
        json_unformatted = json_unformatted.replace('\n', '').strip()
    
        exceptions = ",{}[]'\":"
        pattern = r'[^\w\s' + re.escape(exceptions) + ']'
        json_unformatted = re.sub(pattern, '', json_unformatted)
    
        if json_unformatted.endswith(",]"):
            json_unformatted = f"{json_unformatted[:-2]}]"
    
        json_formatted = json_unformatted.replace("'", '"')
        json_formatted = json_formatted.strip()
        return json.loads(json_formatted)
    except Exception as e:
        pass
        print(f"Sorry, eRror occurred: {e}")
    return {}


def generate_json_list(outputs):
    id_topic_pairs = {}
    # print("_STA_"*20)
    
    #print(outputs)
    # print("_MID_"*20)
    json_list = json_preprocess(outputs)
    # print(json_list)
    # print("_END_"*20)
    for json_topic_messages in json_list:
        if not "topic" in json_topic_messages:
            return None
        if not "UniqueID" in json_topic_messages:
            return None
        current_topic = json_topic_messages["topic"]
        for message_id in json_topic_messages["UniqueID"]:
            id_topic_pairs[message_id] = current_topic
    
    return id_topic_pairs


def generate_streaming_string(string: str):
    towrite = io.BytesIO()
    towrite.write(string.encode())
    towrite.seek(0)
    return  towrite.getvalue()


def add_unique_ids_and_topic_column(df):
    df["id"] = df.apply(lambda _: str(uuid.uuid4())[:8], axis=1)
    df['topic'] = np.nan
    return df



def get_topics_messages_from_mongo(collection, topics_ids, format_for='relevance'):
    #print(f"topics_ids: {topics_ids}")
    #print(collection.count_documents({}))
    #print(collection.find_one({"main_thread_id":topics_ids[0]}))
    stage_matching_ids = {'$match': {'main_thread_id': {'$in': topics_ids}}}
    stage_lookup = {
        '$lookup':
            {
                'from': "threads",
                'localField': "main_thread_id",
                'foreignField': "_id",
                'as': "topic_docs"
            }
    }
    
    stage_unwinding = {
    '$unwind':
      {
        'path': "$topic_docs"
      }
    }
    stage_replace_root = {
        '$replaceRoot': {
        'newRoot': {
            '$mergeObjects': [
            "$$ROOT",
            {
                'topic': "$topic_docs.topic"
            }
            ]
        }
        }
    }
    stage_grouping = {'$group': {
        '_id': '$main_thread_id',
        'topic': {'$addToSet': '$topic'},
        'topic_messages': {'$push': '$content'}
    }}

    stage_sorting = {
        "$sort": { "main_thread_id": DESCENDING }
    }

    pipeline = [
        stage_matching_ids,
        stage_lookup,
        stage_unwinding,
        stage_replace_root,
        stage_sorting,
        stage_grouping,
    ]
    #print(pipeline)
    
    topic_messages = []
    # result = list(collection.aggregate(pipeline))
    result = collection.aggregate(pipeline)
    #print(list(result))
    if format_for == 'relevance':
        #print("relevance")
        for topic_json in result:
            #print(topic_json)
            messages = '\n- '.join((message[:380] for message in topic_json['topic_messages']))
            topic = f'"Id: {topic_json["_id"]}"\n Topic "{topic_json["topic"][0]}" \n- {messages}'
            topic_messages.append(topic)
    
    elif format_for == 'likeliness':
        for topic_json in result:
            messages = '\n- '.join((message[:380] for message in topic_json['topic_messages']))
            topic = f'{topic_json["topic"][0]}\n- {messages}'
            topic_messages.append(topic)
    
    topic_messages = '\n\n\n'.join(topic_messages)
    print(f"topics: {topic_messages}")
    return topic_messages

def get_topics_summaries_from_mongo(collection, topics_ids, format_for='likeliness'):
    stage_matching_ids = {'$match': {'main_thread_id': {'$in': topics_ids}}}
    
    stage_grouping = {'$group': {
        '_id': '$main_thread_id',
        'topic': {'$addToSet': '$topic'},
        # 'topic_messages': {'$push': '$content'}
        
    }}
    
    stage_lookup = {
        '$lookup':
            {
                'from': "threads",
                'localField': "_id",
                'foreignField': "_id",
                'as': "summaries_docs"
            }
    }
    
    stage_projection = {
        '$project':
            {
            '_id': 1,
            'topic': { '$arrayElemAt': ["$topic", 0] },
            'summary': { '$arrayElemAt': ["$summaries_docs.summary", 0] }
            }
    }

    
    pipeline = [
        stage_matching_ids,
        stage_grouping,
        stage_lookup,
        stage_projection,
    ]
    
    topics = []
    result = list(collection.aggregate(pipeline))

    # result = collection.aggregate(pipeline)
    
    if format_for == 'relevance':
        for topic_json in result:
            pass
            # messages = '\n- '.join((message[:380] for message in topic_json['topic_messages']))
            # topic = f'"Id: {topic_json["_id"]}"\n Topic "{topic_json["topic"][0]}" \n- {messages}'
            # topic_messages.append(topic)
    
    elif format_for == 'likeliness':
        for topic_json in result:
            topic = f'Topic "{topic_json["topic"]}"\n{topic_json["summary"]}'
            topics.append(topic)
    
    topics = '\n\n\n'.join(topics)
    #print(f"topics: {topics}")
    return topics

def split_topic_messages_into_batches(topic_messages, max_tokens):
    text_splitter = CharacterTextSplitter.from_huggingface_tokenizer(
        tokenizer, chunk_size=max_tokens, chunk_overlap=0, separator='\n\n\n'
    )
    return text_splitter.split_text(topic_messages)

def format_topics_batches_into_chats(topics_batches, user_profile_and_preferences,
                                     system_message='', user_oneshot_message='', assistant_oneshot_message=''):
    system_message = """
    You will be given a list of facts about people and their preferences. And also user will provide you a list of topics and corresponding conversation messages in the following format in triple quotes.
    ```
    {User Preference for Robert}
    
    - is a marketing person
    - oversees all marketing operations for software products
    - does not like hardware product discussions

    Topics:
    
    Id: Topic id 1
    Topic Title 1
    - message 1
    - message 2
    - message 3

    Id: Topic id 2
    Topic Title 2
    - message 1
    - message 2
    - message 3
    ```

    You need to classify each topic as either relevant or irrelevant for each person. Don't skip topics, if you are not certain in a topic, add it to relevant. 
    Also pay special attention to topic ids, they should be exactly the same as from input.
    Show the output in the following JSON format.
    ```
    [
    { "person 1":
    "relevant": {
    [
    {"topic": Topic id 1
    "reason": "because person 1 likes xyz and this topic mentions something related"}
    ]
    
    "irrelevant": {
    [
    {"topic": Topic id 2
    "reason": "because person 2 hates anything related to abc "}
    ]
    ]
    ```
    """
    
    user_oneshot_message = """
    ```
    {User Preference for Kiran}
    
    - software guy
    - writes embedded software 
    - hates meetings
    
    Topics:
    Id: 0bxy99
    Topic 1
    
    - real-time os version released.
    - with this we can write deterministic embedded software
    - good news! is there any market demand for this?
    - we will see. Build it and they will come!
    - ha ha. aren't we too optimistic?
    - I am gonna present it in our customer appreciation conference next month in Canberra

    Id: 1cxt32
    Topic 2
    - kubernetes allows to run containers at scale
    - customers who have applications with millions of users need their applications to scale horizontally.
    - yeah, but our customers are SMB. They don't need scale.

    Id: acxy43
    Topic 3
    
    - chatgpt will challenge the SEO landscape
    - Now search is no longer going to provide a list of links
    - moreover, websites cannot just contain keywords that are picked up by the search engine
    - AI assistants directly provide answers, often constructed from multiple sources.
    - Really? Do they provide back references to the sources?
    - Some of them do, yeah.
    - Then there is still scope for useful content driving users back to our website!
    - True. May be we can use LLM to write content?
    - I said useful content :)
    - lol

    Id: 3fxyc0
    Topic 4
    
    - we need to hire more people from the minority community
    - Why?
    - because we want to create more diversity in our workforce
    - What is diversity based on?
    - socio economic conditions, ethnicity, race, religion, language, gender etc.
    - hmmm, as long as we don't compromise our standards of merit and skillset, I am all for it. Remember, we have a business to run. 
    - Noted.

    Id: e0xy59
    Topic 5
    
    - new method to create awareness for our products
    - we will sell NFTs of animated version of our products!
    - how many people buy NFTs?
    - a lot, it's all the craze right now.
    - are the people buying NFTs in our target customer segment?
    - does it matter?
    - YES !!!!
    ```
    """
    
    
    assistant_oneshot_message = """
    ```
    [{
        "Kiran": {
            "relevant": [
                {
                    "topic": "0bxy99",
                    "reason": "Kiran writes embedded software, so the discussion about real-time OS and deterministic software is relevant to him"
                }
            ],
            "irrelevant": [
                {
                    "topic": "1cxt32",
                    "reason": "Kiran works with embedded software and has no interest in container scaling"
                },
                {
                    "topic": "acxy43",
                    "reason": "Kiran does not like meetings and this topic seems unrelated to his preferences"
                },
                {
                    "topic": "3fxyc0",
                    "reason": "Kiran is focused on software development and not interested in DEI discussions"
                },
                {
                    "topic": "e0xy59",
                    "reason": "Kiran is in software and not likely to be interested in NFTs and product awareness methods"
                }
            ]
        }
    }]
    ```
    """
    
    chats = [
        [
            {"role": "system", "content": system_message},
            {"role": "user", "content": user_oneshot_message},
            {"role": "assistant", "content": assistant_oneshot_message},
            {"role": "user", "content": f"```\nUser:\n{user_profile_and_preferences}\n\n\nTopics:\n{batch_of_topics}\n```"}
        ] for batch_of_topics in topics_batches
    ]
    # print(chats[0][-1]['content'])

    return chats




def format_topics_batch_into_chat_for_likeliness(topics_batch, user_name,
                                     system_message='', user_oneshot_message='', assistant_oneshot_message=''):
    system_message = """
    You will be given a list of conversation topics along with the corresponding messages 
    as shown below inside triple ticks
    ```
    Topic Title 1
    - message 1
    - message 2
    - message 3

    Topic Title 2
    - message 1
    - message 2
    - message 3
    ```
    You will also be give a user's name who likes these topics as follows:
    ```
    User name: Kiran
    ```
    Your task is to generate a summary of the user's preferences and the topics they like.
    Make assumptions on what user likes reading and formulate a short summary of a user profile.
    
    Show the output in the following json format:
    ```
    {"user": "Kiran", "preference": "Kiran likes ... He is interested in ..."}
    ```
    """
    
    user_oneshot_message = """
    ```
    Server API Developments
    - The new API endpoint for data retrieval has been successfully integrated and tested.
    - A bug in the authentication process of the server API has been identified and fixed.
    - The API documentation has been updated with the latest changes and improvements.

    Model Performance Metrics
    - The latest model iteration has achieved a 2% increase in accuracy.
    - The model's precision and recall metrics have been uploaded to the dashboard for review.
    - A significant drop in model performance was observed during the last training session.

    Experiment Results
    - The A/B test comparing the new algorithm with the baseline has concluded, showing a 5% improvement.
    - The results of the hyperparameter tuning experiment indicate optimal settings for learning rate and batch size.
    - New experimental results on data augmentation techniques have been added to the shared folder.

    Task Assignments
    - Yogesh has assigned a new task to develop a feature extraction module for the upcoming project.
    - Srikanth has requested a review of the current model's performance metrics by end of the week.
    - A collaborative task between the data engineering team and ML team has been initiated to streamline data preprocessing.

    Technical Issues and Anomalies
    - An issue with the GPU cluster during model training has caused delays in the experiment schedule.
    - An anomaly detected in the data pipeline has been investigated and resolved.
    - A memory leak was identified in the server API, and a patch has been deployed to fix it.
    ```
    ```
    User name: Bob
    ```
    """

    
    
    assistant_oneshot_message = """
    ```
    {"user": "Bob", "preference": "Bob is interested in regular updates on server API developments, model performance metrics, and the results of experiments. Additionally, he needs to stay informed about any new tasks assigned by Yogesh or Srikanth to the engineering team or himself. He prefers detailed technical information and must be promptly notified of any issues or anomalies that arise during model training or deployment."}
    ```
    """
    user_prompt =  f"```{topics_batch}\n```\n\n```User name: {user_name}```"
    chat = [
            {"role": "system", "content": system_message},
            {"role": "user", "content": user_oneshot_message},
            {"role": "assistant", "content": assistant_oneshot_message},
            {"role": "user", "content": user_prompt}
        ]
    # print(chat[-1]['content'])

    return chat

def call_llm(chat, n_error_tries=10, verbose=True):
    
    ret = None
    
    if verbose:
        print(f"model address: {model_address}")
    for i in range(n_error_tries):
        
        model_address = settings.LLM_ENDPOINT
        api_key = settings.LLM_API_KEY
        model_name = settings.LLM_MODEL
        try:
            response = requests.post(
                url=model_address,
                headers={"Authorization": f"Bearer {api_key}"},
                json={"model":f"{model_name}",
                        "messages": chat, 
                        "max_tokens": 4096},
                timeout=30
            ).json()
        except Exception as e:
                print(f"Error: {e}")
                response = None
        if not response:
            continue
        print(response)
        ret = response['choices'][0]['message']['content']

        if verbose:
            print(f"for this batch this is model response \n{ret}\n ******************\n")
        break
        
    return ret

def process_batches_and_get_llm_outputs(chats, n_error_tries=10):
    final_output = []
    #print(f"Total batches: {len(chats)}")
    for idx, chat in tqdm(enumerate(chats)):
        print()
        print(f'Input size: {len(tokenizer.encode(" ".join( (dct["content"] for dct in chat) )))} tokens.')
        print(f"Batch {idx + 1} / {len(chats)}")
        ret = call_llm(
                        
                       chat=chat, 
                       n_error_tries=n_error_tries,
                       verbose=False)
        print(f"idx: {idx}, ret: {ret}")
        if ret:
            #print(f"for this batch this is model response \n {ret} \n ******************\n")
            final_output.append(ret)
    
    return final_output


def parse_topics_ids_from_prompt(prompt):
    #pattern = r'(?<=Id ").*(?=")'
    #print(prompt)
    pattern = r"Id: ([a-zA-Z0-9-]+)"
    matches = re.findall(pattern, prompt)
    main_thread_ids = [match for match in matches]
    #print(f"Topics ids: {main_thread_ids}")
    #print(set(main_thread_ids))
    #exit()
    return set(main_thread_ids)


def parse_text_in_tripple_quotes(text):
    pattern = r"```[^`]{5,}```"
    pattern = r"(?<=```)[^`]{5,}(?=```)"
    matches = re.findall(pattern, text)
    return '\n\n'.join([match for match in matches]).strip()


def parse_json(text):
    pattern = r"\{[\s\S]+\}"
    matches = re.findall(pattern, text)
    print(text)
    print()
    print(matches[0])
    return json.loads(matches[0])



def parse_jsons_from_llm_outputs(llm_outputs, input_remaining_batches, final_answer_json):
    # pattern = r'\[[\{\s][\s\S]*[\{\s]\]'
    pattern = r'\{[\s\S]*\}'
    failed_batches = []
    failed_llm_outputs = []
    merged_json = {}
    
    print(f'llm_outputs: {len(llm_outputs)}')
    
    for llm_output, input_batch in zip(llm_outputs, input_remaining_batches):
        match = re.search(pattern, llm_output, re.DOTALL)
        
        if match:
            json_str = match.group()
            try:
                # this is when regex starts with [ ]
                # json_dict = json.loads(json_str)[0]

                json_dict = json.loads(json_str)

                actual_topics_ids = [
                    topic_dict['topic']
                    for user, relevance in json_dict.items()
                    for key in ['relevant', 'irrelevant']
                    for topic_dict in relevance[key]
                ]
                reference_topics_ids = parse_topics_ids_from_prompt(input_batch[-1]['content'])
                            
                actual_topics_ids = set(actual_topics_ids)        
                if reference_topics_ids != actual_topics_ids:
                    print('No problems with parsing json')
                    print(f'DIFFERENT TOPICS in INPUT PROMPT and LLM OUTPUT')
                    print(f'Reference: amount {len(reference_topics_ids)}, topics ids {reference_topics_ids}')
                    print(f'Predicted: amount {len(actual_topics_ids)}, topics ids {actual_topics_ids}')
                    raise ValueError("LLM didn't mantioned all topics ids.\n\nThis batch would be processed again.")
                    
                elif reference_topics_ids == actual_topics_ids:
                    for user, relevance in json_dict.items():
                        if user not in final_answer_json:
                            final_answer_json[user] = {'irrelevant': [], 'relevant': []}
                        
                        for key in ['relevant', 'irrelevant']:
                            for topic_dict in relevance[key]:
                                final_answer_json[user][key].append({topic_dict['topic']: topic_dict['reason']})

            except Exception as e:
                failed_batches.append(input_batch)
                failed_llm_outputs.append(llm_output)
                # print(traceback.format_exc())    


    return final_answer_json, failed_batches, failed_llm_outputs


def verify_main_thread_ids(parsed_jsons, actual_topics):
    pass
    





async def get_streaming_response_init(batches_to_process, current_df, write_to_mongo, archive_db, chat_name_aka_collection_name_to_write_to_mongo_if_needed):
    global model_name, sampling_params
    llm = LLM(model=model_name, dtype="float16")

    to_print = True
    printer_count = 0
    
    cluster_size = 10

    all_id_topic_pairs = {}

    yield generate_streaming_string("[")

    error_processing_list = []
    while len(batches_to_process) != 0:
        print(f"Batches: {len(batches_to_process)}")
        outputs = llm.generate(batches_to_process[:cluster_size], sampling_params)
        

        for i, output in enumerate(outputs):
            current_output = output.outputs[0].text
            # if to_print:
            #     print(output.prompt)
            #     print()
            #     print(current_output)
            #     print('-' * 50)
            #     printer_count += 1
            #     if printer_count > 2:
            #         to_print = False

            try:
                id_topic_pairs = generate_json_list(current_output)
                all_id_topic_pairs.update(id_topic_pairs)

                # map predictions for batch and remove them from all other batches
                current_df['topic'] = current_df["id"].map(id_topic_pairs)

                # grab all predicted messages in batch and create list of JSON files
                predicted_json_list = json.loads(current_df[current_df['topic'].notna()].to_json(orient='records'))


                for row in predicted_json_list:
                    towrite = io.BytesIO()
                    towrite.write(json.dumps(row).encode())
                    towrite.seek(0)
                    yield towrite.getvalue()
                    yield generate_streaming_string(",")
    
                # print("done")
    

            except Exception as e:
                error_processing_list.append(i)
                print(str(e))

        
        batches_to_process = [elem for idx2, elem in enumerate(batches_to_process) if idx2 in error_processing_list or idx2 >= cluster_size]
        print(len(error_processing_list))
        error_processing_list = []
        cluster_size = 30

    current_df['topic'] = current_df["id"].map(all_id_topic_pairs)
    unpredicted_json_list = json.loads(current_df[current_df['topic'].isna()].to_json(orient='records'))
    # pprint(unpredicted_json_list)

    length_of_unpredicted_json_list = len(unpredicted_json_list)
    for idx3, row in enumerate(unpredicted_json_list):
        
        towrite = io.BytesIO()
        towrite.write(json.dumps(row).encode())
        towrite.seek(0)
        yield towrite.getvalue()

        if idx3 != length_of_unpredicted_json_list-1:
            yield generate_streaming_string(",")

    yield generate_streaming_string("]")
    
    print(f'Null percentage: {current_df.topic.isna().mean() * 100:.1f}%')
    if write_to_mongo:
        # global archive_db, MONGO_ARCHIVE_FIELDS
        
        # current_df.rename(columns=DIRECT_NAMING_MAPPING, inplace=True)
        current_df['_id'] = current_df.apply(lambda _: str(uuid.uuid4()), axis=1)
        # print(current_df)
        
        json_list = json.loads(current_df[MONGO_ARCHIVE_FIELDS].to_json(orient='records'))
        result = archive_db[chat_name_aka_collection_name_to_write_to_mongo_if_needed].insert_many(json_list)
        print(f'Inserted {len(result.inserted_ids)} documents to mongo')








def get_mistral_response(batches_to_process, current_df, write_to_mongo, archive_db, chat_name_aka_collection_name_to_write_to_mongo_if_needed):
    to_print = True
    printer_count = 0
    
    cluster_size = 10

    all_id_topic_pairs = {}

    MISTRAL_ENDPOINT = "https://api.mistral.ai/v1/chat/completions"
    model_address = MISTRAL_ENDPOINT
    error_processing_list = []
    for idx, batch in enumerate(batches_to_process):
        print(f"Batches left: {len(batches_to_process) - idx}")
        counter = 0
        # outputs = llm.generate(batches_to_process[:cluster_size], sampling_params)
        while True:
            counter += 1
            response = call_llm(
                                
                                chat=batch,
                                n_error_tries=10,
                                verbose=False)

            if response:
                id_topic_pairs = generate_json_list(response)
             
                if id_topic_pairs:
                    print(f'ID-topic pairs:\n{id_topic_pairs}\n')
                    all_id_topic_pairs.update(id_topic_pairs)
                    break
                else:
                    print("Oops, bad request, I'll try one more time")
            if counter > 4:
                pprint(response)
                print()
                print('Too many bad requests, skip this batch')
                counter = 0
                break

        # current_df['topic'] = current_df["id"].map(id_topic_pairs)
        # print(result)
       
        # return {'message': 'I finished execution successfully.'}
        # return json.loads(current_df.to_json(orient='records'))
        # break
    
    print(all_id_topic_pairs)
    current_df['topic'] = current_df["id"].map(all_id_topic_pairs)
    print(current_df)
    

    print(f'Null percentage: {current_df.topic.isna().mean() * 100:.1f}%')
    current_df['_id'] = current_df.apply(lambda _: str(uuid.uuid4()), axis=1)
    if write_to_mongo:
        # global archive_db, MONGO_ARCHIVE_FIELDS
        
        # current_df.rename(columns=DIRECT_NAMING_MAPPING, inplace=True)

        # print(current_df)
        
        json_list = json.loads(current_df[MONGO_ARCHIVE_FIELDS].to_json(orient='records'))
        result = archive_db[chat_name_aka_collection_name_to_write_to_mongo_if_needed].insert_many(json_list)
        print(f'Inserted to mongo {len(result.inserted_ids)} documents (messages)')
    
    yield json.loads(current_df[MONGO_ARCHIVE_FIELDS].to_json(orient='records'))
