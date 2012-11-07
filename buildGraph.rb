#!/usr/bin/env ruby

abort("Usage: #{__FILE__} NODES") unless ARGV.size() == 1

NODES = Integer(ARGV[0])
PORT = 2000

nodesHash = Hash.new

def randId()
	return PORT + rand(NODES)
end

while nodesHash.length < NODES
	nodeLeft = randId()
	nodeRight = randId()
	if(nodeLeft != nodeRight && !(nodesHash[nodeRight] && nodesHash[nodeRight].include?(nodeLeft)))
		if(nodesHash[nodeLeft])
			unless(nodesHash[nodeLeft].include?(nodeRight))
				nodesHash[nodeLeft] << nodeRight 
			end
		else
			nodesHash[nodeLeft] = [nodeRight]
		end
	end
end


puts "graph Nodes {"
nodesHash.each {|key, value|
	value.each{|n|
		puts "	#{key} -- #{n}"
	}
}
puts "}"
