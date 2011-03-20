#!/usr/bin/env ruby

# Rulog - Ruby Syslog Server
# Allan Clark - http://github.com/ajclark/scripts/
# 2010-04-07
#
# Captures syslog events and spits them out to Growl.app
# Useful for on-spot debugging of a device with remote syslog support
# Blocking IO

# Run as root

require 'socket'
require 'rubygems'
require 'ruby-growl'

port = 514
ip = "0.0.0.0"

BasicSocket.do_not_reverse_lookup = true

g = Growl.new "127.0.0.1", "ruby-growl", 
    ["ruby-growl Notification"], nil, "password"

# Create socket and bind to address
server = UDPSocket.new
server.bind(ip, port)

puts "Listening on: #{ip}:#{port}"

loop do
    data, addr = server.recvfrom(1024)
    g.notify "ruby-growl Notification", "Ruby-growl", "#{data}"
    puts "From addr: #{addr.join(',')} msg: #{data}"
end

# Never reached
server.close

