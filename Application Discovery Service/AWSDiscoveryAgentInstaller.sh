#!/bin/bash

#debug all lines & fail on error
set -eu -o pipefail 

# sudo -n true
# test $? -eq 0 || exit 1

# Set ADS variables
REGION="ap-southeast-2"
KEY_ID=""
KEY_SECRET=""
ADSAGENT="https://s3-us-west-2.amazonaws.com/aws-discovery-agent.us-west-2/linux/latest/aws-discovery-agent.tar.gz"
LOCALFILE="./aws-discovery-agent.tar.gz"

echo "Downloading the AWS Application Discovery Agent for linux..."
curl -o ${LOCALFILE} ${ADSAGENT} 

echo "installing the AWS Application Discovery Agent for linux..."

tar -xzf ${LOCALFILE}
ls -lha && bash install -r ${REGION} -k ${KEY_ID} -s ${KEY_SECRET}

if [ $? -eq 0 ] ; then echo 'Package installed' ; else echo 'Error'; exit ; fi