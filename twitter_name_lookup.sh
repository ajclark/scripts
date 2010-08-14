#!/bin/sh

for i in `cat /tmp/twitter_names.txt` 
do
   curl -s http://twitter.com/${i} | grep -q "That page doesn't exist"
   if [ $? -eq 0 ]; then
      echo "${i} is available"
   fi
done
      
