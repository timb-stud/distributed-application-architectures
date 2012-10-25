#!/usr/bin/env ruby

require 'pp'

abort("Usage: #{__FILE__} somegraph.dot") unless ARGV.size() == 1

fileName = ARGV[0]

file = File.new(fileName, "r")

nodesHash = Hash.new
begin
	while (line = file.gets)
		match = line.match(/(\d\d\d\d)\ *--\ *\d\d\d\d/)
		if (match)
			nodes = match[0].split(/\ *--\ */)
			if(nodesHash[nodes[0]])
				nodesHash[nodes[0]] << nodes[1]
			else
				nodesHash[nodes[0]] = [nodes[1]]
			end
			if(nodesHash[nodes[1]])
				nodesHash[nodes[1]] << nodes[0]
			else
				nodesHash[nodes[1]] = [nodes[0]]
			end
			pp(nodes)
		end
	end
	pp(nodesHash)

	nodesHash.each {|key, value|
		fork do
			exec "ruby node.rb #{key} #{value.join(' ')} &"
		end
	}
rescue
	puts "#{$!}"
ensure
	file.close
end
