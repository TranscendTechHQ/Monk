from pydantic_settings import BaseSettings
from dotenv import load_dotenv
import os
from supertokens_python.recipe.thirdparty.provider import ProviderInput, ProviderConfig, ProviderClientConfig
from supertokens_python.recipe import thirdparty
from supertokens_python import init, InputAppInfo, SupertokensConfig
from supertokens_python.recipe import emailpassword, session
from supertokens_python.recipe import dashboard
from supertokens_python.recipe import usermetadata


from supertokens_python.types import GeneralErrorResponse
from supertokens_python.recipe.thirdparty.interfaces import APIInterface, APIOptions, SignInUpPostOkResult, SignInUpPostNoEmailGivenByProviderResponse
from typing import Optional, Union, Dict, Any
from supertokens_python.recipe.thirdparty.provider import Provider, RedirectUriInfo
from supertokens_python.recipe.usermetadata.asyncio import update_user_metadata
from motor.motor_asyncio import AsyncIOMotorClient




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

class OpenAISettings(BaseSettings):
    AZURE_OPENAI_KEY: str = os.getenv("AZURE_OPENAI_KEY")
    AZURE_OPENAI_ENDPOINT: str = os.getenv("AZURE_OPENAI_ENDPOINT")
    AZURE_OPENAI_EMB_DEPLOYMENT: str = os.getenv("AZURE_OPENAI_EMB_DEPLOYMENT")
    API_VERSION: str = os.getenv("AZURE_OPENAPI_API_VERSION")
    AZURE_OPENAI_GPT_DEPLOYEMENT: str = os.getenv("AZURE_OPENAI_GPT_DEPLOYEMENT")
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY")
    OPENAI_API_VERSION: str = os.getenv("OPENAI_API_VERSION")
    OPENAI_API_ENDPOINT: str = os.getenv("OPENAI_API_ENDPOINT")
    OPEN_API_GPT_MODEL: str = os.getenv("OPEN_API_GPT_MODEL")
    
class Settings(CommonSettings, ServerSettings, DatabaseSettings, OpenAISettings):
    pass


settings = Settings()




def override_thirdparty_apis(original_implementation: APIInterface):
    original_thirdparty_sign_in_up_post = original_implementation.sign_in_up_post
    
    async def thirdparty_sign_in_up_post(
        provider: Provider,
        redirect_uri_info: Optional[RedirectUriInfo],
        oauth_tokens: Optional[Dict[str, Any]],
        tenant_id: str,
        api_options: APIOptions,
        user_context: Dict[str, Any]
    ) -> Union[
        SignInUpPostOkResult,
        SignInUpPostNoEmailGivenByProviderResponse,
        GeneralErrorResponse,
    ]:
        # call the default behaviour as show below
        result = await original_thirdparty_sign_in_up_post(provider, redirect_uri_info, oauth_tokens, tenant_id, api_options, user_context)
        
        if isinstance(result, SignInUpPostOkResult):
            #print(result.user)

            # This is the response from the OAuth tokens provided by the third party provider
            #print(result.oauth_tokens["access_token"])
            # other tokens like the refresh_token or id_token are also 
            # available in the OAuthTokens object.

            # This gives the user's info as returned by the provider's user profile endpoint.
            if result.raw_user_info_from_provider.from_user_info_api is not None:
                #print(result.raw_user_info_from_provider.from_user_info_api['name'])
                user_id = result.user.user_id
                user_name = result.raw_user_info_from_provider.from_user_info_api['name']
                user_picture = result.raw_user_info_from_provider.from_user_info_api['picture']
                #email = result.raw_user_info_from_provider.from_user_info_api['email']
                email = result.user.email
                mongodb_client = AsyncIOMotorClient(settings.DB_URL)
                mongodb = mongodb_client[settings.DB_NAME]
                
                mongodb_users = mongodb["users"]
                update_result = await mongodb_users.update_one({"_id": user_id}, 
                                                               {"$set": {"user_name": user_name, 
                                                                         "user_picture": user_picture,
                                                                         "email": email}}, upsert=True)
                
                #await update_user_metadata(user_id=user_id, metadata_update={
                 #   "user_name": user_name
                #})
            # This gives the user's info from the returned ID token 
            # if the provider gave us an ID token
            #if result.raw_user_info_from_provider.from_id_token_payload is not None:
             #   print(result.raw_user_info_from_provider.from_id_token_payload["name"])
        
        return result

    original_implementation.sign_in_up_post = thirdparty_sign_in_up_post
    return original_implementation



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
            override=thirdparty.InputOverrideConfig(
                apis=override_thirdparty_apis
            ),
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
        usermetadata.init()
        #userroles.init(),
    ],
    mode='asgi' # use wsgi if you are running using gunicorn
)




