import boto3
from fastapi import UploadFile
from config import settings

bucket_name = settings.STORAGE_BUCKET_NAME

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


# Function to delete a single file and return the url
def delete_file(file_key: str):
    s3.delete_object(Bucket=bucket_name, Key=file_key)


def list_files():
    return s3.list_objects_v2(Bucket=bucket_name)

def download_file(file_key: str):
    return s3.get_object(Bucket=bucket_name, Key=file_key)

def get_presigned_url(file_key: str, 
                      client_method: str, 
                      expiration: int = 3600):
    return s3.generate_presigned_url(
        Params={"Bucket": bucket_name, "Key": file_key},
        ExpiresIn=expiration,
        ClientMethod=client_method
    )

def main():
    print(list_files())
    print(download_file("BGMI BANNER.png"))


if __name__ == "__main__":
    main()
