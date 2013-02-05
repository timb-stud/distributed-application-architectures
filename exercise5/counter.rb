#!/usr/bin/env ruby


abort("Usage: #{__FILE__} FILE") unless ARGV.size() >= 1

fileNames = ARGV

sent_APPL_sum = 0.0
sent_Other_sum = 0.0

fileNames.each {|fileName|
	file = File.new(fileName, "r")
	sentAPPL = 0
	sentOther = 0
	begin
		while (line = file.gets)
			if (line.match(/SEND/))
				if(line.match(/APPL/))
					sentAPPL += 1
				else
					sentOther += 1
				end
			end
		end
		puts "[#{fileName}] APPL: #{sentAPPL} Other: #{sentOther} Sum: #{sentAPPL + sentOther}"
		sent_APPL_sum += sentAPPL
		sent_Other_sum += sentOther
	rescue
		puts "#{$!}"
	ensure
		file.close
	end
}

avg_APPL = sent_APPL_sum / fileNames.length
avg_Other = sent_Other_sum / fileNames.length
avg_Sum = (sent_APPL_sum + sent_Other_sum) / fileNames.length

puts "#{fileNames.length} Nodes || APPL: #{avg_APPL} Other: #{avg_Other} Sum: #{avg_Sum}"
