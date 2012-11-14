#!/usr/bin/env ruby

# Reads the given graphviz file and creates robot processes with the same connections as the nodes in the graph.

abort("Usage: #{__FILE__} somegraph.dot") unless ARGV.size() == 1

fileName = ARGV[0]

file = File.new(fileName, "r")

nodesHash = Hash.new
begin
	while (line = file.gets)
		match = line.match(/(\d\d\d\d)\ *--\ *\d\d\d\d/)
		if (match)
			nodes = match[0].split(/\ *--\ */)
			if(nodes.length === 2 && nodes[0] != nodes[1])
				if(nodesHash[nodes[0]])
					unless(nodesHash[nodes[0]].include?(nodes[1]))
						nodesHash[nodes[0]] << nodes[1]
					end
				else
					nodesHash[nodes[0]] = [nodes[1]]
				end
				if(nodesHash[nodes[1]])
					unless(nodesHash[nodes[1]].include?(nodes[0]))
						nodesHash[nodes[1]] << nodes[0]
					end
				else
					nodesHash[nodes[1]] = [nodes[0]]
				end
			end
		end
	end

	nodesHash.each {|key, value|
		fork do
			exec "ruby robot.rb #{key} #{value.join(' ')} &"
		end
	}
rescue
	puts "#{$!}"
ensure
	file.close
end
