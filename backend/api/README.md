# Setup the runtime environment
## create virtual env

`uv venv`
`source .venv/bin/activate`

## activate virtual env 
`source env/bin/activate`

## install required python packages
`pip install -m requirements.txt`

# Run the backend
`cd api`

## open the config/.env file and add the credentials
## use vi or any other editor 
vi config/.env 

## now run the main file
`python main.py`

# Docker
## Delete all the docker images (careful)
docker system prune -a 

## Build backend docker image
docker build -t monk_backend .

## Run backend docker image
docker run -e HCP_CLIENT_ID -e HCP_CLIENT_SECRET -e HCP_ORG_ID -e HCP_PROJECT_ID -e HCP_PROJECT_NAME --name monk_backend_container -p 8001:8001 monk_backend



## Extract openapi.yaml from the FastAPI app
One time install
```bash
brew install openapi-generator
```
Each time you update API endpoints
```bash
cd scripts/open-api
./generate_yaml.sh
```
Edit the openapi.yaml file (temporary hack)
```yaml
# Replace
          items:
            anyOf:
            - type: string
            - type: integer
```
```yaml
# with
          items:
            type: string
```
`./regenerate_api.sh`

cd ../../../../frontend
`./regenerate_api.sh`
