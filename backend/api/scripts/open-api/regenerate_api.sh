#python extract-openapi.py main:app
rm -rf ../../frontend/openapi
openapi-generator generate -i openapi.yaml -g dart-dio -o ../../frontend/openapi --additional-properties=serializationLibrary=json_serializable,apiTests=true,modelTests=true
