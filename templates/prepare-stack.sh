#!/bin/bash

. set-environment.sh $@

# PARAMETERS=parameters.json
# S3_BUCKET=$(jq -r '.[]|select(.ParameterKey=="S3Bucket")|.ParameterValue' ${PARAMETERS})
# S3_KEY=$(jq -r '.[]|select(.ParameterKey=="S3Key")|.ParameterValue' ${PARAMETERS}|sed "s/[-0-9]*\.zip$/-$DATE.zip/g")
# LOCAL_ZIP=$(basename ${S3_KEY})

# ${ZIP} ${LOCAL_ZIP} *.py
# aws s3 cp ${LOCAL_ZIP} s3://${S3_BUCKET}/${S3_KEY} ${AWS_PROFILE}
# rm -f ${LOCAL_ZIP}

# jq --arg function_version ${DATE} '. |= map(if .ParameterKey == "FunctionVersion" then (.ParameterValue=$function_version) else . end)' ${PARAMETERS} > ${PARAMETERS}.new
# mv -f ${PARAMETERS}.new ${PARAMETERS}

# jq --arg s3_key ${S3_KEY} '. |= map(if .ParameterKey == "S3Key" then (.ParameterValue=$s3_key) else . end)' ${PARAMETERS} > ${PARAMETERS}.new
# mv -f ${PARAMETERS}.new ${PARAMETERS}
