#!/usr/bin/env ruby


abort("Usage: #{__FILE__} FILE") unless ARGV.size() >= 1

fileNames = ARGV


time_sum = 0.0
time_counter = 0.0

fileNames.each {|fileName|
	file = File.new(fileName, "r")
	begin
		while (line = file.gets)
			match = line.match(/TIME MEASURE: (.*)/)
			if (match)
				time = match[1].to_f
				if(time > 0)
					time_sum += time
					time_counter += 1
				end
			end
		end
	rescue
		puts "#{$!}"
	ensure
		file.close
	end
}

puts "SUM: #{time_sum}, COUNTER: #{time_counter}, AVG: #{time_sum / time_counter}"
