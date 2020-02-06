#!/bin/bash

aws s3 mb s3://crusty-test-bucket
aws s3 cp ../res/test-object.txt s3://crusty-test-bucket/ --acl public-read
aws cloudfront create-distribution --origin-domain-name crusty-test-bucket.s3.amazonaws.com > /dev/null
while ../scripts/check-dist-status.sh | grep InProgress > /dev/null; do sleep 20; done
aws cloudfront list-distributions --query "DistributionList.Items[].{DomainName: DomainName}" | grep : | cut -d '"' -f 4
