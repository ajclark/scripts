#!/usr/bin/ruby

# Detect configsync status of F5 LTMs
# Written by Allan Clark - http://github.com/ajclark
# Tested on Ruby 1.8.7

require "rubygems"
require "f5-icontrol"

def usage 
  puts $0 + " <BIG-IP address> <BIG-IP user> <BIG-IP password>"
  exit
end

usage if $*.size < 3

bigip = F5::IControl.new($*[0], $*[1], $*[2], ["Management.DBVariable"]).get_interfaces
status = bigip["Management.DBVariable"].query("configsync.state").first.value

puts "#{ARGV[0]} #{status}"

exit 1 unless status =~ /Synchronized/ 
