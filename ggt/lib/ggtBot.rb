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
		if(0 < reqVal && reqVal < @value)
			newVal = @value % reqVal
			if(newVal != 0)
				@value = newVal
				logInfo()
				sendToAllNeighbors(@value)
			else
				@value = reqVal
				logInfo()
			end
		else
			if(reqVal > @value)
				newVal = reqVal % @value
				if(newVal != 0 && newVal != @value)
					if(newVal != 0)
						@value = newVal
						logInfo()
						sendToAllNeighbors(@value)
					else
						@value = reqVal
						logInfo()
					end
				end
			end
		end
	end

	def startGgt(requestHash)
		sendToAllNeighbors(@value)
	end

end
