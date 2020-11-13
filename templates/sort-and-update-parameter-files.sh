#!/bin/bash

. ./scripts/get-environment.sh $@

for json in $(ls -1 environments/${ENVIRONMENT}/*.json|grep -v deploy); do

  if [[ "${json}" != *"tags"* ]];then

    jq -r '.[]|.ParameterKey' environments/templates/$(basename ${json})|sort > template.tmp
    jq -r '.[]|.ParameterKey' ${json}|sort > config.tmp

    # New parameters
    for parameter in $(comm -23 template.tmp config.tmp); do
      parameter=$(echo ${parameter}|tr -d '\n\r')
      echo Adding parameter ${parameter} to ${json}
      jq '. + [ {"ParameterKey": "'${parameter}'","ParameterValue":""} ]' ${json} > ${json}.new
      mv ${json}.new ${json}
    done

    # Removed parameters
    echo The following parameters may be removed from ${json}
    for parameter in $(comm -13 template.tmp config.tmp); do
      echo ${parameter}|tr -d '\n\r'
      echo
    done

    # Clean up
    rm -f *.tmp

    jq '.|sort_by(.ParameterKey |= ascii_downcase)' ${json} > ${json}.new
    mv ${json}.new ${json}

  else

    jq '.|sort_by(.Key |= ascii_downcase)' ${json} > ${json}.new
    mv ${json}.new ${json}

  fi

done
