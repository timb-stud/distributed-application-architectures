require 'socket'

abort("Usage: #{__FILE__} ID MSG") unless ARGV.size() == 2

id = ARGV[0]
msg = ARGV[1]

host = 'localhost'

socket = TCPSocket.open(host, id)
socket.puts("#{msg}\r\n")
response = socket.read
puts response
