#!/usr/bin/env ruby

require 'lib/stockExchange.rb'

# A robot that waits for incoming messages.
# (The first received message gets sent to all neigbors.)
#
# Messages:
# 	- killyourself : send this message to all your neighbors and kill your own process

abort("Usage: #{__FILE__} ID MARKETPRICE") unless ARGV.size() == 2

HOST = 'localhost'
NAME = ARGV[0]
MARKETPRICE = ARGV[1]

puts "Initializing Stock Exchange #{NAME} with market price: #{MARKETPRICE}"

stockExchange = StockExchange.new(NAME, MARKETPRICE)
stockExchange.start()
