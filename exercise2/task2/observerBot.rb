#!/usr/bin/env ruby

require 'socket'
require 'json'

# Add comments

abort("Usage: #{__FILE__} ID [NEIGHBOR_IDs]") unless ARGV.size() > 0

HOST = 'localhost'
NAME = ARGV[0]
SERVER = TCPServer.new(NAME)
NEIGHBORS = ARGV.slice(1, ARGV.size() -1)

ACTION_MSGCOUNT = 'msgcount'

$sendMessages = 0
$receivedMessages = 0

puts "Bot #{NAME} has #{NEIGHBORS.size()} neighbors: #{NEIGHBORS.join(", ")}."


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
	puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} iii      | s:#{$sendMessages} r: #{$receivedMessages}"
end

def logKill()
	puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} ☠☠☠      | I am dead now."
end

def logSend(destination, action, msg)
	actionChar = ">"
	case action
		when ACTION_MSGCOUNT
			actionChar = "#"
	end
	puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} >#{actionChar}> #{destination} | #{msg}"
end

def logReceive(sender, action, msg)
	actionChar = "<"
	case action
		when ACTION_MSGCOUNT
			actionChar = "#"
	end
	puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} <#{actionChar}< #{sender} | #{msg}"
end


def doActionMsgcount(sendMessages, receivedMessages)
	$sendMessages += sendMessages
	$receivedMessages += receivedMessages
	logInfo()
end

NEIGHBORS.each{|neighbor|
	send(neighbor, ACTION_MSGCOUNT, nil)
}

loop do
	Thread.start(SERVER.accept) do |socket|
		begin
			requestString = socket.gets
			requestHash = JSON.parse(requestString)
			sender = requestHash['sender']
			action = requestHash['action']
			logReceive(sender, action, requestString)
			if(isForMe(requestHash))
				if(action == ACTION_MSGCOUNT && requestHash.has_key?('received') && requestHash.has_key?('send'))
					receivedMessages = Integer(requestHash['received'])
					sendMessages = Integer(requestHash['send'])
					doActionMsgcount(receivedMessages, sendMessages)
				end
			end
		rescue StandardError => e
			logError(e);
		ensure
			socket.close
		end
	end
end
