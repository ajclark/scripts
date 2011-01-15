#!/bin/sh

# Collect stats from TG585 v7 router via telnet (which lacks snmp)
# Allan Clark - <napta2k@gmail.com>
# 2010-10-19

# Change "pass" to your router password

# Configured output to be a munin script
if [ "$1" = "config" ]; then
	echo "graph_title TG585 router statistics"
	echo "graph_category router"
	echo "active_connections.label Active connections"
	echo "idle_connections.label Idle connections"
	echo "tcp_connections.label TCP connections"
	echo "udp_connections.label UDP connections"
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
