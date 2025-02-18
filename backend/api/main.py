import datetime
from contextlib import asynccontextmanager
import sys

import uvicorn
from fastapi import Depends
from fastapi import FastAPI
from fastapi import status
from fastapi.responses import JSONResponse
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel

from starlette.middleware.cors import CORSMiddleware
from supertokens_python import get_all_cors_headers
from supertokens_python.framework.fastapi import get_middleware
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.recipe.session.framework.fastapi import verify_session


from config import settings
from routes.threads.routers import router as threads_router

import logging

from utils.db import get_user_id, get_user_info, shutdown_sync_db_client, startup_async_db_client, shutdown_async_db_client, startup_sync_db_client
from utils.scrapper import getLinkMeta


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

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.ERROR, format='%(levelname)s: %(message)s')

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
    
    try:
    
        userId = get_user_id(s)
        
        #userObj: User = await get_user_by_id(userId)
        # email = userObj.email
        userDoc = await get_user_info(userId)
        
        fullName = "Unknown user"
        picture = ""
        email = ""
        last_login = datetime.datetime.now().isoformat()
        if userDoc is not None:
            fullName = userDoc['name']
            picture = userDoc['picture']
            email = userDoc['email']
            await app.mongodb["users"].update_one({"_id": userId}, {"$set": {"last_login": last_login}}, upsert=True)
            # await app.mongodb["users"].update_one({"_id": userId}, {"$set": {"email": email}}, upsert=True)
            last_login_time = datetime.datetime.now()
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
    except Exception as e:
        logger.error(e, exc_info=True)    
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




async def startup_db_client():
    app.mongodb_client = AsyncIOMotorClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]


async def shutdown_db_client():
    app.mongodb_client.close()


app.include_router(threads_router, tags=["threads"])



if __name__ == "__main__":
    try:
    # Your code that may raise an exception
        uvicorn.run(
        "main:app",
            host=settings.HOST,
            reload=settings.DEBUG_MODE,
            port=settings.PORT,
            # proxy_headers=True,
        )
    except Exception as e:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        print(f"Laudoo Error on line {exc_traceback.tb_lineno}: {type(e).__name__} - {str(e)}")
    
