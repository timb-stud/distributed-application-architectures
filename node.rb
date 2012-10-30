#!/usr/bin/env ruby

require 'socket'
require 'json'

abort("Usage: #{__FILE__} ID [NEIGHBOR_IDs]") unless ARGV.size() > 0

id = ARGV[0]
neighbors = ARGV.slice(1, ARGV.size() -1)

puts "ID: #{id}"
puts "Neighbors: #{neighbors.join(" ")}"

server = TCPServer.new id

def send_to(neighbors, msg)
	host = 'localhost'
	neighbors.each {|neighbor|
		puts "#{neighbor}"
		socket = TCPSocket.open(host, neighbor)
		socket.puts("#{msg}\r\n")
		puts "#{Time.now}: #{msg}"
		socket.close
	}
end

loop do
	Thread.start(server.accept) do |socket|
		begin
			requestMsg = socket.gets
			puts "#{Time.now}: #{requestMsg}"
			responseMsg = JSON.generate({"responseMsg"=>'Hello.', "senderId"=> id})
			send_to(neighbors, responseMsg)
		rescue
			puts "#{$!}"
		ensure
			socket.close
		end
	end
end
