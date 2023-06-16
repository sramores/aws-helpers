#!/bin/bash

regions=$(aws ec2 describe-regions --query 'Regions[].RegionName' --output text)
totalInstances=0

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "+----------------------+-----------------+"
printf "| %-20s | %-15s |\n" "Region" "Total instances"
echo "+----------------------+-----------------+"

for region in $regions; do
    instances=$(aws ec2 describe-instances --region $region --query 'Reservations[].Instances[]' --output json)
    count=$(echo "$instances" | jq -r 'length')
    if [ "$count" -eq 0 ]; then
        printf "| ${RED}%-20s${NC} | ${RED}%-15s${NC} |\n" "$region" "0"
    else
        printf "| ${GREEN}%-20s${NC} | ${GREEN}%-15s${NC} |\n" "$region" "$count"
        ((totalInstances+=count))
    fi
done

echo "+----------------------+-----------------+"
printf "| %-20s | %-15s |\n" "Total" "$totalInstances"
echo "+----------------------+-----------------+"
