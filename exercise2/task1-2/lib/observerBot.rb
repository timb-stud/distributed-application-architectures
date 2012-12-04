require 'lib/bot.rb'

class ObserverBot < Bot

	@@SPECIES = Species::OBSERVER

	def initialize(name, neighbors, callback)
		@callback = callback
		super(name, neighbors)
		@sendMessagesSum = 0
		@receivedMessagesSum = 0
	end

	def logInfo()
		puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} iii      | s:#{@sendMessagesSum} r: #{@receivedMessagesSum}"
	end

	def observe()
		@sendMessagesSum = 0
		@receivedMessagesSum = 0
		@sendMessagesCount = 0
		@receivedMessagesCount = 0
		@neighbors.each{|neighbor|
			sendMsg(neighbor, Actions::MSGCOUNT, nil)
			sleep(1)
		}
	end

	# Action Handlers
	
	def msgcount(requestHash)
		@sendMessagesSum += Integer(requestHash['send'])
		@receivedMessagesSum += Integer(requestHash['received'])
		logInfo()
		if(@sendMessagesCount == @neighbors.size() && @sendMessagesCount == @receivedMessagesCount)
			@callback.call(@sendMessagesSum, @receivedMessagesSum)
		end
	end
end

