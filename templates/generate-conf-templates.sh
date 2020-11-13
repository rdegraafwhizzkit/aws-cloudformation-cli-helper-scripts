#!/bin/bash

AWS_PROFILE=""
if [ "$#" -eq 1 ]; then
  AWS_PROFILE="--profile $1"
fi

mkdir -p environments/templates/

for yaml in $(ls -1 templates/*yaml); do

  stack=$(basename ${yaml}|sed 's/\.yaml$//g')

  aws cloudformation validate-template \
    --template-body file://${yaml} \
    ${AWS_PROFILE}| \
    jq '[.Parameters[]|{ParameterKey,"ParameterValue":""}]|sort_by(.ParameterKey |= ascii_downcase)' \
    > environments/templates/${stack}.json

  echo '[{"Key":"Key","Value":"Value"}]'| \
    jq '.' \
    > environments/templates/${stack}-tags.json

done

echo '{"prefix":"","profile":"","stackname":""}'| \
  jq '.' \
  > environments/templates/deploy.json
