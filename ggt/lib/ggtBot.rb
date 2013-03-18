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
		newVal = reqVal > @value ? (reqVal % @value) : (@value % reqVal)
		if(newVal != @value && newVal != 0)
			@value = newVal
			logInfo()
			sendToAllNeighbors(@value)
		end	
	end

	def startGgt(requestHash)
		sendToAllNeighbors(@value)
	end

end
