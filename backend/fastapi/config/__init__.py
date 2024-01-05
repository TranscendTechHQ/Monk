from pydantic_settings import BaseSettings
from dotenv import load_dotenv
import os

load_dotenv()

class CommonSettings(BaseSettings):
    APP_NAME: str = "Monk"
    DEBUG_MODE: bool = os.getenv("DEBUG_MODE") == "True"


class ServerSettings(BaseSettings):
    HOST: str = "0.0.0.0"
    PORT: int = 8000


class DatabaseSettings(BaseSettings):
    DB_URL: str = os.getenv("DB_URL")
    DB_NAME: str = os.getenv("DB_NAME")


class Settings(CommonSettings, ServerSettings, DatabaseSettings):
    pass


settings = Settings()



from supertokens_python import init, InputAppInfo, SupertokensConfig
from supertokens_python.recipe import emailpassword, session
from supertokens_python.recipe import dashboard

init(
    app_info=InputAppInfo(
        app_name="Monk",
        api_domain="http://localhost:8000",
        website_domain="http://localhost:8000",
        api_base_path="/auth",
        website_base_path="/auth"
    ),
    supertokens_config=SupertokensConfig(
        # https://try.supertokens.com is for demo purposes. Replace this with the address of your core instance (sign up on supertokens.com), or self host a core.
        #connection_uri="https://try.supertokens.com",
        connection_uri="http://localhost:3567/",
        #connection_uri="http://supertokens:3567",
        # api_key=<API_KEY(if configured)>
    ),
    framework='fastapi',
    recipe_list=[
        session.init(), # initializes session features
        emailpassword.init(),
        dashboard.init(),
        userroles.init(),
    ],
    mode='asgi' # use wsgi if you are running using gunicorn
)