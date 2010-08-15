#!/bin/sh

# Purpose: Update ET rules
# Author: Allan Clark - <napta2k@gmail.com>
# Date: 2009-06-05

FWRULES="http://www.emergingthreats.net/fwrules/emerging-Block-IPs.txt"

cd /tmp || exit 1

wget $FWRULES || exit 1

# Clear out exiting ET rules - this works because /etc/iptables.rules contains 
# the original pre-ET rules, except for the ETBLOCKLIST/LOGNDROP chains
iptables-restore /etc/iptables.rules || exit 1

# Check required chains exist (they should be empty)
iptables -L ETBLOCKLIST || exit 1
iptables -L LOGNDROP || exit 1

# Populate iptables with new ET rules
for ip in `grep '^[0-9]' emerging-Block-IPs.txt`
   do
      echo "Adding: ${ip}"
      iptables -A ETBLOCKLIST -p ALL -s $ip -j LOGNDROP
   done

# Delete downloaded rules
rm emerging-Block-IPs.txt

