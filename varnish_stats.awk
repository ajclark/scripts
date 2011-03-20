#!/usr/bin/gawk -f

# Varnish stats for cacti
# Written by Allan Clark - http://github.com/ajclark/scripts/
# 2010-11-26

function mpr(content) {
        print content |& server
}

BEGIN {
        if (ARGC < 2) {
                print "Usage: ./varnish_stats.awk hostname port"
                exit 1
        }
        server="/inet/tcp/0/"ARGV[1]"/"ARGV[2]

        mpr("stats")
        mpr("quit")
        while ((server |& getline)>0) {
                if (/Client requests received/) {
                        requests=$1
                        printf "requests:"requests" "
                }
                if (/Cache hits/) {
                        cache_hits=$1
                        printf "cache_hits:"cache_hits " "
                }
                if (/Cache misses/) {
                        cache_misses=$1
                        printf "cache_misses:"cache_misses"\n"
                }
        }
}
