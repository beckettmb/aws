#!/bin/bash

aws s3 mb s3://crust-test-site
aws s3 cp ../res/index.html s3://crust-test-site/
aws s3 cp ../res/error.html s3://crust-test-site/
aws s3api put-bucket-policy --bucket crust-test-site --policy file://aws-ccp-002-1-policy.json
aws s3 website s3://crust-test-site/ --index-document index.html --error-document error.html
