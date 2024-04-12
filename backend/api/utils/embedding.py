from openai import AzureOpenAI

from config import settings


def generate_embedding(text):
    client = AzureOpenAI(
        api_key=settings.AZURE_OPENAI_KEY,
        api_version=settings.API_VERSION,
        azure_endpoint=settings.AZURE_OPENAI_ENDPOINT
    )

    response = client.embeddings.create(
        input=text,
        model=settings.AZURE_OPENAI_EMB_DEPLOYMENT  # model = "deployment_name".
    )
    embedding = response.data[0].embedding
    # print(embedding)
    return embedding
    # print(response.model_dump_json(indent=2))
