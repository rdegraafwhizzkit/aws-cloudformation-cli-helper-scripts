#!/bin/bash

. ./set-environment.sh $@

echo \
aws cloudformation    delete-stack \
  --stack-name        STACK_NAME \
  ${AWS_PROFILE}
