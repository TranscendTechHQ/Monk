# Setup the runtime environment
## create virtual env
`python -m venv env`

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

## Extract openapi.yaml from the FastAPI app
One time install
```bash
brew install openapi-generator
```
Each time you update API endpoints
```bash
python extract-openapi.py main:app
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
```
# with
          items:
            type: string
```
`./regenerate_api.sh`