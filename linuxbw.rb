#!/usr/bin/ruby

# An awful attempt at a bandwidth monitoring tool
# Originally written because my ReadyNAS lacks bwm-ng(1)
# Written Allan Clark - http://github.com/ajclark/scripts
# 2011-07-31

$net_int="eth0"

def read_netdev
  file = IO.readlines("/proc/net/dev")[+2..+10]
  rxnum = file[1].scan(/#{$net_int}:(\d+)/)
  txnum = file[1].map{|i| i.split(" ")}
  rxnum[0][0].map{|i| i.to_i}
  return rxnum[0][0].to_i, txnum[0][8].to_i
end

rxprevious = read_netdev[0]
txprevious = read_netdev[1]
sleep 1
rxcurrent = read_netdev[0]
txcurrent = read_netdev[1]

rxtotal = rxcurrent-rxprevious
txtotal = txcurrent-txprevious

print $net_int, ": " "TX KB/s: ", (txtotal/1024), ", " "RX KB/s: ", (rxtotal/1024), "\n"
