#!/bin/bash
set -eo pipefail
ARTIFACT_BUCKET=$(cat bucket-name.txt)
cd function
GOOS=linux go build main.go
cd ../
aws cloudformation package --template-file template.yml --s3-bucket $ARTIFACT_BUCKET --output-template-file out.yml
aws cloudformation deploy \
    --parameter-overrides HumioAddress="${HUMIO_ADDRESS}" HumioToken="${HUMIO_TOKEN}" \
    --template-file out.yml --stack-name humio-ingest --capabilities CAPABILITY_NAMED_IAM
