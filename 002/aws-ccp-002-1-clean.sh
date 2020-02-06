#!/bin/bash

aws s3 rm s3://crust-test-site --recursive
aws s3 rb s3://crust-test-site
