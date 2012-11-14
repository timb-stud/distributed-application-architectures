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

NEIGHBORS = ARGV.slice(1, ARGV.size() -1)

msgCounter = NEIGHBORS.size()
accountBalance = rand(1000)

puts "Bot #{NAME} has #{NEIGHBORS.size()} neighbors: #{NEIGHBORS.join(", ")}."

server = TCPServer.new(NAME) 

def send(destination, action)
	begin
		socket = TCPSocket.open(HOST, destination)
		msgHash = {'sender'=>NAME, 'destination'=>destination, 'action'=>action}
		msg = JSON.generate(msgHash)
		socket.puts("#{msg}\r\n")
		puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} >>> #{destination} (#{action}) | #{msg}"
	rescue
		puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} eee                     | #{$!}"
	ensure
		if(socket != nil)
			socket.close
		end
	end
end

def isForMe(msg)
	return msg['destination'] == NAME
end

def doActionKillyourself(sender)
	NEIGHBORS.each {|neighbor|
		if(neighbor != sender)
			send(neighbor, ACTION_KILLYOURSELF)
		end
	}
	abort("#{Time.now.strftime("%H:%M:%S")} | #{NAME} ☠☠☠                     | I am dead now.")
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
			end
		rescue StandardError => e
			puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} eee #{e.backtrace}"
		ensure
			socket.close
		end
	end
end
