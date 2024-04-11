#python extract-openapi.py main:app
export FRONTEND_PATH="../../../../frontend/openapi"


rm -rf $FRONTEND_PATH
openapi-generator generate -i openapi.yaml -g dart-dio -o $FRONTEND_PATH --additional-properties=serializationLibrary=json_serializable,apiTests=true,modelTests=true
