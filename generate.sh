#!/bin/bash

AWS_PROFILE=""
if [ "$#" -eq 2 ]; then
  STACK_INFO=${1}
  AWS_PROFILE="${2}"
elif [ "$#" -eq 1 ]; then
  STACK_INFO=${1}
else
  echo Please provide stack info filename and optionally the AWS profile name
  exit 1
fi

HELPER_DIR=$(dirname "$(realpath $0)")
ENVIRONMENT=$(dirname ${STACK_INFO})

PREFIX=$(jq -r '.prefix' ${STACK_INFO})

mkdir -p scripts/${PREFIX}
mkdir -p environments/templates

for script in \
  validate-templates.sh \
  get-capabilities.sh \
  get-environment.sh \
  generate-conf-templates.sh \
  sort-and-update-parameter-files.sh; do
  test -f scripts/${script} || \
    cp "${HELPER_DIR}/templates/${script}" scripts/${script}
done

./scripts/generate-conf-templates.sh ${AWS_PROFILE}

for script in \
  create-change-set.sh \
  create-stack.sh \
  delete-stack.sh \
  prepare-stack.sh \
  sort-and-update-parameter-files.sh; do
  test -f scripts/${PREFIX}/${script} || \
    cp "${HELPER_DIR}/templates/${script}" scripts/${PREFIX}/${script}
done
