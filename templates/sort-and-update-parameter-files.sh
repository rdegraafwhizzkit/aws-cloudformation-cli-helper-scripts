#!/bin/bash

AWS_PROFILE=""
if [ "$#" -eq 2 ]; then
  STACK_INFO=${1}
  AWS_PROFILE="--profile ${2}"
elif [ "$#" -eq 1 ]; then
  STACK_INFO=${1}
else
  echo Please provide stack info filename and optionally the AWS profile name
  exit 1
fi

TEMPLATE_FILE=$(jq -r '.template' ${STACK_INFO})
STACK_NAME=$(jq -r '.name' ${STACK_INFO})

aws cloudformation validate-template \
  --template-body file://${TEMPLATE_FILE} \
  ${AWS_PROFILE}| \
  jq -r '[.Parameters[]|{ParameterKey}]|sort_by(.ParameterKey |= ascii_downcase)[]|.ParameterKey' \
  >  template.tmp
jq -r '.[]|.ParameterKey' parameters.json|sort > config.tmp

# New parameters
for parameter in $(comm -23 template.tmp config.tmp); do
  echo Adding parameter ${parameter} to parameters.json
  key=$(echo ${parameter}|tr -d '\n\r')
  jq '. + [ {"ParameterKey": "'${parameter}'","ParameterValue":""} ]' parameters.json >parameters.json.new
  mv parameters.json.new parameters.json
done

# Removed parameters
echo The following parameters may be removed from ${TEMPLATE_FILE}
for parameter in $(comm -13 template.tmp config.tmp); do
  echo ${parameter}
done

# Clean up
rm -f *.tmp

jq '.|sort_by(.Key |= ascii_downcase)' tags.json > tags.json.new
mv tags.json.new tags.json
