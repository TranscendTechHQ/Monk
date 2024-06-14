import os
from typing import List

RELEVANCE_API_KEY = os.getenv('RELEVANCE_API_KEY')
RELEVANCE_URL = os.getenv('RELEVANCE_URL')

import requests


def get_relevance(user_name:str, user_profile: str, thread_ids: List[str]):
    # Define the API endpoint URL
    

    # Convert the list to a comma-separated string
    thread_ids_string = ','.join(thread_ids)
    
    user_profile_and_preferences = "My name is " + user_name + ". " + user_profile
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
    print(response.text)

def main():
    user_preference = 'I am a product manager. Show me mvp related stuff'
    #thread_ids = ['90897c22']
    thread_ids =["add0bae1-ce71-454b-b830-e580a5b7ff7d"]
    get_relevance(user_name="Yogesh Soni", user_profile=user_preference, thread_ids=thread_ids)

if __name__ == "__main__":
    main()