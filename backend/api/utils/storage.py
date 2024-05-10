import boto3
from fastapi import UploadFile
from config import settings

bucket_name = 'monk-assets'

s3 = boto3.client(
    service_name="s3",
    endpoint_url=settings.STORAGE_ENDPOINT,
    aws_access_key_id=settings.STORAGE_ACCESS_KEY_ID,
    aws_secret_access_key=settings.STORAGE_SECRET_ACCESS_KEY,
    region_name="auto",  # Must be one of: wnam, enam, weur, eeur, apac, auto
)

# Function to upload a single file and return the url


def upload_file(file: UploadFile, file_key: str):
    s3.upload_fileobj(file.file, bucket_name, file_key)
    return f"{settings.STORAGE_DOMAIN}/{file_key}"


# Function to delete a single file and return the url
def delete_file(file_key: str):
    s3.delete_object(Bucket=bucket_name, Key=file_key)
    return f"{settings.STORAGE_DOMAIN}/{file_key}"
