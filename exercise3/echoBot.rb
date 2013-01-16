#!/usr/bin/env ruby

require 'lib/echoBot.rb'

# A robot implementation of the ECHO Algorithm [http://de.wikipedia.org/wiki/Echo-Algorithmus]
#

abort("Usage: #{__FILE__} ID [NEIGHBOR_IDs]") unless ARGV.size() > 0

HOST = 'localhost'
NAME = ARGV[0]
NEIGHBORS = ARGV.slice(1, ARGV.size() -1)
ID = rand(10000)

puts "Bot #{NAME} has #{NEIGHBORS.size()} neighbors: #{NEIGHBORS.join(", ")}. His ID is: #{ID}"

robot = EchoBot.new(NAME, NEIGHBORS, ID)
robot.start()
