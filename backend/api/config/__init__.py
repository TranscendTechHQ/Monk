import os
import uuid
from time import sleep
from typing import Optional, Union, Dict, Any

from dotenv import load_dotenv
from fastapi.encoders import jsonable_encoder
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic_settings import BaseSettings
from supertokens_python import init, InputAppInfo, SupertokensConfig
from supertokens_python.recipe import dashboard
from supertokens_python.recipe import emailpassword, session
from supertokens_python.recipe import thirdparty
from supertokens_python.recipe import usermetadata
from supertokens_python.recipe.thirdparty.interfaces import APIInterface, APIOptions, SignInUpPostOkResult, \
    SignInUpPostNoEmailGivenByProviderResponse
from supertokens_python.recipe.thirdparty.provider import Provider, RedirectUriInfo
from supertokens_python.recipe.thirdparty.provider import ProviderInput, ProviderConfig, ProviderClientConfig
from supertokens_python.types import GeneralErrorResponse

# from utils.db import create_mongo_document
from utils.hashicorp_api import get_access_token, get_secret
import redis

load_dotenv()
HCP_ACCESS_TOKEN = get_access_token()
while not HCP_ACCESS_TOKEN:
    sleep(0.2)

HCP_SECRET_RESPONSE = get_secret(HCP_ACCESS_TOKEN)

def get_env_variable(var_name:str, secret:bool, default = None):
    if secret:
        return HCP_SECRET_RESPONSE[var_name]
    return os.getenv(var_name, default=default)

class SuperTokensSettings(BaseSettings):
    SUPERTOKENS_CORE_CONNECTION_URI: str = get_env_variable(var_name="SUPERTOKENS_CORE_CONNECTION_URI", secret=True)
    SUPERTOKENS_CORE_API_KEY: str = get_env_variable(var_name="SUPERTOKENS_CORE_API_KEY", secret=True)


class CommonSettings(BaseSettings):
    APP_NAME: str = "Monk"
    DEBUG_MODE: bool = get_env_variable(var_name="DEBUG_MODE", secret=False, default=True)
    RELEVANCE_API_KEY: str = get_env_variable(var_name="RELEVANCE_API_KEY", secret=False)
    RELEVANCE_URL: str = get_env_variable(var_name="RELEVANCE_URL", secret=False)

class ServerSettings(BaseSettings):
    HOST: str = "0.0.0.0"
    PORT: int = get_env_variable(var_name="FASTAPI_PORT", secret=False, default=8001)
    API_DOMAIN: str = get_env_variable(var_name="API_DOMAIN", secret=False, default="http://localhost:8001")
    WEBSITE_DOMAIN: str = get_env_variable(var_name="WEBSITE_DOMAIN", secret=False, default="http://localhost:3000")
    INSTALL_DOMAIN: str = get_env_variable(var_name="INSTALL_DOMAIN", secret=False, default="http://localhost:3000")


class DatabaseSettings(BaseSettings):
    DB_URL: str = get_env_variable(var_name='DB_URL', secret=True)
    DB_NAME: str = get_env_variable(var_name='DB_NAME', secret=True)
    REDIS_HOST: str = get_env_variable(var_name='REDIS_HOST', secret=False)
    REDIS_PORT: str = get_env_variable(var_name='REDIS_PORT', secret=False)
    REDIS_USERNAME: str = get_env_variable(var_name='REDIS_USERNAME', secret=False)
    REDIS_PASSWORD: str = get_env_variable(var_name='REDIS_PASSWORD', secret=False)


class OpenAISettings(BaseSettings):
    AZURE_OPENAI_KEY: str = get_env_variable(var_name='AZURE_OPENAI_KEY', secret=True)
    AZURE_OPENAI_ENDPOINT: str = get_env_variable(var_name='AZURE_OPENAI_ENDPOINT', secret=True)
    AZURE_OPENAI_EMB_DEPLOYMENT: str = get_env_variable(var_name="AZURE_OPENAI_EMB_DEPLOYMENT", secret=False)
    API_VERSION: str = get_env_variable(var_name="AZURE_OPENAPI_API_VERSION", secret=False)
    AZURE_OPENAI_GPT_DEPLOYEMENT: str = get_env_variable(var_name="AZURE_OPENAI_GPT_DEPLOYEMENT", secret=False)
    OPENAI_API_KEY: str = get_env_variable(var_name="OPENAI_API_KEY", secret=True)
    OPENAI_API_VERSION: str = get_env_variable(var_name="OPENAI_API_VERSION", secret=False)
    OPENAI_API_ENDPOINT: str = get_env_variable(var_name="OPENAI_API_ENDPOINT", secret=False)
    OPEN_API_GPT_MODEL: str = get_env_variable(var_name="OPEN_API_GPT_MODEL", secret=False)


class ClientSettings(BaseSettings):
    GOOGLE_CLIENT_ID: str = get_env_variable(var_name="GOOGLE_CLIENT_ID", secret=False)
    GOOGLE_CLIENT_SECRET: str = get_env_variable(var_name="GOOGLE_CLIENT_SECRET", secret=True)
    SLACK_CLIENT_ID: str = get_env_variable(var_name="SLACK_CLIENT_ID", secret=False)
    SLACK_CLIENT_SECRET: str = get_env_variable(var_name="SLACK_CLIENT_SECRET", secret=True)
    AUTH0_CLIENT_ID: str = get_env_variable(var_name="AUTH0_CLIENT_ID", secret=True)
    AUTH0_CLIENT_SECRET: str = get_env_variable(var_name="AUTH0_CLIENT_SECRET", secret=True)
    FRONTEND_CLIENT_ID: str = get_env_variable(var_name="FRONTEND_CLIENT_ID", secret=False)
    BACKEND_CLIENT_ID: str = get_env_variable(var_name="BACKEND_CLIENT_ID", secret=False)
    BACKEND_CLIENT_SECRET: str = get_env_variable(var_name="BACKEND_CLIENT_SECRET", secret=True)
    SLACK_BOT_TOKEN: str = get_env_variable(var_name="SLACK_BOT_TOKEN", secret=True)
    SLACK_USER_TOKEN: str = get_env_variable(var_name="SLACK_USER_TOKEN", secret=True)
    GOOGLE_DESKTOP_CLIENT_SECRET: str = get_env_variable(var_name="GOOGLE_DESKTOP_CLIENT_SECRET", secret=False)
    GOOGLE_DESKTOP_CLIENT_ID: str = get_env_variable(var_name="GOOGLE_DESKTOP_CLIENT_ID", secret=False)

class StorageSettings(BaseSettings):
    STORAGE_ACCESS_KEY_ID: str = get_env_variable(var_name="STORAGE_ACCESS_KEY_ID", secret=True)
    STORAGE_SECRET_ACCESS_KEY: str = get_env_variable(var_name="STORAGE_SECRET_ACCESS_KEY", secret=True)
    STORAGE_ENDPOINT: str = get_env_variable(var_name="STORAGE_ENDPOINT", secret=False)
    STORAGE_DOMAIN: str = get_env_variable(var_name="STORAGE_DOMAIN", secret=False)


class Settings(CommonSettings, ServerSettings, DatabaseSettings, OpenAISettings, ClientSettings, SuperTokensSettings, StorageSettings):
    pass


settings = Settings()

system_cache = redis.Redis(
    host=settings.REDIS_HOST,
    port=settings.REDIS_PORT,
    decode_responses=True,
    username=settings.REDIS_USERNAME,
    password=settings.REDIS_PASSWORD,
)

BACKEND_CLIENT_ID = settings.BACKEND_CLIENT_ID
BACKEND_CLIENT_SECRET = settings.BACKEND_CLIENT_SECRET
FRONTEND_CLIENT_ID = settings.FRONTEND_CLIENT_ID
SLACK_CLIENT_ID = settings.SLACK_CLIENT_ID
SLACK_CLIENT_SECRET = settings.SLACK_CLIENT_SECRET
AUTH0_CLIENT_ID = settings.AUTH0_CLIENT_ID
AUTH0_CLIENT_SECRET = settings.AUTH0_CLIENT_SECRET


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
        result = await original_thirdparty_sign_in_up_post(provider, redirect_uri_info, oauth_tokens, tenant_id,
                                                           api_options, user_context)
        # print(result.user.email)
        if isinstance(result, SignInUpPostOkResult):
            # print(result.user)

            # This is the response from the OAuth tokens provided by the third party provider
            # print(result.oauth_tokens["access_token"])
            # other tokens like the refresh_token or id_token are also
            # available in the OAuthTokens object.

            # This gives the user's info as returned by the provider's user profile endpoint.
            if result.raw_user_info_from_provider.from_user_info_api is not None:
                # print(result.raw_user_info_from_provider.from_user_info_api['name'])
                super_token_id = result.user.user_id
                name = result.raw_user_info_from_provider.from_user_info_api['name']
                picture = result.raw_user_info_from_provider.from_user_info_api['picture']
                # email = result.raw_user_info_from_provider.from_user_info_api['email']
                email = result.user.email
                mongodb_client = AsyncIOMotorClient(settings.DB_URL)
                mongodb = mongodb_client[settings.DB_NAME]
                mongodb_users = mongodb["users"]

                # print(result.user.user_id)
                # print(result.user.third_party_info.user_id) # this gives out output like oauth2|sign-in-with-slack|T048F0ANS1M-U066Q9JAU3B, google-oauth2|101162861063367124308
                third_party_info = result.user.third_party_info.user_id
                print(f"🔍 Third party info: {third_party_info}")
                third_party_provider = ""
                tenant_id = ""
                if "slack" in third_party_info:
                    third_party_provider = "slack"
                elif "google" in third_party_info:
                    third_party_provider = "google"
                thirdparty_user_id = ""
                thirdparty_team_id = ""
                print(f"🔍 Third party provider: {third_party_provider}")
                if third_party_provider == "slack":
                    split_str = third_party_info.split('|')
                    ids = split_str[2].split('-')
                    thirdparty_user_id = ids[1]
                    # print(thirdparty_user_id)
                    thirdparty_team_id = ids[0]
                    tenant_id = ids[0]
                    existing_slack_tenant = await mongodb["tenants"].find_one({"tenant_id": tenant_id})
                    if existing_slack_tenant is None:
                        return GeneralErrorResponse(
                            'Your Slack workspace is not whitelisted. Please contact your workspace admin to install Monk bot. If you are the admin, please visit https://install.heymonk.app')
                elif third_party_provider == "google":
                    split_str = third_party_info.split('|')
                    thirdparty_user_id = split_str[1]
                    # print(thirdparty_user_id)

                    # check if the email id is whitelisted
                    whitelisted_user = await mongodb['whitelisted_users'].find_one({"email": email})
                    if whitelisted_user is None:
                        return GeneralErrorResponse(
                            'Your Google email address is not whitelisted. Please contact support@transcendtech.io')

                    #tenant_id = whitelisted_user['tenant_id']
                    tenant_id = "T048F0ANS1M" # TODO: Remove this
                    print(f"🔍 Tenant id: {tenant_id}")
                    tenant_name = "Tenant:" + tenant_id
                    tenants_collection = mongodb["tenants"]
                    old_tenant = await tenants_collection.find_one({"tenant_name": tenant_name})
                    if old_tenant:
                        tenant_id = old_tenant['tenant_id']
                    else:
                        tenant = {}

                        tenant["tenant_id"] = tenant_id
                        tenant["tenant_name"] = tenant_name
                        tenant["user_id"] = result.user.user_id
                        tenant["user_token"] = result.oauth_tokens['access_token']
                        # tenant["bot_user_id"] = token_data["bot_user_id"]
                        # tenant["bot_token"] = token_data["access_token"]
                        tenant["token_response"] = result.to_json()

                        await tenants_collection.insert_one(tenant)

                user = await mongodb_users.find_one({"super_token_id": super_token_id})
                if not user:
                    user = await mongodb_users.find_one({"email": email, "tenant_id": tenant_id})
                    if not user:
                        update_result = await mongodb_users.update_one({"super_token_id": super_token_id},
                                                                       {"$set":
                                                                           {
                                                                               "_id": super_token_id,
                                                                               "name": name,
                                                                               "picture": picture,
                                                                               "email": email,
                                                                               "tenant_id": tenant_id,
                                                                               "thirdparty_provider": third_party_provider,
                                                                               "thirdparty_user_id": thirdparty_user_id,
                                                                               "thirdparty_team_id": thirdparty_team_id,

                                                                           }}, upsert=True)
                        return result

                    update_result = await mongodb_users.update_one({"_id": user["_id"]},
                                                                   {"$set":
                                                                       {
                                                                           "name": name,
                                                                           "picture": picture,
                                                                           "email": email,
                                                                           "tenant_id": tenant_id,
                                                                           "super_token_id": super_token_id,
                                                                           "thirdparty_provider": third_party_provider,
                                                                           "thirdparty_user_id": thirdparty_user_id,
                                                                           "thirdparty_team_id": thirdparty_team_id,

                                                                       }}, upsert=True)

                # await update_user_metadata(user_id=user_id, metadata_update={
                #   "name": name
                # })
            # This gives the user's info from the returned ID token
            # if the provider gave us an ID token
            # if result.raw_user_info_from_provider.from_id_token_payload is not None:
            #   print(result.raw_user_info_from_provider.from_id_token_payload["name"])

        return result

    original_implementation.sign_in_up_post = thirdparty_sign_in_up_post
    return original_implementation


init(
    app_info=InputAppInfo(
        app_name="Monk",
        api_domain=settings.API_DOMAIN,
        website_domain=settings.WEBSITE_DOMAIN,
        api_base_path="/auth",
        website_base_path="/auth"
    ),
    supertokens_config=SupertokensConfig(
        # connection_uri="http://localhost:3567/",
        connection_uri=settings.SUPERTOKENS_CORE_CONNECTION_URI,
        api_key=settings.SUPERTOKENS_CORE_API_KEY
    ),
    framework='fastapi',
    recipe_list=[
        session.init(),  # initializes session features
        # Inside init
        thirdparty.init(
            override=thirdparty.InputOverrideConfig(
                apis=override_thirdparty_apis
            ),
            sign_in_and_up_feature=thirdparty.SignInAndUpFeature(providers=[

                # When frontend sends auth code using signinup API,
                # use BACKEND_CLIENT_ID and BACKEND_CLIENT_SECRET
                # to exchange the auth code for access token
                # When frontend sends access token using signinup API,
                # use FRONTEND_CLIENT_ID to validate the access token
                ProviderInput(
                    config=ProviderConfig(
                        third_party_id="google_authcode",
                        clients=[
                            ProviderClientConfig(
                                client_id=BACKEND_CLIENT_ID,
                                client_secret=BACKEND_CLIENT_SECRET,
                                scope=["openid", "email", "profile"],
                            ),
                        ],
                        authorization_endpoint="https://accounts.google.com/o/oauth2/v2/auth",

                        token_endpoint="https://oauth2.googleapis.com/token",

                        user_info_endpoint="https://openidconnect.googleapis.com/v1/userinfo",
                        jwks_uri="https://www.googleapis.com/oauth2/v3/certs",

                        oidc_discovery_endpoint="https://accounts.google.com",
                    ),
                ),
                ProviderInput(
                    config=ProviderConfig(
                        third_party_id="google",
                        clients=[
                            ProviderClientConfig(

                                client_id=settings.GOOGLE_DESKTOP_CLIENT_ID,
                                # client_id=BACKEND_CLIENT_ID,
                                #client_secret=BACKEND_CLIENT_SECRET,
                                client_secret=settings.GOOGLE_DESKTOP_CLIENT_SECRET,
                                scope=["openid", "email", "profile"],
                            ),
                        ],
                        authorization_endpoint="https://accounts.google.com/o/oauth2/v2/auth",
                        # authorization_endpoint_query_params={
                        #    "someKey1": "value1",
                        #    "someKey2": None,
                        # },
                        token_endpoint="https://oauth2.googleapis.com/token",
                        # token_endpoint_body_params={
                        #    "someKey1": "value1",
                        # },
                        user_info_endpoint="https://openidconnect.googleapis.com/v1/userinfo",
                        jwks_uri="https://www.googleapis.com/oauth2/v3/certs",
                        # user_info_map=UserInfoMap(
                        #    from_id_token_payload=UserFields(
                        #        user_id="id",
                        #        email="email",
                        #        email_verified="email_verified",
                        #    ),
                        #    from_user_info_api=UserFields(),
                        # ),
                        oidc_discovery_endpoint="https://accounts.google.com",
                    ),
                ),
                ProviderInput(
                    config=ProviderConfig(
                        third_party_id="auth0",
                        clients=[
                            ProviderClientConfig(
                                client_id=AUTH0_CLIENT_ID,
                                client_secret=AUTH0_CLIENT_SECRET,
                                scope=["openid", "email", "profile"],

                            ),
                        ],
                        authorization_endpoint="https://dev-17s0i0aukvst4yiv.us.auth0.com/authorize",
                        # authorization_endpoint_query_params={
                        #    "someKey1": "value1",
                        #    "someKey2": None,
                        # },
                        token_endpoint="https://dev-17s0i0aukvst4yiv.us.auth0.com/oauth/token",
                        # token_endpoint_body_params={
                        #    "someKey1": "value1",
                        # },
                        user_info_endpoint="https://dev-17s0i0aukvst4yiv.us.auth0.com/userinfo",
                        jwks_uri="https://dev-17s0i0aukvst4yiv.us.auth0.com/.well-known/jwks.json",
                        # user_info_map=UserInfoMap(
                        #    from_id_token_payload=UserFields(
                        #        user_id="id",
                        #        email="email",
                        #        email_verified="email_verified",
                        #    ),
                        #    from_user_info_api=UserFields(),
                        # ),
                        oidc_discovery_endpoint="https://dev-17s0i0aukvst4yiv.us.auth0.com",
                    ),
                ),
                ProviderInput(
                    config=ProviderConfig(
                        third_party_id="slack",
                        name="Slack Provider",
                        clients=[
                            ProviderClientConfig(
                                client_id=settings.SLACK_CLIENT_ID,
                                client_secret=settings.SLACK_CLIENT_SECRET,
                                scope=["openid", "email", "profile"],
                            ),
                        ],
                        oidc_discovery_endpoint="https://slack.com",

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
        # userroles.init(),
    ],
    mode='asgi'  # use wsgi if you are running using gunicorn
)
