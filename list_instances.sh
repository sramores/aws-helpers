#!/bin/bash

regions=$(aws ec2 describe-regions --query 'Regions[].RegionName' --output text)
totalInstances=0

for region in $regions; do
    instances=$(aws ec2 describe-instances --region $region --query 'Reservations[].Instances[]' --output json)
    count=$(echo "$instances" | jq -r 'length')
    if [ "$count" -gt 0 ]; then
        echo "Region: $region"
        echo "$instances" | jq -r '.[] | {ImageId, InstanceId, InstanceType, PrivateDnsName, PublicDnsName}'
        ((totalInstances+=count))
        if [ "$region" != "${regions##* }" ]; then
            echo
        fi
    fi
done

echo "Total global instances: $totalInstances"
