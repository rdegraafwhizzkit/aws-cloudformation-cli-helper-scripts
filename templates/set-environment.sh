#!/bin/bash

AWS_PROFILE=""
if [ "$#" -eq 1 ]; then
  AWS_PROFILE="--profile ${1}"
fi

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
