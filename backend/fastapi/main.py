from fastapi import FastAPI
import uvicorn
from motor.motor_asyncio import AsyncIOMotorClient
from config import settings

from routes.tasks.routers import router as tasks_router

from contextlib import asynccontextmanager

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Code to be executed before the application starts up
    await startup_db_client()
    yield
    # Code to be executed after the application shuts down
    await shutdown_db_client()

app = FastAPI(lifespan=lifespan)




async def startup_db_client():
    app.mongodb_client = AsyncIOMotorClient(settings.DB_URL)
    app.mongodb = app.mongodb_client[settings.DB_NAME]



async def shutdown_db_client():
    app.mongodb_client.close()


app.include_router(tasks_router, tags=["tasks"], prefix="/task")


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host=settings.HOST,
        reload=settings.DEBUG_MODE,
        port=settings.PORT,
    )
