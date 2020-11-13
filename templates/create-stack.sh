#!/bin/bash

. ./scripts/get-environment.sh $@

. ./scripts/get-capabilities.sh \
  templates/${PREFIX}.yaml \
  ${PROFILE}

echo \
aws cloudformation  create-stack \
  --stack-name      ${STACK_NAME} \
  --profile         ${PROFILE} \
  --template-body   file://templates/${PREFIX}.yaml \
  --parameters      file://environments/${ENVIRONMENT}/${PREFIX}.json \
  --tags            file://environments/${ENVIRONMENT}/${PREFIX}-tags.json \
  ${CAPABILITIES}
