from datetime import datetime
import os
import uuid
from time import sleep
from typing import Optional, Union, Dict, Any, List

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
from supertokens_python.recipe.emailpassword import InputSignUpFeature, InputFormField
from supertokens_python.recipe.emailpassword.interfaces import APIInterface as EmailPasswordAPIInterface
from supertokens_python.recipe.emailpassword.interfaces import APIOptions as EmailPasswordAPIOptions
from supertokens_python.recipe.emailpassword.interfaces import SignUpPostOkResult

# from utils.db import create_mongo_document
from utils.hashicorp_api import get_access_token, get_secret
import redis


import traceback
import sys
import logging

# Load logging config at the start

CONFIG_DIR = os.path.dirname(os.path.abspath(__file__))  # Gets /backend/api/config/
logging.config.fileConfig(os.path.join(CONFIG_DIR, 'logging.conf'), disable_existing_loggers=False)


logger = logging.getLogger(__name__)

def custom_exception_handler(exc_type, exc_value, exc_traceback):
    # Filter the stack trace to include only frames from your project
    filtered_traceback = [
        frame for frame in traceback.extract_tb(exc_traceback)
        if "/backend/" in frame.filename  and "/backend/.venv/" not in frame.filename
    ]
    
    # Print the filtered stack trace
    logger.error("Filtered Traceback (most recent call last):")
    for frame in filtered_traceback:
        logger.error(f'  File "{frame.filename}", line {frame.lineno}, in {frame.name}')
        logger.error(f'    {frame.line}')
    
    # Print the exception type and message
    logger.error(f"{exc_type.__name__}: {exc_value}")

# Set the custom exception handler
sys.excepthook = custom_exception_handler

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
    SUPERTOKENS_CORE_CONNECTION_URI: str = get_env_variable(var_name="SUPERTOKENS_CORE_CONNECTION_URI", secret=True, default="http://supertokens:3567")
    SUPERTOKENS_CORE_API_KEY: str = get_env_variable(var_name="SUPERTOKENS_CORE_API_KEY", secret=True, default="")


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

# Shared function for tenant assignment and user creation/update
async def assign_tenant_to_user(
    email: str, 
    super_token_id: str, 
    name: str, 
    auth_method: str, 
    picture: str = ""
) -> Union[str, GeneralErrorResponse]:
    """
    Assigns a tenant to a user and creates/updates the user in MongoDB.
    
    Args:
        email: User's email address
        super_token_id: SuperTokens user ID
        name: User's name
        auth_method: Authentication method (e.g., "google", "email")
        picture: URL to user's profile picture (optional)
        
    Returns:
        tenant_id if successful, GeneralErrorResponse if email not whitelisted
    """
    try:
        logger.debug(f"Assigning tenant to user: {email}, {super_token_id}, {name}, {auth_method}, {picture}")
        # Connect to MongoDB
        mongodb_client = AsyncIOMotorClient(settings.DB_URL)
        mongodb = mongodb_client[settings.DB_NAME]
        mongodb_users = mongodb["users"]
        
        # Check if the email is whitelisted
        #whitelisted_user = await mongodb['whitelisted_users'].find_one({"email": email})
        #if whitelisted_user is None:
        #    return GeneralErrorResponse(
        #        f'Your {auth_method} email address is not whitelisted. Please contact support@transcendtech.io')
        
        # Assign tenant ID
        tenant_id = "T048F0ANS1M"  # TODO: Make this dynamic
        logger.info(f"🔍 Assigning tenant id {tenant_id} to {auth_method} user: {email}")
        
        # Create or get tenant
        tenant_name = "Tenant:" + tenant_id
        tenants_collection = mongodb["tenants"]


        # Create tenant if it doesn't exist
        tenant = {}
        tenant['tenant_id'] = tenant_id
        tenant['tenant_name'] = tenant_name
        
        
        await tenants_collection.update_one({"tenant_id": tenant_id}, {"$set": tenant}, upsert=True)
        
        
        # Create or update user in MongoDB
        user_data = {
            "_id": super_token_id,
            "super_token_id": super_token_id,
            "email": email,
            "name": name,
            "tenant_id": tenant_id,
            "picture": picture,
            "auth_method": auth_method,
            "last_login": datetime.now().isoformat()
        }
        
        logger.debug(f"Updating user: {user_data}")
        await mongodb_users.update_one({"email": email}, {"$set": user_data}, upsert=True)
        
        logger.info(f"✅ Successfully assigned tenant {tenant_id} to {auth_method} user {email}")
        return tenant_id
        
    except Exception as e:
        custom_exception_handler(type(e), e, e.__traceback__)
        # Return the error but don't prevent user creation
        return tenant_id

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
        # Call the default behaviour
        result = await original_thirdparty_sign_in_up_post(provider, redirect_uri_info, oauth_tokens, tenant_id,
                                                           api_options, user_context)
        
        if isinstance(result, SignInUpPostOkResult):
            # Extract user information from the result
            if result.raw_user_info_from_provider.from_user_info_api is not None:
                super_token_id = result.user.user_id
                name = result.raw_user_info_from_provider.from_user_info_api['name']
                picture = result.raw_user_info_from_provider.from_user_info_api['picture']
                email = result.user.email
                
                third_party_info = result.user.third_party_info.user_id
                third_party_provider = ""
                
                if "google" in third_party_info:
                    third_party_provider = "google"
                    
                    # For Google authentication
                    if third_party_provider == "google":
                        # Assign tenant to user
                        tenant_result = await assign_tenant_to_user(
                            email=email,
                            super_token_id=super_token_id,
                            name=name,
                            auth_method="google",
                            picture=picture
                        )
                        
                        # If there was an error with tenant assignment
                        if isinstance(tenant_result, GeneralErrorResponse):
                            return tenant_result

        return result

    original_implementation.sign_in_up_post = thirdparty_sign_in_up_post
    return original_implementation


def override_emailpassword_apis(original_implementation: EmailPasswordAPIInterface):
    original_sign_up_post = original_implementation.sign_up_post

    async def sign_up_post(
            form_fields: List[Dict[str, Any]],
            tenant_id: str,
            api_options: EmailPasswordAPIOptions,
            user_context: Dict[str, Any]
    ) -> Union[SignUpPostOkResult, GeneralErrorResponse]:
        # Call the original implementation first
        result = await original_sign_up_post(form_fields, tenant_id, api_options, user_context)
        logger.debug(f"Sign up post result: {result}")
        if isinstance(result, SignUpPostOkResult):
            try:
                # Extract user information
                super_token_id = result.user.user_id
                email = result.user.email
                
                # Get name from form fields if provided
                name = ""
                for field in form_fields:
                    if field.id == "name":
                        name = field.value
                        break
                
                # Assign tenant to user
                tenant_result = await assign_tenant_to_user(
                    email=email,
                    super_token_id=super_token_id,
                    name=name,
                    auth_method="email"
                )
                
                # If there was an error with tenant assignment
                if isinstance(tenant_result, GeneralErrorResponse):
                    return tenant_result
                    
            except Exception as e:
                
                error_message = f"❌ Error in email sign up: {str(e)}"
                custom_exception_handler(type(e), error_message, e.__traceback__)
                # Don't return an error, just log it - we still want the user to be created
        
        return result

    original_implementation.sign_up_post = sign_up_post
    return original_implementation

async def validate_password(value: str, tenant_id: str) -> Union[str, None]:
    return None if len(value) >= 8 else "Password must be at least 8 characters"
    
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
                
                


        emailpassword.init(
            override=emailpassword.InputOverrideConfig(
                apis=override_emailpassword_apis
            ),
            sign_up_feature=InputSignUpFeature(
                form_fields=[
                    emailpassword.InputFormField(
                        id="email"  # Default validation
                    ),
                    emailpassword.InputFormField(
                        id="password",
                        validate=validate_password  # Async function
                    ),
                    emailpassword.InputFormField(
                        id="name",
                        optional=True
                    )
                ]
            )
        ),
        dashboard.init(),
        usermetadata.init()
        # userroles.init(),
    ],
    mode='asgi'  # use wsgi if you are running using gunicorn
)
