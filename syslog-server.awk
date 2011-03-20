#!/usr/bin/env gawk -f

# Awk syslog server (written for fun)
# Allan Clark - http://github.com/ajclark/scripts/
# 2010-12-16

# run as root

BEGIN {
	server="/inet/udp/514/0/0"
	while ((server |& getline)>0) {
		print strftime() " " $0
	}
}

