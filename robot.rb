#!/usr/bin/env ruby

require 'socket'
require 'json'

abort("Usage: #{__FILE__} ID [NEIGHBOR_IDs]") unless ARGV.size() > 0

HOST = 'localhost'
NAME = ARGV[0]
sendIdFlag = false

neighbors = ARGV.slice(1, ARGV.size() -1)

puts "Bot #{NAME} has #{neighbors.size()} neighbors: #{neighbors.join(", ")}."

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

loop do
	Thread.start(server.accept) do |socket|
		begin
			requestString = socket.gets
			requestHash = JSON.parse(requestString)
			puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} <<< #{requestHash['sender']} (#{requestHash['action']}) | #{requestString}"
			if(isForMe(requestHash))
				if(requestHash['action'] == 'killyourself')
					neighbors.each {|neighbor|
						if(neighbor != requestHash['sender'])
							send(neighbor, requestHash['action'])
						end
					}
					abort("#{Time.now.strftime("%H:%M:%S")} | #{NAME} ☠☠☠                     | I am dead now.")
				end
				if(!sendIdFlag)
					sendIdFlag = true
					neighbors.each {|neighbor|
						if(neighbor != requestHash['sender'])
							send(neighbor, requestHash['action'])
						end
					}
				end
			end
		rescue StandardError => e
			puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} eee #{e.backtrace}"
		ensure
			socket.close
		end
	end
end
