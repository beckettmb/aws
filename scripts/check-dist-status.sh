#!/bin/bash

aws cloudfront list-distributions --query "DistributionList.Items[].{DomainName: DomainName, Status: Status}" | grep : | cut -d '"' -f 4
