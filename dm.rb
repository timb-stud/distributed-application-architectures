require 'socket'
require 'pp'
require 'json'

abort("Usage: #{__FILE__} SENDER DESTINATION ACTION") unless ARGV.size() == 3

SENDER = ARGV[0]
DESTINATION = ARGV[1]
ACTION = ARGV[2]

HOST = 'localhost'

msg = {'sender'=>SENDER, 'destination'=>DESTINATION, 'action'=>ACTION}
puts "#{pp(msg)}"

socket = TCPSocket.open(HOST, DESTINATION)
socket.puts("#{JSON.generate(msg)}\r\n")
response = socket.read
puts response
socket.close
