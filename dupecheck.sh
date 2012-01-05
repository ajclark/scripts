#!/bin/bash

# Checks for duplicate files (based on filename)
# Allan Clark - http://github.com/ajclark/scripts/
# 2009-07-08

# Usage
if [ -z "$1" ]; then
   echo "Usage: ./dupecheck.sh /dir"
   exit
fi

# Find files larger than 1MB
find $1 -size +10248576c -type f | while IFS= read file
do
   echo $(basename "$file")
done | sort | uniq -d

