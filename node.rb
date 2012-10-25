#!/usr/bin/env ruby

require 'socket'
require 'json'

abort("Usage: #{__FILE__} ID [NEIGHBOR_IDs]") unless ARGV.size() > 0

id = ARGV[0]
neighbors = ARGV.slice(1, ARGV.size() -1)

puts "ID: #{id}"
puts "Neighbors: #{neighbors}"

server = TCPServer.new id

loop do
	Thread.start(server.accept) do |socket|
		begin
			requestMsg = socket.gets
			puts "#{Time.now}: #{requestMsg}"
			responseMsg = JSON.generate({"responseMsg"=>'Hello.', "senderId"=> id})
			socket.puts responseMsg
			puts "#{Time.now}: #{responseMsg}"
			socket.close
		rescue
			puts "#{$!}"
			socket.close
		end
	end
end
