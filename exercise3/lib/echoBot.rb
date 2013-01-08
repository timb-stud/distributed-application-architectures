require 'lib/bot.rb'

class EchoBot < Bot

	def initialize(name, neighbors, id)
		super(name, neighbors)
		@id = id
		@maxId = @id
		@color = "white"
		@counter = 0
		@firstNeighbor = ""
		@isInitiator = false
	end

	def colorize(text, color)
		color_map = {
			"white" => 37,
			"red" => 31,
			"green" => 32
		}
    	return "\e[#{color_map[color]}m#{text}\e[0m"
	end

	def logAction(sender, action, msg, char)
		actionChar = char
		case action
			when Actions::KILLYOURSELF
				actionChar = "☠"
			when Actions::MONEYTRANSACTION
				actionChar = "$"
			when Actions::MSGCOUNT
				actionChar = "#"
			when Actions::EXPLORER
				actionChar = "e"
			when Actions::ECHO
				actionChar = "E"
		end
		msg = "#{Time.now.strftime("%H:%M:%S")} | #{@name} #{char}#{actionChar}#{char} #{sender} | #{msg}"
		puts colorize(msg, @color)
	end

	def logInfo()
		msg = "#{Time.now.strftime("%H:%M:%S")} | #{@name} iii      | maxId: #{@maxId}"
		puts colorize(msg, @color)
	end


	def echo_algorithm(sender)
		@counter += 1
		if(@color === "white")
			@color = "red"
			@neighbors.each{|neighbor|
				if(neighbor != sender)
					sendMsg(neighbor, Actions::EXPLORER, nil)
				end
			}
			@firstNeighbor = sender
		end
		if(@counter === @neighbors.size)
			@color = "green"
			if(@isInitiator)
				logInfo()
				@color = "white"
			else
				if(!@firstNeighbor.empty?)
					sendMsg(@firstNeighbor, Actions::ECHO, {'maxId' => @maxId})
				end
				@color = "white"
			end
		end
	end

	# Action Handlers
	
	def init_echo_algorithm(requestHash)
		@color = "red"
		@isInitiator = true
		@neighbors.each{|neighbor|
			sendMsg(neighbor, Actions::EXPLORER, nil)
		}
	end
	
	def explorer(requestHash)
		echo_algorithm(requestHash['sender'])
	end

	def echo(requestHash)
		receivedMaxId = Integer(requestHash['maxId'])
		if(@maxId < receivedMaxId)
			@maxId = receivedMaxId
		end
		echo_algorithm(requestHash['sender'])
	end
end
