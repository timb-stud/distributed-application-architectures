#!/usr/bin/env ruby

require 'socket'
require 'json'

# A robot that waits for incoming messages.
# (The first received message gets sent to all neigbors.)
#
# Messages:
# 	- killyourself : send this message to all your neighbors and kill your own process

abort("Usage: #{__FILE__} ID [NEIGHBOR_IDs]") unless ARGV.size() > 0

HOST = 'localhost'
NAME = ARGV[0]

ACTION_KILLYOURSELF = 'killyourself'
ACTION_MONEYTRANSACTION = 'moneytransaction'

NEIGHBORS = ARGV.slice(1, ARGV.size() -1)

$msgCounter = NEIGHBORS.size()
$accountBalance = 1000

puts "Bot #{NAME} has #{NEIGHBORS.size()} neighbors: #{NEIGHBORS.join(", ")}."

server = TCPServer.new(NAME) 

def send(destination, action, additionalAttributes)
	begin
		socket = TCPSocket.open(HOST, destination)
		msgHash = {'sender'=>NAME, 'destination'=>destination, 'action'=>action}
		if(additionalAttributes != nil)
			msgHash = msgHash.merge(additionalAttributes)
		end
		msg = JSON.generate(msgHash)
		socket.puts("#{msg}\r\n")
		puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} >>> #{destination} (#{action}) | #{msg}"
	rescue
		puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} eee                     | #{$!}"
		return false
	ensure
		if(socket != nil)
			socket.close
		end
	end
	return true
end

def isForMe(msg)
	return msg['destination'] == NAME
end

def randomNeighbor()
	return NEIGHBORS.at(rand(NEIGHBORS.size()))
end

def doActionKillyourself(sender)
	NEIGHBORS.each {|neighbor|
		if(neighbor != sender)
			send(neighbor, ACTION_KILLYOURSELF, nil)
		end
	}
	puts ("#{Time.now.strftime("%H:%M:%S")} | #{NAME} iii                     | account balance: #{$accountBalance}")
	abort("#{Time.now.strftime("%H:%M:%S")} | #{NAME} ☠☠☠                     | I am dead now.")
end

def doActionMoneyTransaction(incomingMoneyAmount)
	puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} iii                         | account balance: #{$accountBalance}"
	$accountBalance += incomingMoneyAmount
	puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} iii                         | account balance: #{$accountBalance}"
	$msgCounter.times do
		outgoingMoneyAmount = 1 + rand(10)
		if(send(randomNeighbor(), ACTION_MONEYTRANSACTION, {'moneyAmount'=> outgoingMoneyAmount}))
			$accountBalance -= outgoingMoneyAmount
		end
	end
	$msgCounter -= 1
	puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} iii                         | account balance: #{$accountBalance}"
end

loop do
	Thread.start(server.accept) do |socket|
		begin
			requestString = socket.gets
			requestHash = JSON.parse(requestString)
			sender = requestHash['sender']
			action = requestHash['action']
			puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} <<< #{sender} (#{action}) | #{requestString}"
			if(isForMe(requestHash))
				if(action == ACTION_KILLYOURSELF)
					doActionKillyourself(sender)
				end
				if(action == ACTION_MONEYTRANSACTION && requestHash.has_key?('moneyAmount'))
					incomingMoneyAmount = Integer(requestHash['moneyAmount'])
					doActionMoneyTransaction(incomingMoneyAmount)
				end
			end
		rescue StandardError => e
			puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} eee #{e.backtrace}"
		ensure
			socket.close
		end
	end
end
