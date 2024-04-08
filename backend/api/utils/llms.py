import os

# Define prompt
from langchain_openai import ChatOpenAI
from openai import AzureOpenAI
from openai import OpenAI

from config import settings


def azure_openai():
    # Set your Azure-specific OpenAI API key and endpoint
    llm = AzureOpenAI(
        api_key=settings.AZURE_OPENAI_KEY,
        api_version=settings.API_VERSION,
        azure_endpoint=settings.AZURE_OPENAI_ENDPOINT
    )
    return llm


def langchain_openai():
    # Define LLM chain
    os.environ["OPENAI_API_KEY"] = settings.OPENAI_API_KEY
    os.environ["OPENAI_API_ENDPOINT"] = settings.OPENAI_API_ENDPOINT
    os.environ["OPENAI_API_VERSION"] = settings.OPENAI_API_VERSION
    llm = ChatOpenAI(temperature=0, model_name=settings.OPEN_API_GPT_MODEL)
    return llm


def openai():
    # Set your OpenAI API key and endpoint
    llm = OpenAI(
        api_key=settings.OPENAI_API_KEY
    )
    return llm
