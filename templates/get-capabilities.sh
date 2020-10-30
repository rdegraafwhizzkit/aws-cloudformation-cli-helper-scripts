#!/bin/bash

CAPABILITIES=$(aws cloudformation validate-template \
  --template-body file://TEMPLATE_FILE \
  ${AWS_PROFILE} | \
  jq -r '(.Capabilities[0]//"") as $caps|if $caps == "" then "" else "--capabilities " + $caps end')
