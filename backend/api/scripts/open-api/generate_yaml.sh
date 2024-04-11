#!/bin/bash

python extract-openapi.py main:app

input_file="openapi.yaml"  # Replace with the actual file path
pattern_to_replace="anyOf:\n            - type: string\n            - type: integer"
replacement="type: string"

# Perform the replacement using sed
gsed -i 's|'"$pattern_to_replace"'|'"$replacement"'|g' "$input_file"

