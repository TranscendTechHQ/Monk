from pymongo import MongoClient, DESCENDING
from pprint import pprint
from tqdm import tqdm
import sys
sys.path.append('../')
from config import settings
from dedicated_server.preprocessing import call_llm
from prompts import (
    system_message_for_summary, user_oneshot_message, assistant_oneshot_message
)


STAGE_GROUPING = {'$group': {
    '_id': '$main_thread_id',
    'topic': {'$addToSet': '$topic'},
    'topic_messages': {'$push': '$content'}
}}

STARGE_SORTING = {
    "$sort": { "main_thread_id": DESCENDING }
}


def summarize_topics_from_mongo(db, collection_name_read_from: str, collection_name_write_to: str, topics_ids: list=[]):
    """
    This function reads documents (messages) from mongodb, matches topics ids, then grouping 
    and summarization for each topics. The result is written to new collection in mongo.
    db: The MongoDB database instance.
    collection_name_read_from: The name of the collection to read documents from.
    collection_name_write_to: The name of the collection to write summarized data to.
    topics_ids (list, optional): A list of topic IDs to filter documents. If not provided,
        all documents will be considered.
    """
    global system_message_for_summary, user_oneshot_message, assistant_oneshot_message,\
    STAGE_GROUPING, STARGE_SORTING

    stage_matching_ids = {'$match': {'main_thread_id': {'$in': topics_ids}}}

    pipeline = [
        stage_matching_ids,
        STARGE_SORTING,
        STAGE_GROUPING,
    ] if topics_ids else [STARGE_SORTING,
                          STAGE_GROUPING]

    result = list(db[collection_name_read_from].aggregate(pipeline))
    topics = []

    for topic_json in tqdm(result):

        messages = '- ' + '\n\n- '.join((message[:380].replace('\n', ' ') for message in topic_json['topic_messages']))
        topic = f'Topic "{topic_json["topic"][0]}" \n\n{messages}'

        chat = [
                {"role": "system", "content": system_message_for_summary},
                {"role": "user", "content": user_oneshot_message},
                {"role": "assistant", "content": assistant_oneshot_message},
                {"role": "user", "content": topic}
            ]

        result = call_llm(False, "https://api.mistral.ai/v1/chat/completions", chat, n_error_tries=10, verbose=False)

        topics.append(
            {
                '_id': topic_json['_id'],
                'topic': topic_json['topic'][0],
                'summary': result
            }
        )


    result = db[collection_name_write_to].insert_many(topics)
    print(f'Successfully inserted {len(result.inserted_ids)} topics.')
    return result.inserted_ids











if __name__ == '__main__':
    from argparse import ArgumentParser

    parser = ArgumentParser(description='to parse json file name')
    parser.add_argument('-r', '--collection_name_read_from')
    parser.add_argument('-w', '--collection_name_write_to')
    parser.add_argument('-t', '--topics_ids', nargs="*", default=[], help="List of topic IDs")

    args = parser.parse_args()
    collection_name_read_from = args.collection_name_read_from
    collection_name_write_to = args.collection_name_write_to
    topics_ids = args.topics_ids

    connection_string = settings.MONGO_CONNECTION_STRING
    client = MongoClient(connection_string)
    print("Connected to MongoDB successfully!")

    db = client.archive

    inserted_ids = summarize_topics_from_mongo(db, collection_name_read_from, collection_name_write_to, topics_ids)
