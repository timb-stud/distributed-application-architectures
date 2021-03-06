#!/usr/bin/env ruby

require 'lib/relaxedTrader.rb'

# Skript for starting RelaxedTraders

abort("Usage: #{__FILE__} ID STOCK_EXCHANGE_ID ACCOUNT_BALANCE") unless ARGV.size() == 3

HOST = 'localhost'
NAME = ARGV[0]
STOCK_EXCHANGE_ID = ARGV[1]
ACCOUNT_BALANCE = ARGV[2]

puts "Trader #{NAME} starts with #{ACCOUNT_BALANCE}$ and is active on stock exchange #{STOCK_EXCHANGE_ID}."

robot = RelaxedTrader.new(NAME, STOCK_EXCHANGE_ID, ACCOUNT_BALANCE)
robot.start()
