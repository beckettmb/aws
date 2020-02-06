#!/bin/bash

aws cloudformation create-stack --stack-name crusty-stack --template-body file://aws-ccp-002-2-template.yaml
aws cloudformation wait stack-create-complete --stack-name crusty-stack
aws s3 cp ../res/index.html s3://crust-test-site/
aws s3 cp ../res/error.html s3://crust-test-site/
