#!/bin/bash

aws s3 rm s3://crusty-test-bucket --recursive
aws cloudformation delete-stack --stack-name crusty-stack
