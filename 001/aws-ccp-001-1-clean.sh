#!/bin/bash

aws s3 rm s3://crusty-test-bucket --recursive
aws s3 rb s3://crusty-test-bucket
