from pydantic_settings import BaseSettings
from dotenv import load_dotenv
import os
from supertokens_python.recipe.thirdparty.provider import ProviderInput, ProviderConfig, ProviderClientConfig
from supertokens_python.recipe import thirdparty

load_dotenv()


CLIENT_ID="337392647778-99gj0cpsu12dci6uo45f7aue0j7j9rsq.apps.googleusercontent.com"
CLIENT_SECRET="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"
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
        # Inside init
        thirdparty.init(
            sign_in_and_up_feature=thirdparty.SignInAndUpFeature(providers=[
                # We have provided you with development keys which you can use for testing.
                # IMPORTANT: Please replace them with your own OAuth keys for production use.
                ProviderInput(
                    config=ProviderConfig(
                        third_party_id="google",
                        clients=[
                            ProviderClientConfig(
                                client_id=CLIENT_ID,
                                client_secret=CLIENT_SECRET,
                            ),
                        ],
                    ),
                ),
                ProviderInput(
                    config=ProviderConfig(
                        third_party_id="github",
                        clients=[
                            ProviderClientConfig(
                                client_id="467101b197249757c71f",
                                client_secret="e97051221f4b6426e8fe8d51486396703012f5bd",
                            )
                        ],
                    ),
                ),
                ProviderInput(
                    config=ProviderConfig(
                        third_party_id="apple",
                        clients=[
                            ProviderClientConfig(
                                client_id="io.supertokens.example.service",
                                additional_config={
                                    "keyId": "7M48Y4RYDL",
                                    "privateKey": "-----BEGIN PRIVATE KEY-----\nMIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgu8gXs+XYkqXD6Ala9Sf/iJXzhbwcoG5dMh1OonpdJUmgCgYIKoZIzj0DAQehRANCAASfrvlFbFCYqn3I2zeknYXLwtH30JuOKestDbSfZYxZNMqhF/OzdZFTV0zc5u5s3eN+oCWbnvl0hM+9IW0UlkdA\n-----END PRIVATE KEY-----",
                                    "teamId": "YWQCXGJRJL"
                                },
                            ),
                        ],
                    ),
                ),
            ])
        ),
        emailpassword.init(),
        dashboard.init(),
        #userroles.init(),
    ],
    mode='asgi' # use wsgi if you are running using gunicorn
)




