#!/bin/bash

. ./set-environment.sh $@

. ./get-capabilities.sh $@

echo \
aws cloudformation    create-change-set \
  --stack-name        STACK_NAME \
  --template-body     file://TEMPLATE_FILE \
  --parameters        file://parameters.json \
  --tags              file://tags.json \
  --change-set-name   STACK_NAME-${DATE} \
  ${CAPABILITIES} \
  ${AWS_PROFILE}
