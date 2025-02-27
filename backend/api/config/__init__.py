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
    
class ServerSettings(BaseSettings):
    HOST: str = get_env_variable(var_name="BASE_URL", secret=False)
    PORT: int = get_env_variable(var_name="FASTAPI_PORT", secret=False)
    API_DOMAIN: str = get_env_variable(var_name="API_DOMAIN", secret=False)
    WEBSITE_DOMAIN: str = get_env_variable(var_name="WEBSITE_DOMAIN", secret=False)
    INSTALL_DOMAIN: str = get_env_variable(var_name="INSTALL_DOMAIN", secret=False)
    VITE_SUPERTOKENS_WEBSITE_BASE_PATH: str = get_env_variable(var_name="VITE_SUPERTOKENS_WEBSITE_BASE_PATH", secret=False)


class DatabaseSettings(BaseSettings):
    DB_URL: str = get_env_variable(var_name='DB_URL', secret=True)
    DB_NAME: str = get_env_variable(var_name='DB_NAME', secret=True)
    REDIS_HOST: str = get_env_variable(var_name='REDIS_HOST', secret=True)
    REDIS_PORT: str = get_env_variable(var_name='REDIS_PORT', secret=True)
    REDIS_USERNAME: str = get_env_variable(var_name='REDIS_USERNAME', secret=True)
    REDIS_PASSWORD: str = get_env_variable(var_name='REDIS_PASSWORD', secret=True)
    MILVUS_URI: str = get_env_variable(var_name='MILVUS_URI', secret=True)
    MILVUS_TOKEN: str = get_env_variable(var_name='MILVUS_TOKEN', secret=True)

class OpenAISettings(BaseSettings):
    pass

class ClientSettings(BaseSettings):
    GOOGLE_DESKTOP_CLIENT_SECRET: str = get_env_variable(var_name="GOOGLE_DESKTOP_CLIENT_SECRET", secret=True)
    GOOGLE_DESKTOP_CLIENT_ID: str = get_env_variable(var_name="GOOGLE_DESKTOP_CLIENT_ID", secret=True)

class StorageSettings(BaseSettings):
    STORAGE_ACCESS_KEY_ID: str = get_env_variable(var_name="STORAGE_ACCESS_KEY_ID", secret=True)
    STORAGE_SECRET_ACCESS_KEY: str = get_env_variable(var_name="STORAGE_SECRET_ACCESS_KEY", secret=True)
    STORAGE_ENDPOINT: str = get_env_variable(var_name="STORAGE_ENDPOINT", secret=True)
    STORAGE_BUCKET_NAME: str = get_env_variable(var_name="STORAGE_BUCKET_NAME", secret=True)

class Settings(CommonSettings, ServerSettings, DatabaseSettings, OpenAISettings, ClientSettings, SuperTokensSettings, StorageSettings):
    pass


settings = Settings()

system_cache = redis.Redis(
    host=settings.REDIS_HOST,
    port=settings.REDIS_PORT,
    decode_responses=True,
    username=settings.REDIS_USERNAME,
    password=settings.REDIS_PASSWORD,
    ssl=True
)




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
        #print(f"api domain: {settings.API_DOMAIN} and website domain: {settings.WEBSITE_DOMAIN}")
        #print("Here 1")
        # call the default behaviour as show below
        result = await original_thirdparty_sign_in_up_post(provider, redirect_uri_info, oauth_tokens, tenant_id,
                                                           api_options, user_context)
        #print("Here 2")
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

                third_party_info = result.user.third_party_info.user_id
                #print(f"🔍 Third party info: {third_party_info}")
                third_party_provider = ""
                tenant_id = ""
                if "google" in third_party_info:
                    third_party_provider = "google"
                thirdparty_user_id = ""
                thirdparty_team_id = ""
                #print(f"🔍 Third party provider: {third_party_provider}")
                
                if third_party_provider == "google":
                    split_str = third_party_info.split('|')
                    thirdparty_user_id = split_str[1]
                    # print(thirdparty_user_id)

                    # check if the email id is whitelisted
                    whitelisted_user = await mongodb['whitelisted_users'].find_one({"email": email})
                    if whitelisted_user is None:
                        return GeneralErrorResponse(
                            'Your Google email address is not whitelisted. Please contact support@transcendtech.io')
                    #print("Here 3")
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
        api_base_path=settings.VITE_SUPERTOKENS_WEBSITE_BASE_PATH,
        #api_gateway_path="/api",
        #website_base_path="/auth"
    ),
    supertokens_config=SupertokensConfig(
        
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
            ])
                ),
                
                
        emailpassword.init(),
        dashboard.init(),
        usermetadata.init()
        # userroles.init(),
    ],
    mode='asgi'  # use wsgi if you are running using gunicorn
)
