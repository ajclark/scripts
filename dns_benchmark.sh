#!/bin/sh

# Performs a bunch of domain lookups against a list of DNS servers
# and reports the latency of each query across all servers. 
# Allan Clark - <napta2k@gmail.com>
# 2009-06-05

# Usage:
# ./dns_benchmark.sh dns-server-1 dns-server-2 dns-server-3 ...

for host in `cat domains.txt`
do
  for arg in $@
    do
      printf "${arg}: ${host}: `dig @${arg} ${host} | grep "Query time:"`\t"
    done
  printf "\n"
done
