#!/usr/bin/env ruby

require 'lib/observerBot.rb'

# A robot that waits for incoming messages.
# (The first received message gets sent to all neigbors.)
#
# Messages:
# 	- killyourself : send this message to all your neighbors and kill your own process

abort("Usage: #{__FILE__} ID [NEIGHBOR_IDs]") unless ARGV.size() > 0

HOST = 'localhost'
NAME = ARGV[0]
NEIGHBORS = ARGV.slice(1, ARGV.size() -1)

puts "Bot #{NAME} has #{NEIGHBORS.size()} neighbors: #{NEIGHBORS.join(", ")}."


$oldSendSum = -1
$oldReceivedSum = -1

def callback(sendSum, receivedSum)
	if(sendSum == $oldSendSum && receivedSum == $oldReceivedSum)
		puts "Result: (sendSum: #{sendSum}) (receivedSum: #{receivedSum})"
	else
		$oldSendSum = sendSum
		$oldReceivedSum = receivedSum
		puts "Let's try it again."
		$robot.observe()
	end
end

$robot = ObserverBot.new(NAME, NEIGHBORS, method(:callback))
$robot.observe()
$robot.start()
