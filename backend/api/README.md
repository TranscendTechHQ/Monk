

# Run the backend
`cd api`

# Setup the runtime environment


`uv sync`

## open the config/.env file and add the credentials
## use vi or any other editor 
vi config/.env 

## now run the main file
`uv run main.py`

# Docker
## Delete all the docker images (careful)
docker system prune -a 

## Build and run docker image
./docker.sh



## Extract openapi.yaml from the FastAPI app
One time install
```bash
brew install openapi-generator
```
Each time you update API endpoints
```bash
cd utils/open-api
./generate_api.sh
