from pydantic import BaseModel
from supertokens_python import SupertokensConfig, get_all_cors_headers
from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware
from supertokens_python.framework.fastapi import get_middleware

import uvicorn
from motor.motor_asyncio import AsyncIOMotorClient
from config import settings


from routes.threads.routers import router as threads_router

from contextlib import asynccontextmanager

from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends
from supertokens_python.recipe.thirdparty.asyncio import get_user_by_id
from supertokens_python.recipe.thirdparty.types import User, ThirdPartyInfo


   
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Code to be executed before the application starts up
    await startup_db_client()
    yield
    # Code to be executed after the application shuts down
    await shutdown_db_client()

app = FastAPI(lifespan=lifespan)

app.add_middleware(get_middleware())


class SessionInfo(BaseModel):
    sessionHandle: str
    userId: str
    fullName: str
    email: str
    accessTokenPayload: dict

@app.get("/sessioninfo", response_model=SessionInfo, tags=["session"])
async def secure_api(s: SessionContainer = Depends(verify_session())) -> SessionInfo:
    userId = s.get_user_id()
    userName: User = await get_user_by_id(userId)
    email = userName.email
    print(userId)
    print("I am called these many times")
    userDoc = await app.mongodb["users"].find_one({"_id": userId})
    fullName = ""
    if userDoc is not None:
        print("found user")
        fullName = userDoc['user_name']
    else:
        print("user not found")
        fullName = "Unknown user"
        
    #thirdpartyInfo:ThirdPartyInfo = userName.third_party_info
    #print(email)
    #print(thirdpartyInfo.user_id)
    #print(thirdpartyInfo.id)
    
    #print("userId: ", userId)
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
        "http://localhost:8000",
    ],
    allow_credentials=True,
    allow_methods=["GET", "PUT", "POST", "DELETE", "OPTIONS", "PATCH"],
    allow_headers=["Content-Type"] + get_all_cors_headers(),
)




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
    )
