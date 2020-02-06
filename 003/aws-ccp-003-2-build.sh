#!/bin/bash

aws cloudformation create-stack --stack-name crusty-stack --template-body file://aws-ccp-003-2-template.yaml
aws cloudformation wait stack-create-complete --stack-name crusty-stack
aws s3 cp ../res/test-object.txt s3://crusty-test-bucket/ --acl public-read
