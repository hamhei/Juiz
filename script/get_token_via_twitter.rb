#!/usr/bin/env ruby
# coding: utf-8

require 'rubygems'
require 'oauth'
# require 'oauth-patch'

CONSUMER_KEY = 'r0jUc3YlovqkiBx0uByUpQ'
CONSUMER_SECRET = 'i1hbdCaKOs3kUBlvoVi82EMV9grQTJ2Bgdso6beFeY'

consumer = OAuth::Consumer.new(
  CONSUMER_KEY,
  CONSUMER_SECRET,
  :site => 'http://twitter.com'
)

request_token = consumer.get_request_token

puts "Access this URL and approve => #{request_token.authorize_url}"

print "Input OAuth Verifier: "
oauth_verifier = gets.chomp.strip

access_token = request_token.get_access_token(
  :oauth_verifier => oauth_verifier
)

puts "Access token: #{access_token.token}"
puts "Access token secret: #{access_token.secret}"
