require 'socket'
require 'json'
require 'lib/actions.rb'
require 'lib/species.rb'

class Bot
	@@HOST = "localhost"
	@@SPECIES = Species::ROBOT

	def initialize(name, neighbors)
		@name = name
		@neighbors = neighbors
		@receivedMessagesCount = 0
		@sendMessagesCount = 0
		@server = TCPServer.new(name)
	end

	def isForMe(msg)
		return msg['destination'] == @name 
	end

	def isFromRobot(msg)
		return msg['species'] == Species::ROBOT
	end

	def logError(e)
		puts "#{Time.now.strftime("%H:%M:%S")} | #{@name} eee      | #{e}: #{e.backtrace}"
	end

	def logInfo()
		puts "#{Time.now.strftime("%H:%M:%S")} | #{@name} iii      |"
	end

	def logKill()
		puts "#{Time.now.strftime("%H:%M:%S")} | #{@name} ☠☠☠      | I am dead now."
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
			when Actions::SNAPSHOT
				actionChar = "S"
			when Actions::FORWARD
				actionChar = "F"
		end
		puts "#{Time.now.strftime("%H:%M:%S")} | #{@name} #{char}#{actionChar}#{char} #{sender} | #{msg}"
	end

	def logSend(destination, action, msg)
		logAction(destination, action, msg, ">")
	end

	def logReceive(sender, action, msg)
		logAction(sender, action, msg, "<")
	end

	def randomNeighbor()
		return @neighbors.at(rand(@neighbors.size()))
	end

	def sendMsg(destination, action, additionalAttributes)
		begin
			socket = TCPSocket.open(@@HOST, destination)
			msgHash = {'sender'=>@name, 'destination'=>destination, 'action'=>action, 'species'=> @@SPECIES}
			if(additionalAttributes != nil)
				msgHash = msgHash.merge(additionalAttributes)
			end
			msg = JSON.generate(msgHash)
			socket.puts("#{msg}\r\n")
			@sendMessagesCount += 1
			logSend(destination, action, msg)
		rescue StandardError => e
			logError(e)
			return false
		ensure
			if(socket != nil)
				socket.close
			end
		end
		return true
	end

	def start()
		loop do
			Thread.start(@server.accept) do |socket|
				handleSocket(socket)
			end
		end
	end

	def handleSocket(socket)
		begin
			requestString = socket.gets
			requestHash = JSON.parse(requestString)
			sender = requestHash['sender']
			action = requestHash['action']
			logReceive(sender, action, requestString)
			if(isForMe(requestHash))
				if(isFromRobot(requestHash))
					@receivedMessagesCount += 1
				end
				self.send(action, requestHash)
			end
		rescue StandardError => e
			logError(e);
		ensure
			socket.close
		end
	end

	#Action Handlers
	
	def killyourself(requestHash)
		sender = requestHash['sender']
		@neighbors.each {|neighbor|
			if(neighbor != sender)
				sendMsg(neighbor, Actions::KILLYOURSELF, nil)
			end
		}
		logInfo()
		logKill()
		abort()
	end

	def msgcount(requestHash)
		sender = requestHash['sender']
		sendMsg(sender, Actions::MSGCOUNT, {'received' => @receivedMessagesCount, 'send' => @sendMessagesCount})
		unless(isFromRobot(requestHash))
			@sendMessagesCount -= 1
		end
	end


end
