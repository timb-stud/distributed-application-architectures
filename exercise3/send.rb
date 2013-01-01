#!/usr/bin/env ruby

require 'socket'
require 'json'
require 'lib/species.rb'

# Sends messages to robots.
# You have to define the sender, destination and action (e.g. killyourself).

abort("Usage: #{__FILE__} SENDER DESTINATION ACTION [ATTRIBUTES]\n Exampe: #{__FILE__} 2000 2001 init_echo_algorithm") unless ARGV.size() >= 3

SENDER = ARGV[0]
DESTINATION = ARGV[1]
ACTION = ARGV[2]
ATTRIBUTES = ARGV.slice(3, ARGV.size() -1)

HOST = 'localhost'

attributesHash = Hash.new
ATTRIBUTES.each{|attribute|
	splitList = attribute.split(/=/)
	key = splitList[0]
	value = splitList[1]
	attributesHash[key] = value
}


msg = {'sender'=>SENDER, 'destination'=>DESTINATION, 'action'=>ACTION, 'species' => Species::INITIATOR}
msg = msg.merge(attributesHash)
json = JSON.generate(msg)
puts "#{json}"

socket = TCPSocket.open(HOST, DESTINATION)
socket.puts("#{json}\r\n")
response = socket.read
puts response
socket.close
