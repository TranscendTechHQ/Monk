python extract-openapi.py main:app
rm -rf ../../frontend/openapi
openapi-generator generate -i openapi.yaml -g dart-dio -o ../../frontend/openapi
