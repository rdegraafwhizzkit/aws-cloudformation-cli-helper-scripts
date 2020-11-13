#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo Please provide one of the following environments:
  ls -1 environments/|grep -v templates
  exit 1
fi

environment=$1

if [ ! -d environments/${environment} ]; then
  echo Environment ${environment} not found. Please provide one of the following environments:
  ls -1 environments/|grep -v templates
  exit 1
fi

PREFIX=$(jq -r '."prefix"' environments/${environment}/deploy.json)
PROFILE=$(jq -r '."profile"' environments/${environment}/deploy.json)
STACK_NAME=$(jq -r '."stackname"' environments/${environment}/deploy.json)

ENVIRONMENT=${environment}

case $(uname) in
  Darwin)
    ZIP=zip
    ;;
  Linux)
    ZIP=zip
    ;;
  *)
    ZIP="7z a"
    ;;
esac

DATE=$(date +'%Y%m%d-%H%M%S')
