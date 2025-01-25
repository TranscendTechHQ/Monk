import pandas as pd
import uuid
import os
import re
import json


def retrive_info(row):

    date = row["time"][:10]
    time = row["time"][-10:-5]
    user = row["user"]
    message = row["message.1"]
    id = row["id"]

    return f"Timestamp: {date}  {time} | Author: {str(user)} | Unique ID: {id} | message: {str(message)}"


def build_chat(conversation):

    dictionary_example = [
        {
            "topic": "name of some topic",
            "messages": [
                {"Unique ID": "unique id of some message"},
                {"Unique ID": "unique id of some message"},
                {"Unique ID": "unique id of some message"},
                {"Unique ID": "unique id of some message"},
            ]
        },
        {
            "topic": "name of some topic",
            "messages": [
                {"Unique ID": "unique id of some message"},
                {"Unique ID": "unique id of some message"},
            ]
        },
        {
            "topic": "name of some topic",
            "messages": [
                {"Unique ID": "unique id of some message"},
                {"Unique ID": "unique id of some message"},
                {"Unique ID": "unique id of some message"},
            ]
        }
    ]
    template = f"""
Your task is conversation disentanglement.

Given a history of conversation, your goal is to group messages into distinct topics.
History of conversation:
-{conversation}

Print the output in JSON format, ensuring it follows the specified structure or organization of topics:
{dictionary_example}
"""
    chat = [{"role": "user", "content": template}]

    return chat


def get_batches(current_df, batch_size=40):

    current_df["id"] = current_df.apply(lambda _: str(uuid.uuid4())[:8], axis=1)
    current_df["all_info"] = current_df[["time", "user", "message.1", "id"]].apply(retrive_info, axis=1)

    list_of_messages = current_df["all_info"].tolist()
    list_of_messages = [str(message)[:350] for message in list_of_messages]

    batches = []
    for i in range(0, len(list_of_messages), batch_size):
        messages = "\n-".join(list_of_messages[i:i+batch_size])
        chat = build_chat(conversation=messages)
        batches.append(chat)

    return batches, current_df


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


def get_last_batches(df_old, df_new, batch_size=40, csv_data_dir="csv_data"):

    df_new = df_new.iloc[len(df_old):]
    df_cat = pd.concat([df_old, df_new], axis=0)
    messages_for_consideration = len(df_old) % batch_size
    df_for_preprocessing = df_cat.iloc[(len(df_old)-messages_for_consideration):]

    return df_for_preprocessing, messages_for_consideration


def json_preprocess(outputs):

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

    return json.loads(json_formatted)

    
def generate_json_list(outputs):

    id_topic_pairs = {}
    json_list = json_preprocess(outputs)
    for json_topic_messages in json_list:
        current_topic = json_topic_messages["topic"]
        for message_id in json_topic_messages["messages"]:
            id_topic_pairs[message_id["Unique ID"]] = current_topic
            
    return id_topic_pairs  