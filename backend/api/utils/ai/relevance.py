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
    #thread_ids = ["add0bae1-ce71-454b-b830-e580a5b7ff7d"]
    thread_ids = ['add0bae1-ce71-454b-b830-e580a5b7ff7d', '7f1469bf-4467-4985-9e90-e3a1b0d0aeeb', 'c06d6a2f-a72b-4d64-afe7-ff2331a80199', '989ab67f-ecf6-4c5d-b21c-4c1cedf17053', '12262259-90fe-44bf-90e2-b17e2871a2df', '197b1aa8-f00c-43bd-80e5-4bd0f61ef701', 'f8ff71be-cbc2-4d7f-80cf-750d7d50db84', '9ce19006-33dc-414c-b867-8bbcc9180cb9', '4af808b9-d20e-4cde-bb07-15abd3dd316e', 'fc1f8a92-4c59-48dd-ab8a-1fc499c2395c', '7b0c701a-65d5-49f8-80bb-1f4cf5188f19', 'bb0b38d2-3e77-4aef-bc7f-c7ba31ca94e4', '19ad802a-f436-4888-b7e1-411a9ffb493e', '4996218d-1621-4798-a952-c9acd449236e', 'ad0c9ed5-b00c-47b6-9621-d94c7ae36373', 'bdb18f35-3445-4d23-8456-66c22df2d51f', '0cc8cb26-f85e-442b-9752-38d0f2879753', '98724795-1a7a-47f0-b246-6c8748608229', '40dca5f2-7054-4b69-983d-ebbde0f3ec0f', '34b9d115-8ccf-48db-88e5-316d518d9e1c', '930c03f1-3325-423a-a3f8-e2eb86e8cd56', '7e2f1eb7-3f63-4798-852e-d1410a967c3e', '624faa2e-941f-4bcd-9889-990c44321e35', 'a237ba97-64ad-4f95-812d-7460d012dea3', 'ed9b45e8-7f7f-4c8c-9035-e89e8cfe5a51', '1440433b-e8fa-4fe5-bcfd-5eda5dadb265', '83812e16-3c86-4346-8fd1-1936e4d109de', '7ffefd35-2286-4377-ae4d-02bcfe9b121a', '615de974-304b-47c5-b47b-65b6eb7f013e', '20627d60-61d9-4007-965e-e492c0617e14', '42460b2b-c7e9-41c0-86ad-76db82f86394', '39d7e602-0dff-4aa9-9430-32b915cf10e5', 'b4790888-f3dc-4f8a-9687-9d43a09ced28', '5769bf64-e602-4db9-b5cd-e76c3b1e19bc', 'eeebe912-2e74-40ef-96ea-80bb7e7a1e1b', '5ace5488-8d45-4436-b7f2-dceb8cf36bd2', 'e583ccb5-36b9-4075-a77f-d37619f76696', 'c66f7344-d3e2-4a0c-9825-0e5cea5df07a', 'c64140e5-5943-465e-9441-0ac141137b07', '0f279be7-4779-4c48-8c37-4aab2792dde9', '4ae40d46-97e7-4234-8b17-e73e309add34', 'acdfe90e-2d56-4cb3-98d9-bca363868852', 'e3b8638e-5bee-4aee-9418-34993ecbbead', '0e87e9bb-27c5-4e2c-9f0b-c7d80f97cc2a', 'bc8c29ba-7fcf-4bad-9839-a097a686f2ab', 'e00dbf91-7ae8-4f25-963e-1827d7ee7546', '3e43a7a3-034e-44ba-b30e-a87eaf23b8ab', '16fd6fa9-8f7d-4ca7-bdae-6280b5d9a67c', '4dfb679c-06f3-44e2-ac2b-d9130539cc9b', 'e18c42fb-90c3-4e6a-ba03-386c196131c0', 'af6f0744-0679-47d4-8838-db02312cc61e', '95e97af6-24f9-45c1-adc6-5c720eb6fbf0', '28c0477d-2abf-4a2b-90cb-cdb6f2d0ad6b', '3b822f30-7d96-498e-b0b1-cc328735053a', '4510d5bf-ed75-477a-90b4-fea734d3c6ad', '593d7140-efb1-469b-9873-f07b0bddd998', '9f1b42c9-2d8e-47d8-b29d-55e35e4abbe9', '33cde9c1-9e38-4c99-911f-983706356069', 'a6437da4-a9bd-4de8-ad49-9be5fa5e0c1c', '255089eb-b0c0-42c1-b426-d2fc7d566b78', '4b8a9351-05e1-4506-882d-46f2277bfddc', '5e9a31af-b01f-47bc-a932-1d876b32408f', 'cd1f59f0-5726-41d9-96a9-0eb828a7c434', 'd52828dd-a2c2-4297-a7cf-236b86eed338', 'eb70afd2-4525-44d3-84b6-f3379d76078d', 'd99b4238-cd14-48b7-98bb-3a2961542ffe', '0df12ccb-34f6-405f-b884-2ef4be6d2a0c', '24f011b9-1ba6-4ed1-ac32-2dff2b810c66', '7feb382e-d463-49dc-974d-dbdfe8cc0648', '06f98e9e-d9c6-44c5-93b5-7d782ebcee3e', 'e7801d45-7a79-4572-bf51-106d4a508626', '28b8d99e-6d81-4bb9-9290-2ad43ef570f1', 'feadbea9-bb2e-4308-a0ed-c28e165e7381', '659a2bb4-f806-431b-801e-a872c4c3562c', '7f34a2ab-c6e5-4c6a-840e-ca976861ba52', 'a8ebe03a-8563-416b-9bd5-06316f292046', 'aef25eab-57a1-4451-a1d7-3f8a953da31b', '07fe23db-0b8c-4663-8b50-3c555a52472e', '4e3261db-ac3b-404a-8437-c52d958b00bb', 'ea31f538-43c0-4625-a500-7e8b2a9c7173', 'b89aecc1-1fb2-405b-ae8a-347d5a87d296', 'f0d06c30-4b36-4098-a964-c67bf1ef605d', '83b0a3f5-3439-4525-a414-230b2901f003', 'a695b106-b52d-4da8-adb1-49729b7fe68b', 'c3eb1ed6-fb08-4458-9081-4dc807e39b4c', 'fbfc6d82-fe81-43ac-b341-0658282da1a9', 'cde689b8-94fd-45ed-9857-b754eb4458f1', '7afa4924-e118-4294-90ff-d01d9e32b92f', '4b8fa9bc-7d6c-4f16-b0d4-58256a5e1776', 'd0cf75f4-f164-4ea7-b4b0-28a97415f96b', 'd8790638-a795-45e5-9e36-37db35257783', 'e1b16770-ef08-4f52-92b9-a6ac9b08be0b', 'eff9bf25-ac66-4d94-a375-946ad45f2eeb', 'c4e6a2e8-29c8-445d-a9f8-df44e453626e', '81085951-360e-44b9-bfca-74e1f80c1ba6', 'ea87f8f3-1f74-435c-951d-db11759f26ec', 'b4b9d236-8e9c-45f6-b8cb-b6c8bf4801b5', '34a76eee-5bea-4348-84f5-21cb47f8196e', 'ac50645a-1e17-48e9-9031-404c9876b35e', 'c6740732-aef4-4588-9e2f-63fcb8d3b7e7', '8e16773a-3309-476f-8d6a-cd11f52385c9', 'c0186603-aff8-4507-ae6d-11aa557e5f0a', '8c954cec-8e8a-4ec4-9600-9e1f56607c2e', '6b87f20c-ad8b-4647-91d0-af993bc7951f', '80728cb2-2944-4b05-bb01-4248d17b3830', 'ef13adce-e64e-4a0d-9786-89d69cec6f77', 'fed64bc3-ad21-49c1-b91e-6f11377cc799', '1c08f090-4bfe-454b-b62b-2ca53c96abed', 'eb00688e-0b5e-42c3-9a00-f3aec7e1df1a', 'dda85edc-27bb-4c4f-bba4-93f6a3bf2da5']
    get_relevant_thread_ids(user_name="Yogesh Soni", user_preference=user_preference, thread_ids=thread_ids)

if __name__ == "__main__":
    main()