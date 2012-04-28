#!/usr/bin/env ruby

# Toto test articles
# Allan Clark - http://github.com/ajclark/
# 2011-04-04

require 'rubygems'
require 'mechanize'
require "net/http"
require "uri"

# Blog URL
url = "http://localhost:3000"

# Visit blog
agent = Mechanize.new
page = agent.get(url)

# Ensure each article on blog returns a 200 response code ; use no-cache to defeat varnish
articles = agent.page.links_with(:href => %r{\/\d+}).each do |article|
  link = "#{url}#{article.href}"
  begin
    page = agent.get(link,{'Cache-Control' => 'no-cache'})  
    rescue Mechanize::ResponseCodeError
      puts $!.response_code
    end
    
    uri = URI.parse(link)
    req = Net::HTTP::Get.new(uri.path)
    req.add_field("Cache-Control", "no-cache")

    response = Net::HTTP.new(uri.host, uri.port).start do |http|
      http.request(req)
    end
    puts "#{response.code} #{link}"
    if (response.code.to_i != 200)
      exit(response.code.to_i)
    end
end
