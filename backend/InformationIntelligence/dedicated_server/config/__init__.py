import os

from dotenv import load_dotenv

load_dotenv()

PYTHONPATH = os.getenv("PYTHONPATH")

class Settings:
    DEBUG = os.getenv("DEBUG", False)
    HOST = os.getenv("HOST", "0.0.0.0")
    PORT = os.getenv("PORT", 8889)
    MONGO_CONNECTION_STRING = os.getenv("MONGO_CONNECTION_STRING")
    DB_NAME = os.getenv("DB_NAME")
    CLOUDFLARE_ACCOUNT_ID = os.getenv("CLOUDFLARE_ACCOUNT_ID")
    CLOUDFLARE_AUTH_TOKEN = os.getenv("CLOUDFLARE_AUTH_TOKEN")
    MISTRAL_API_KEY = os.getenv("MISTRAL_API_KEY")
    RELEVANCE_API_KEY = os.getenv("RELEVANCE_API_KEY")
    HF_ACCESS_TOKEN = os.getenv("HF_ACCESS_TOKEN")
    LLM_ENDPOINT = os.getenv("LLM_ENDPOINT")
    LLM_API_KEY = os.getenv("LLM_API_KEY")
    LLM_MODEL = os.getenv("LLM_MODEL")
    
    
settings = Settings()
