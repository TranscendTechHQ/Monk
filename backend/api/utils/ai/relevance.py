import os
from typing import List
from config import settings

RELEVANCE_API_KEY = settings.RELEVANCE_API_KEY
RELEVANCE_URL = settings.RELEVANCE_URL

import requests


def get_relevant_thread_ids(user_name:str, user_preference: str, thread_ids: List[str]):
    # Define the API endpoint URL
    

    # Convert the list to a comma-separated string
    thread_ids_string = ','.join(thread_ids)
    
    user_profile_and_preferences = "My name is " + user_name + ". " + user_preference
    # Define the request payload
    payload = {
        'user_profile_and_preferences': user_profile_and_preferences ,
        'mongo_name_of_collection_with_topics': 'blocks',
        'topics_ids': thread_ids_string
    }

    # Define the request headers
    headers = {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-API-Key': RELEVANCE_API_KEY
    }

    # Send the POST request
    response = requests.post(RELEVANCE_URL, headers=headers, data=payload)

    # Print the response
    #print(response.text)
    if response.status_code != 200:
        print(f"Error: {response.text}")
        return None
    #parse the thread_ids from the response
    relevant_thread_ids = []
    relevant_list = response.json()[user_name]["relevant"]
    for relevant in relevant_list:
        #print(relevant.keys())
        relevant_thread_ids.append(list(relevant.keys())[0])
    print(f"relevant_thread_ids = {relevant_thread_ids}")
    return relevant_thread_ids

def main():
    user_preference = 'I am a product manager. Show me mvp related stuff'
    #thread_ids = ['90897c22']
    thread_ids =["add0bae1-ce71-454b-b830-e580a5b7ff7d"]
    get_relevant_thread_ids(user_name="Yogesh Soni", user_preference=user_preference, thread_ids=thread_ids)

if __name__ == "__main__":
    main()