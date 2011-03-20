#!/bin/bash

# Perform QA checks on DNS zones
# Created by Allan Clark - http://github.com/ajclark/scripts/
# Note: POSIX compatibility mode (set -o posix) will break this script
# Usage: ./dnscheck.sh /var/named/prod.example.com.db
# 
# This script will perform a forward and reverse DNS lookup against each record
# listed in a given zonefile. This helps detects broken zones and missing PTR records.

# Error counts
entries=0
ptrErrors=0
aErrors=0

# Get the zone file origin
origin=`grep "ORIGIN" $1 | cut -d" " -f2`

echo "Checking zone: $1"
while read host in a ipaddress
do

   # Sanitize $host before query
   echo $host | grep -q '^[a-z]'
   if [ $? -ne 0 ]; then
      # Skip record if invalid
      continue
   fi

   # Forward check
   entries=$((entries+1))
   host ${host}.${origin} &> /dev/null
   if [ $? -ne 0 ]; then
      echo "${host}.${origin}: error in forward lookup"
      aErrors=$((aErrors+1))
   fi

   # Reverse check
   host $ipaddress &> /dev/null
   if [ $? -ne 0 ]; then
     echo "${host}.${origin}: no PTR record found"
     ptrErrors=$((ptrErrors+1))
   fi

# Not POSIX compatible
done < <(cat $1)

echo "Zone: $1"
echo "Total records checked: $entries"
echo "A record errors: $aErrors"
echo "PTR record errors: $ptrErrors"
