require 'lib/bot.rb'

class GgtBot < Bot
	def initialize(name, neighbors, value)
		super(name, neighbors)
		@value = value
	end

	def logInfo()
		puts "#{Time.now.strftime("%H:%M:%S")} | #{@name} iii      | #{@value}"
	end

	def sendToAllNeighbors(value)
		msgHash = {
			'value' => value
		}
		@neighbors.each{|neighbor|
			sendMsg(neighbor, Actions::GGT, msgHash)
		}
	end

	# Action Handlers
	

	def ggt(requestHash)
		logInfo()
		reqVal = Integer(requestHash['value'])
		if(reqVal < @value)
			@value = ((@value -1) % reqVal) + 1
			logInfo()
			sendToAllNeighbors(@value)
		end
		if(reqVal > @value)
			@value = ((reqVal -1) % @value) + 1
			logInfo()
			sendToAllNeighbors(@value)
		end
	end
	
	def startGgt(requestHash)
		sendToAllNeighbors(@value)
	end

end
