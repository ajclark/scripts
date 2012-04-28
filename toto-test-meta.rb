#!/usr/bin/env ruby

# Toto test meta
# Allan Clark - http://github.com/ajclark/
# 2011-04-04

require "net/http"
require "uri"

URLs = [
	'http://localhost:3000/',
	'http://localhost:3000/about/',
	'http://localhost:3000/index.xml'
	]

# Ensure that all defined URLs return 200 response codes
URLs.each do |url|
 uri = URI.parse(url)

 req = Net::HTTP::Get.new(uri.path)
 req.add_field("Cache-Control", "no-cache")

 response = Net::HTTP.new(uri.host, uri.port).start do |http|
  http.request(req)
 end
 
 puts "#{response.code} #{url}"
 if (response.code.to_i != 200)
   exit(response.code.to_i)
 end
end
