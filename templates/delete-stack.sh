#!/bin/bash

. ./scripts/get-environment.sh $@

echo \
aws cloudformation  delete-stack \
  --stack-name      ${STACK_NAME} \
  --profile         ${PROFILE}
