#!/bin/bash

aws s3 rm s3://crust-test-site --recursive
aws cloudformation delete-stack --stack-name crusty-stack
