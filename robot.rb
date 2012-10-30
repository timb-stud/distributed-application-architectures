#!/usr/bin/env ruby

require 'socket'
require 'json'

abort("Usage: #{__FILE__} ID [NEIGHBOR_IDs]") unless ARGV.size() > 0

HOST = 'localhost'
NAME = ARGV[0]

neighbors = ARGV.slice(1, ARGV.size() -1)

puts "ID: #{NAME} Neighbors: #{neighbors.join(" ")}"

server = TCPServer.new(NAME) 

def send(destination, action)
	begin
		socket = TCPSocket.open(HOST, destination)
		msgHash = {'sender'=>NAME, 'destination'=>destination, 'action'=>action}
		msg = JSON.generate(msgHash)
		socket.puts("#{msg}\r\n")
		puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} >>> #{msg}"
	rescue
		puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} ::: #{$!}"
	ensure
		if(socket != nil)
			socket.close
		end
	end
end

def isForMe(msg)
	return msg['destination'] == NAME
end

loop do
	Thread.start(server.accept) do |socket|
		begin
			requestString = socket.gets
			puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} <<< #{requestString}"
			requestHash = JSON.parse(requestString)
			if(isForMe(requestHash))
				neighbors.each {|neighbor|
					if(neighbor != requestHash['sender'])
						send(neighbor, "quit")
					end
				}
				if(requestHash['action'] == 'quit')
						puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} ::: Shutting down."
						abort()
				end
			end
		rescue StandardError => e
			puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} eee #{e.backtrace}"
		ensure
			socket.close
		end
	end
end
