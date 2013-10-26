#!/usr/bin/env ruby

# The purpose of this script is to periodically download
# a list of 'bad' IPs from our blackbird security app and add them to iptables.
# In a perfect world a web-application firewall would take care of this.
#
# Written by Allan Clark - BSkyB
# 2012-01-06

require 'rubygems'
require 'json'
require 'net/http'

# We are using the default chain - apparently
$iptables_chain = "RH-Firewall-1-INPUT"
$iptables_cmd = "/sbin/iptables -n -L #{$iptables_chain}"
response = ""

# Blackbird uses epoch in milliseconds (!)
def convert_epoch(epoch)
  date = Time.at(epoch/1000)
  return date.strftime('%Y-%m-%d %I:%M:%S %Z')
end

def add_fw_ip(ip, date, origin)
  %x{/sbin/iptables -I #{$iptables_chain} 4 -s #{ip} -m comment --comment "date: #{date} origin: #{origin}" -j DROP}
end

def check_fw_duplicates(ip)
  %x{#{$iptables_cmd}} =~ /#{ip}/ ? true : false
end

Net::HTTP.start("password", 80) { |http|
  req = Net::HTTP::Get.new("/blockedIps")
  req.basic_auth("user", "password")
  response = http.request(req)
}

json_data = JSON.parse(response.body)

json_data["blockedIps"].length.times do |i|
  unless check_fw_duplicates(json_data["blockedIps"][i]["blockedIp"])
    date = convert_epoch(json_data["blockedIps"][i]["dateBlocked"])
    #puts "#{json_data["blockedIps"][i]["blockedIp"]}"
    add_fw_ip(json_data["blockedIps"][i]["blockedIp"], date, json_data["blockedIps"][i]["origin"])
  end
end
