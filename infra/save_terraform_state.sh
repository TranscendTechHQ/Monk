#!/bin/bash

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
aws s3 cp terraform.tfstate s3://monk-infra-terraform-state-bucket/backups/terraform-$TIMESTAMP.tfstate