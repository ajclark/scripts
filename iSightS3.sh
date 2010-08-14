#!/usr/bin/env bash

# Purpose: Capture iSight image and upload them to Amazon S3
#          To be used in-conjunction with a while loop

# Only the current file is stored locally
outputFile=/tmp/iSight/current.jpg

# Capture an image, and upload it to Amazon S3
isightcapture $outputFile
if [ $? -eq 0 ]; then
   s3cmd put --acl-public $outputFile s3://s3.antihoe.org/iSight/$(date +%A)/$(date +%H.%M).jpg
fi

# It's that simple!
