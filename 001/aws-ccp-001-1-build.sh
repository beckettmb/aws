#!/bin/bash

aws s3 mb s3://crusty-test-bucket
aws s3 cp ../res/test-object.txt s3://crusty-test-bucket/ --acl public-read
