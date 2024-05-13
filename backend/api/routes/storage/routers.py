import datetime as dt
import time
from fastapi import FastAPI, HTTPException, UploadFile
import logging
from typing import List
from fastapi import APIRouter, Body, Depends
from fastapi import status, Request
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.thirdparty.asyncio import get_user_by_id

from routes.storage.models import FilesResponseModel
from utils.storage import upload_file


router = APIRouter()
logger = logging.getLogger(__name__)


@router.post("/uploadFiles/", response_model=FilesResponseModel, tags=["storage"], response_description="Returns the uploaded file url", name="Upload Files")
async def create(files: list[UploadFile],  session: SessionContainer = Depends(verify_session())):
    try:
        # Get user ID from session
        user_id = session.get_user_id()

        if not user_id:
            raise HTTPException(status_code=401, detail="Unauthorized")

        # Upload multiple files to storage
        file_urls = []
        for file in files:
            # Upload file to storage
            file_key = f"{file.filename}"
            file_url = upload_file(file, file_key)
            file_urls.append(file_url)

        print(file_urls)

        if len(file_urls) == 0:
            return JSONResponse(status_code=400, content={"message": "Something went wrong. Please try again later."})

        response = FilesResponseModel(
            urls=file_urls,
        )

        return JSONResponse(
            status_code=status.HTTP_200_OK, content=jsonable_encoder(response)
        )

    except Exception as e:
        logger.error(f"Error uploading file: {e}")
        raise HTTPException(status_code=500, detail="Error uploading file")
