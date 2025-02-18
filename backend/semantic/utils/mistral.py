import os
import requests
from config import settings
CLOUDFLARE_ACCOUNT_ID = settings.CLOUDFLARE_ACCOUNT_ID
CLOUDFLARE_AUTH_TOKEN = os.environ.get("CLOUDFLARE_CLOUDFLARE_AUTH_TOKEN")

def get_mistral_response_one_shot(system: str, user: str):
    
    response = requests.post(
    f"https://api.cloudflare.com/client/v4/accounts/{CLOUDFLARE_ACCOUNT_ID}/ai/run/@hf/mistral/mistral-7b-instruct-v0.2",
        headers={"Authorization": f"Bearer {CLOUDFLARE_AUTH_TOKEN}"},
        json={
        "messages": [
            {"role": "system", "content": system },
            {"role": "user", "content": user}
        ]
        }
    )
    result = response.json()
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