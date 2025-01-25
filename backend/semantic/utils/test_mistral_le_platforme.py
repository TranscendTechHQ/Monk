import os
from mistralai.client import MistralClient
from mistralai.models.chat_completion import ChatMessage



def get_mistral_response_one_shot(system: str, user: str):
    os.environ["MISTRAL_API_KEY"] = "9ydSeTQ8EdgeL5jnjOe29fcGduTX5gpO"
    api_key = os.environ["MISTRAL_API_KEY"]
    model = "mistral-small-latest"

    client = MistralClient(api_key=api_key)

    chat_response = client.chat(
        model=model,
        messages=[ChatMessage(role="system", content=system),
                  ChatMessage(role="user", content=user)
                  ],
        #temperature = 0.7,
        #top_p = 1,
        #max_tokens = 512,
        
    )
    
    print(chat_response.choices[0].message.content)
        
    result = chat_response.json()
    return result

def main():
    system = """
    you are expert at analyzing conversations.
user will give you a few topics with associated messages and
senders. Then he will give you a new message with sender.
You have to determine which topic does the new message belong
to. You can consider the how the new conversation is related
to the topics and also the message sender.
Give the final output in the following format:
new_message: <suggested topic>
reason: reason which this message belongs to the suggested topic
    """
    user = """
    Topic 1 Bob: Go programming is great for building web server
Tom:I agree. However it has a steep learning curve  Topic 2 J
on: who is working on the clustering problem? Robert: Taras
New message Bob: Yes.
    """
    print(get_mistral_response_one_shot(system, user))

if __name__ == "__main__":
    main()