import datetime
from contextlib import asynccontextmanager

import uvicorn
from fastapi import Depends
from fastapi import FastAPI
from fastapi import status, Request
from fastapi.responses import JSONResponse
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel
from slack_sdk.web import WebClient
from starlette.middleware.cors import CORSMiddleware
from supertokens_python import get_all_cors_headers
from supertokens_python.framework.fastapi import get_middleware
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.thirdparty.asyncio import get_user_by_id
from supertokens_python.recipe.thirdparty.types import User


from config import settings
from routes.threads.routers import router as threads_router


from utils.db import shutdown_sync_db_client, startup_async_db_client, shutdown_async_db_client, startup_sync_db_client
from utils.scrapper import getLinkMeta

# Set your Slack client ID and client secret
SLACK_CLIENT_ID = settings.SLACK_CLIENT_ID
SLACK_CLIENT_SECRET = settings.SLACK_CLIENT_SECRET


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Code to be executed before the application starts up
    await startup_db_client()
    await startup_async_db_client()
    startup_sync_db_client()
    yield
    # Code to be executed after the application shuts down
    await shutdown_db_client()
    await shutdown_async_db_client()
    shutdown_sync_db_client()


app = FastAPI(lifespan=lifespan)

app.add_middleware(get_middleware())


class SessionInfo(BaseModel):
    sessionHandle: str
    userId: str
    fullName: str
    email: str
    accessTokenPayload: dict
    picture: str = None
    last_login: str = None


@app.get("/sessioninfo", response_model=SessionInfo, tags=["session"])
async def secure_api(s: SessionContainer = Depends(verify_session())) -> SessionInfo:
    userId = s.get_user_id()
    userObj: User = await get_user_by_id(userId)
    # email = userObj.email

    userDoc = await app.mongodb["users"].find_one({"_id": userId})
    fullName = "Unknown user"
    picture = ""
    email = ""
    last_login = datetime.datetime.now().isoformat()
    if userDoc is not None:
        fullName = userDoc['name']
        picture = userDoc['picture']
        email = userDoc['email']

        # print(userDoc)
        await app.mongodb["users"].update_one({"_id": userId}, {"$set": {"last_login": last_login}}, upsert=True)
        # await app.mongodb["users"].update_one({"_id": userId}, {"$set": {"email": email}}, upsert=True)

    # thirdpartyInfo = userObj.third_party_info
    # print(email)
    # print(thirdpartyInfo.user_id)
    # print(thirdpartyInfo.id)

    # print("userId: ", userId)
    sessionInfo: SessionInfo = SessionInfo(
        sessionHandle=s.get_handle(),
        userId=userId,
        fullName=fullName,
        email=email,
        accessTokenPayload=s.get_access_token_payload()
    )
    return sessionInfo


app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        settings.WEBSITE_DOMAIN,
        settings.INSTALL_DOMAIN,
    ],
    allow_credentials=True,
    # allow_methods=["*"],
    # allow_headers=["*"],
    allow_methods=["GET", "PUT", "POST", "DELETE", "OPTIONS", "PATCH"],
    allow_headers=["Content-Type"] + get_all_cors_headers(),
)


def get_slack_access_token(code):
    """
    Exchanges an OAuth authorization code for an access token.

    Args:
        code (str): The authorization code received from the Slack OAuth flow.

    Returns:
        dict: The response from the Slack `oauth.v2.access` API, containing the access token and other details.
    """
    client = WebClient()
    response = client.oauth_v2_access(
        client_id=SLACK_CLIENT_ID,
        client_secret=SLACK_CLIENT_SECRET,
        code=code
    )

    return response


class TenantModel(BaseModel):
    tenant_id: str
    tenant_name: str
    user_id: str
    user_token: str
    bot_token: str
    token_response: dict


@app.get("/healthcheck")
async def healthcheck():
    return JSONResponse(status_code=status.HTTP_200_OK, content={"message": "API is running"})


@app.get("/linkmeta")
async def get_link_meta(url: str):
    try:
        if url is None:
            return JSONResponse(status_code=status.HTTP_400_BAD_REQUEST, content={"message": "URL is required"})

        meta = getLinkMeta(url)
        print(meta)
        return JSONResponse(status_code=status.HTTP_200_OK, content=meta)
    except Exception as e:
        return JSONResponse(status_code=status.HTTP_400_BAD_REQUEST, content={"message": str(e)})


@app.post("/slack_user_token")
async def slack_user_token(request: Request, authcode: str):
    token_response = get_slack_access_token(authcode)
    # print(token_response.__dict__)

    if "error" in token_response:
        return JSONResponse(status_code=status.HTTP_400_BAD_REQUEST, content={"message": "Invalid auth code"})

    if token_response["ok"] == False:
        return JSONResponse(status_code=status.HTTP_400_BAD_REQUEST, content={"message": "Invalid auth code"})

    token_data = token_response.data
    # print(token_data)

    tenant = {}
    tenant_id = token_data["team"]["id"]
    tenant["tenant_id"] = tenant_id
    tenant["tenant_name"] = token_data["team"]["name"]
    tenant["user_id"] = token_data["authed_user"]["id"]
    tenant["user_token"] = token_data["authed_user"]["access_token"]
    tenant["bot_user_id"] = token_data["bot_user_id"]
    tenant["bot_token"] = token_data["access_token"]
    tenant["token_response"] = token_data

    tenant_model = TenantModel(**tenant)

    # print(token_response)
    tenant_collection = request.app.mongodb["tenants"]

    # Replace the document if it exists, otherwise insert it
    result = await tenant_collection.replace_one(
        filter={"tenant_id": tenant_id},
        replacement=tenant,
        upsert=True
    )

    # Check if a new document was inserted
    if result.upserted_id is not None:
        print(f"New document inserted with ID: {result.upserted_id}")
    else:
        print("Document replaced successfully")

    return JSONResponse(status_code=status.HTTP_200_OK, content={"message": "Monk added successfully"})


async def startup_db_client():
    app.mongodb_client = AsyncIOMotorClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]


async def shutdown_db_client():
    app.mongodb_client.close()


app.include_router(threads_router, tags=["threads"])



if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host=settings.HOST,
        reload=settings.DEBUG_MODE,
        port=settings.PORT,
        # proxy_headers=True,
    )
