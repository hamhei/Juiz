#!/usr/bin/env ruby
# coding: utf-8

require 'rubygems'
require 'oauth'
# require 'oauth-patch'

CONSUMER_KEY = 'AZj3Yq6t4IfIsTq0lwzftA'
CONSUMER_SECRET = 'b2mSsZHrb8SdKmlGUtsMzyAgUc3aR7zeC0SYsBSBFRg'

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
