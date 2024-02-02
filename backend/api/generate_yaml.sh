#!/bin/bash

python extract-openapi.py main:app
# Specify the file path
file_path="openapi.yaml"  # Replace with the actual file path

# Use sed to perform the replacement
sed -i '/properties:/,/integer/ {
    /anyOf:/d
    /- type: string/d
    /- type: integer/c\
    type: string
}' "$file_path"

