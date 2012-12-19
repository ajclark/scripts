#!/usr/bin/ruby

# About:
#   An awful attempt at a bandwidth monitoring tool
#   Originally written because my ReadyNAS lacks bwm-ng(1)
#   Works with OS X and Linux
# Author:
#   Allan Clark - http://github.com/ajclark/scripts
# Date:
#   2011-07-31

def read_linux_netdev(net_int="eth0")
  file = IO.readlines("/proc/net/dev")[+2..+10]
  rxnum = file[1].scan(/#{$net_int}:(\d+)/)
  txnum = file[1].map{|i| i.split(" ")}
  return rxnum[0][0].to_i, txnum[0][8].to_i
end

def read_osx_netstat(net_int="en0")
  netstat = %x{netstat -bi -I #{net_int}}.split("\n")
  netstat = netstat[1].split(" ")
  rxnum = netstat[6]
  txnum = netstat[9]
  return rxnum.to_i, txnum.to_i
end

case
  when RUBY_PLATFORM =~ /linux/i
    rxprevious = read_linux_netdev[0]
    txprevious = read_linux_netdev[1]
    sleep 1
    rxcurrent = read_linux_netdev[0]
    txcurrent = read_linux_netdev[1]
  when RUBY_PLATFORM =~ /darwin/i
    rxprevious = read_osx_netstat[0]
    txprevious = read_osx_netstat[1]
    sleep 1
    rxcurrent = read_osx_netstat[0]
    txcurrent = read_osx_netstat[1]
  else
    puts "Cannot detect operating system."
    exit
end

rxtotal = rxcurrent-rxprevious
txtotal = txcurrent-txprevious

print "TX KB/s: ", (txtotal/1024), ", " "RX KB/s: ", (rxtotal/1024), "\n"