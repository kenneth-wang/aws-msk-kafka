#!/bin/bash
set -x
source ./infrastructure/utils.sh

KEY_NAME="key-pair"
KAFKA_STACK="kafka-stack"
AWS="aws"


# Task definition
if ! $AWS cloudformation describe-stacks --stack-name ${KAFKA_STACK} ; then
    $AWS cloudformation create-stack --stack-name ${KAFKA_STACK} \
                                     --capabilities CAPABILITY_NAMED_IAM \
                                     --template-body file://infrastructure/kafka-cf.json \
                                     --parameters ParameterKey=KeyName,ParameterValue=${KEY_NAME}
else
    update_stack --stack-name ${KAFKA_STACK} \
                                     --capabilities CAPABILITY_NAMED_IAM \
                                     --template-body file://infrastructure/kafka-cf.json \
                                     --parameters ParameterKey=KeyName,ParameterValue=${KEY_NAME}
fi
