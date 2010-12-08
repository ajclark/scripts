#!/bin/sh

# Collect stats from TG585 v7 router via telnet (lacks snmp)
# Allan Clark - <napta2k@gmail.com>
# 2010-10-19

# Collects a few useful statistics. Note that these stats
# are just the tip of the ice berg.

# Change "pass" to your router password

if [ $1 == "config" ]; then
	echo "graph_title TG585 router statistics"
	echo "graph_category router"
	echo "connections.label Connections"
	echo "connections.type GAUGE"
	exit 0
fi

# Talk to router over telnet
expect -c '
	spawn telnet bebox
	expect "Username : "
	send "Administrator\r"
	expect "Password : "
	send "pass\r"
	expect "=>"
	send ":connection stats\r"
	expect "=>"
	send "exit\r"
	expect eof
' | awk '/Number of active connections/ { printf "active_connections.value " $NF "\n" }
	/Number of idle connections/ { printf "idle_connections.value " $NF "\n" }
	/Number of TCP connections/ { printf "tcp_connections.value " $NF "\n" }
	/Number of UDP connections/ { printf "udp_connections.value " $NF "\n" }'
