#!/bin/bash

. ./set-environment.sh $@

aws cloudformation    validate-template \
  --template-body     file://TEMPLATE_FILE \
  ${AWS_PROFILE}
