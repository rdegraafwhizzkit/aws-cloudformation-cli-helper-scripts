#!/bin/bash

AWS_PROFILE=""
if [ "$#" -eq 1 ]; then
  AWS_PROFILE="--profile $1"
fi

for yaml in $(ls -1 templates/*yaml); do

  echo Validating ${yaml}

  aws cloudformation validate-template \
    --template-body  file://${yaml} \
    ${AWS_PROFILE}

done
