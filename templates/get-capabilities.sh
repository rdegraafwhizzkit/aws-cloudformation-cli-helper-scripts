#!/bin/bash

AWS_PROFILE=""
if [ "$#" -eq 2 ]; then
  TEMPLATE_FILE=${1}
  AWS_PROFILE="--profile $2"
elif [ "$#" -eq 1 ]; then
  TEMPLATE_FILE=${1}
else
  echo Please provide template filename and optionally the AWS profile name
  exit 1
fi

CAPABILITIES=$(aws cloudformation validate-template \
  --template-body file://${TEMPLATE_FILE} \
  ${AWS_PROFILE} | \
  jq -r '(.Capabilities[0]//"") as $caps|if $caps == "" then "" else "--capabilities " + $caps end')
