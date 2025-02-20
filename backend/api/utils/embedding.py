from openai import AzureOpenAI

from config import settings


def generate_embedding(text):
    client = AzureOpenAI(
        api_key="",
        api_version="",
        azure_endpoint=""
    )

    response = client.embeddings.create(
        input=text,
        model="" # model = "deployment_name".
    )
    embedding = response.data[0].embedding
    # print(embedding)
    return embedding
    # print(response.model_dump_json(indent=2))
