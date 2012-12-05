#!/usr/bin/env ruby

require 'lib/stockExchange.rb'

# Skript for starting StockExchanges
 
abort("Usage: #{__FILE__} ID MARKETPRICE") unless ARGV.size() == 2

HOST = 'localhost'
NAME = ARGV[0]
MARKETPRICE = ARGV[1]

puts "Initializing Stock Exchange #{NAME} with market price: #{MARKETPRICE}"

stockExchange = StockExchange.new(NAME, MARKETPRICE)
stockExchange.start()
