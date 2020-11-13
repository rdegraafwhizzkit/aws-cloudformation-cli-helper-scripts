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

HELPER_DIR=$(dirname "$(realpath $0)")
TEMPLATE_FILE=$(jq -r '.template' ${STACK_INFO})
TEMPLATE_LOCATION=$(jq -r '.template_location' ${STACK_INFO})
STACK_NAME=$(jq -r '.name' ${STACK_INFO})
ENVIRONMENT=$(dirname ${STACK_INFO})

exit 1

mkdir -p ${ENVIRONMENT}

test -f ${ENVIRONMENT}/parameters.json || \
  aws cloudformation validate-template \
    --template-body file://${TEMPLATE_FILE} \
    ${AWS_PROFILE} | \
  jq '[.Parameters[]|{ParameterKey,"ParameterValue":""}]|sort_by(.ParameterKey |= ascii_downcase)' \
    >  ${ENVIRONMENT}/parameters.json

test -f ${ENVIRONMENT}/tags.json || \
  jq '.' "${HELPER_DIR}/templates/tags.json" >  ${ENVIRONMENT}/tags.json

test -f ${ENVIRONMENT}/validate-template.sh || \
  cat "${HELPER_DIR}/templates/validate-template.sh" | \
  sed 's@TEMPLATE_FILE@'"${TEMPLATE_LOCATION}/${TEMPLATE_FILE}"'@g' > ${ENVIRONMENT}/validate-template.sh

test -f ${ENVIRONMENT}/delete-stack.sh || \
  cat "${HELPER_DIR}/templates/delete-stack.sh" | \
  sed 's@STACK_NAME@'"${STACK_NAME}"'@g' > ${ENVIRONMENT}/delete-stack.sh

test -f ${ENVIRONMENT}/get-capabilities.sh || \
  cat "${HELPER_DIR}/templates/get-capabilities.sh" | \
  sed 's@TEMPLATE_FILE@'"${TEMPLATE_LOCATION}/${TEMPLATE_FILE}"'@g' > ${ENVIRONMENT}/get-capabilities.sh

test -f ${ENVIRONMENT}/set-environment.sh || \
  cp "${HELPER_DIR}/templates/set-environment.sh" ${ENVIRONMENT}

test -f ${ENVIRONMENT}/validate-template.sh || \
  cat "${HELPER_DIR}/templates/validate-template.sh" | \
  sed 's@TEMPLATE_FILE@'"${TEMPLATE_LOCATION}/${TEMPLATE_FILE}"'@g' > ${ENVIRONMENT}/validate-template.sh

test -f ${ENVIRONMENT}/create-stack.sh || \
  cat "${HELPER_DIR}/templates/create-stack.sh" | \
  sed 's@STACK_NAME@'"${STACK_NAME}"'@g' | \
  sed 's@TEMPLATE_FILE@'"${TEMPLATE_LOCATION}/${TEMPLATE_FILE}"'@g' > ${ENVIRONMENT}/create-stack.sh

test -f ${ENVIRONMENT}/create-change-set.sh || \
  cat "${HELPER_DIR}/templates/create-change-set.sh" | \
  sed 's@STACK_NAME@'"${STACK_NAME}"'@g' | \
  sed 's@TEMPLATE_FILE@'"${TEMPLATE_LOCATION}/${TEMPLATE_FILE}"'@g' > ${ENVIRONMENT}/create-change-set.sh

test -f ${ENVIRONMENT}/sort-and-update-parameter-files.sh || \
  cp "${HELPER_DIR}/templates/sort-and-update-parameter-files.sh" ${ENVIRONMENT}/sort-and-update-parameter-files.sh
