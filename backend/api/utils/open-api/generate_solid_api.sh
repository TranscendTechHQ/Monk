#!/bin/bash
FRONTEND_PATH="../../../../solid_frontend/src/api"
./generate_yaml.sh
rm -rf $FRONTEND_PATH
openapi -i openapi.yaml -o $FRONTEND_PATH
