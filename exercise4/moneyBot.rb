#!/usr/bin/env ruby

require 'lib/moneyBot.rb'

# A robot that waits for incoming messages.
# (The first received message gets sent to all neigbors.)
#
# Messages:
# 	- killyourself : send this message to all your neighbors and kill your own process

abort("Usage: #{__FILE__} ID [NEIGHBOR_IDs]") unless ARGV.size() > 0

HOST = 'localhost'
NAME = ARGV[0]
NEIGHBORS = ARGV.slice(1, ARGV.size() -1)
MONEY = 1000

puts "Bot #{NAME} has #{NEIGHBORS.size()} neighbors: #{NEIGHBORS.join(", ")} and starts with #{MONEY}$."

robot = MoneyBot.new(NAME, NEIGHBORS, MONEY)
robot.start()
