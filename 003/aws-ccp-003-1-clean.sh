#!/bin/bash

aws s3 rm s3://crusty-test-bucket --recursive
aws s3 rb s3://crusty-test-bucket

aws cloudfront list-distributions --query "DistributionList.Items[].{DomainName: DomainName, Id: Id}" | grep : | cut -d '"' -f 4
echo "Please enter cloudfront distribution id to delete:"
read cfid
cfet=$(aws cloudfront get-distribution --id $cfid --query ETag | cut -d '"' -f 2)

aws cloudfront get-distribution-config --id $cfid --query DistributionConfig > dist.json
sed -i 's/"Enabled": true/"Enabled": false/' dist.json
aws cloudfront update-distribution --id $cfid --if-match $cfet --distribution-config file://dist.json > /dev/null
rm dist.json
cfet=$(aws cloudfront get-distribution --id $cfid --query ETag | cut -d '"' -f 2)
while ../scripts/check-dist-status.sh | grep InProgress > /dev/null; do sleep 20; done
aws cloudfront delete-distribution --id $cfid --if-match $cfet
