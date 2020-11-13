#!/bin/bash

. ./set-environment.sh $@

. ./get-capabilities.sh $@

echo \
aws cloudformation    create-stack \
  --stack-name        STACK_NAME \
  --template-body     file://TEMPLATE_FILE \
  --parameters        file://parameters.json \
  --tags              file://tags.json \
  ${CAPABILITIES} \
  ${AWS_PROFILE}
