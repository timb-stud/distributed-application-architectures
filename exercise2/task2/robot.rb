#!/usr/bin/env ruby

require 'socket'
require 'json'
require 'actions.rb'

# A robot that waits for incoming messages.
# (The first received message gets sent to all neigbors.)
#
# Messages:
# 	- killyourself : send this message to all your neighbors and kill your own process

abort("Usage: #{__FILE__} ID [NEIGHBOR_IDs]") unless ARGV.size() > 0

HOST = 'localhost'
NAME = ARGV[0]
NEIGHBORS = ARGV.slice(1, ARGV.size() -1)

$msgCounter = NEIGHBORS.size()
$accountBalance = 1000

$sendMessages = 0
$receivedMessages = 0

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
		logSend(destination, action, msg)
	rescue StandardError => e
		logError(e)
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

def logError(e)
	puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} eee      | #{e.backtrace}"
end

def logInfo()
	puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} iii      | #{$accountBalance}$"
end

def logKill()
	puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} ☠☠☠      | I am dead now."
end

def logAction(sender, action, msg, char)
	actionChar = char
	case action
		when Actions::KILLYOURSELF
			actionChar = "☠"
		when Actions::MONEYTRANSACTION
			actionChar = "$"
		when Actions::MSGCOUNT
			actionChar = "#"
	end
	puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} #{char}#{actionChar}#{char} #{sender} | #{msg}"
end

def logSend(destination, action, msg)
	logAction(destination, action, msg, ">")
end

def logReceive(sender, action, msg)
	logAction(sender, action, msg, "<")
end

def doActionKillyourself(sender)
	$receivedMessages += 1
	NEIGHBORS.each {|neighbor|
		if(neighbor != sender)
			if(send(neighbor, Actions::KILLYOURSELF, nil))
				$sendMessages += 1
			end
		end
	}
	logInfo()
	logKill()
	abort()
end

def doActionMoneyTransaction(incomingMoneyAmount)
	$receivedMessages += 1
	logInfo()
	$accountBalance += incomingMoneyAmount
	logInfo()
	$msgCounter.times do
		outgoingMoneyAmount = 1 + rand(10)
		if(send(randomNeighbor(), Actions::MONEYTRANSACTION, {'moneyAmount'=> outgoingMoneyAmount}))
			$sendMessages += 1
			$accountBalance -= outgoingMoneyAmount
		end
	end
	$msgCounter -= 1
	logInfo()
end

def doActionMsgcount(sender)
	send(sender, Actions::MSGCOUNT, {'received' => $receivedMessages, 'send' => $sendMessages})
end

loop do
	Thread.start(server.accept) do |socket|
		begin
			requestString = socket.gets
			requestHash = JSON.parse(requestString)
			sender = requestHash['sender']
			action = requestHash['action']
			logReceive(sender, action, requestString)
			if(isForMe(requestHash))
				if(action == Actions::KILLYOURSELF)
					doActionKillyourself(sender)
				elsif(action == Actions::MONEYTRANSACTION && requestHash.has_key?('moneyAmount'))
					incomingMoneyAmount = Integer(requestHash['moneyAmount'])
					doActionMoneyTransaction(incomingMoneyAmount)
				elsif(action == Actions::MSGCOUNT)
					doActionMsgcount(sender)
				end
			end
		rescue StandardError => e
			logError(e);
		ensure
			socket.close
		end
	end
end
