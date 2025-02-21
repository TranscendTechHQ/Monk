## remove any previous docker container
set -a
source ../.env
set +a

docker rm monk_frontend_container

## Build frontend docker image
docker build -t monk_frontend .

## Run frontend docker image
docker run -e VITE_API_DOMAIN -e VITE_WEBSITE_DOMAIN --name monk_frontend_container -p 3000:3000 monk_frontend
