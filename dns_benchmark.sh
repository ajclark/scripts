#!/bin/bash

# Performs a bunch of domain lookups against a list of DNS servers
# and reports the latency of each query across all servers. 
# Allan Clark - http://github.com/ajclark/scripts/
# 2009-06-05

# Usage:
# ./dns_benchmark.sh dns-server-1 dns-server-2 dns-server-3 ...

DOMAINS=(twitter.com bbc.co.uk itv.com google.ch yahoo.com playboy.com)

for host in "${DOMAINS[@]}"
do
  for arg in "${@}"
    do
      printf "${arg}: ${host}: $(dig @${arg} ${host} | grep "Query time:")\t"
    done
  printf "\n"
done
