#!/bin/sh

# Collect stats from TG585 v7 router (lacks snmp)
# Allan Clark - <napta2k@gmail.com>
# 2010-10-19

# This is currently under a bash script rather than
# native expect so we can interface with the output

# Change "pass" to your router password

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
'
