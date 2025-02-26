#!/bin/bash
FRONTEND_PATH="../../../../frontend/src/api"
./generate_yaml.sh
rm -rf $FRONTEND_PATH
npx openapi-typescript-codegen -i openapi.yaml -o $FRONTEND_PATH
