#!/usr/bin/env ruby

# Gather arbitrary statistics from the excellent HP-MSA
# storage arrays and push them to Graphite. 
#
# Use the Telnet interface - although JSON and XML outputs
# on both telnet and https are also supported. 
#
# Written by Allan Clark 

require 'net/telnet'

username="user"
password="password"
hostname="hostname"

host = Net::Telnet::new(
  "Host"    => hostname,
  "Timeout" => 60,
  "Prompt"  => /#/
)
host.login(username, password)

# Open connection to Graphite
s = TCPSocket.open("localhost", 2003)
time = Time.new
epoch = time.to_i

host.cmd("show volume-statistics\n").each do |line|
  if line =~ /^Name:/
    $lun_name=line.split[1]
  end
  if line =~ /^IOPS:/
    iops=line.split[1]
    s.write("#{hostname}.#{$lun_name} #{iops} #{epoch}\n")
  end
end

host.cmd("show controller-statistics\n").each do |line|
  line=line.strip
  if line =~ /^controller_/
    $ctr_name=line.split[0]
  end
  if line =~/^[\d]/
    ctr_stats=line.split
    s.write("#{hostname}.#{$ctr_name}.reads #{ctr_stats[0]} #{epoch}\n")
    s.write("#{hostname}.#{$ctr_name}.writes #{ctr_stats[1]} #{epoch}\n")
  end
end

host.close
s.close
