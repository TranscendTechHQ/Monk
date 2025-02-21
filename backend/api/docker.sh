## load environment variables
set -a
source ../../.env
set +a

## remove any previous docker container

docker rm monk_backend_container

## Build backend docker image
docker build -t monk_backend .

## Run backend docker image
docker run -e BASE_URL -e FASTAPI_PORT -e WEBSITE_DOMAIN -e API_DOMAIN -e INSTALL_DOMAIN -e HCP_CLIENT_ID -e HCP_CLIENT_SECRET -e HCP_ORG_ID -e HCP_PROJECT_ID -e HCP_PROJECT_NAME --name monk_backend_container -p 8001:8001 monk_backend
