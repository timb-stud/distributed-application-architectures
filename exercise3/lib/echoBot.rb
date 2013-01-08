require 'lib/bot.rb'

class EchoBot < Bot

	def initialize(name, neighbors, id)
		super(name, neighbors)
		@id = id
		@phase = 0
		@maxId = @id
		@color = "white"
		@counter = 0
		@firstNeighbor = ""
		@isInitiator = false
	end

	def reset()
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
		msg = "#{Time.now.strftime("%H:%M:%S")} | #{@name} #{char}#{actionChar}#{char} #{sender} | #{msg.chomp}"
		puts colorize(msg, @color)
	end

	def logInfo(text)
		msg = "#{Time.now.strftime("%H:%M:%S")} | #{@name} iii      | #{text}"
		puts colorize(msg, @color)
	end


	def echo_algorithm(requestHash)
		sender = requestHash['sender']
		@counter += 1
		if(@color === "white")
			@color = "red"
			@neighbors.each{|neighbor|
				if(neighbor != sender)
					sendMsg(neighbor, Actions::EXPLORER, requestHash)
				end
			}
			@firstNeighbor = sender
		end
		if(@counter === @neighbors.size)
			@color = "green"
			if(@isInitiator)
				logInfo("maxId: #{@maxId} phase: #{@phase}")
				reset()
				case @phase
				when 1
					@phase = 2
					puts "PHASE 2"
					propagate({'maxId' => @maxId})
				when 2
					@phase = 3
					puts "PHASE 3"
					propagate({'msg' => 'Max id has been propagated.'})
				when 3
					puts "THE END."
				end
			else
				if(!@firstNeighbor.empty?)
					sendMsg(@firstNeighbor, Actions::ECHO, {'maxId' => @maxId})
					reset()
				end
				@color = "white"
			end
		end
	end

	def propagate(hashMap)
		@color = "red"
		@isInitiator = true
		@neighbors.each{|neighbor|
			sendMsg(neighbor, Actions::EXPLORER, hashMap)
		}
	end

	# Action Handlers
	
	def init_echo_algorithm(requestHash)
		@phase = 1
		puts "PHASE 1"
		propagate(nil)
	end
	
	def explorer(requestHash)
		maxId = requestHash['maxId']
		msg = requestHash['msg']
		if(maxId != nil)
			@maxId = maxId
			logInfo("maxId: #{@maxId}")
		end
		if(msg != nil)
			logInfo("msg: #{msg}")
		end
		echo_algorithm(requestHash)
	end

	def echo(requestHash)
		receivedMaxId = Integer(requestHash['maxId'])
		if(@maxId < receivedMaxId)
			@maxId = receivedMaxId
		end
		echo_algorithm(requestHash)
	end
end
