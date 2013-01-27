require 'lib/bot.rb'

class ObserverBot < Bot

	@@SPECIES = Species::OBSERVER

	def initialize(name, neighbors)
		super(name, neighbors)
		@sendMessagesSum = 0
		@receivedMessagesSum = 0
		@moneySum = 0
	end

	def logInfo()
		puts "#{Time.now.strftime("%H:%M:%S")} | #{NAME} iii      | s:#{@sendMessagesSum} r: #{@receivedMessagesSum} m: #{@moneySum}$"
	end

	def observe()
		@sendMessagesSum = 0
		@receivedMessagesSum = 0
		@moneySum = 0
		@neighbors.each{|neighbor|
			sendMsg(neighbor, Actions::SNAPSHOT, nil)
			sleep(1)
		}
	end

	# Action Handlers
	
	def snapshot(requestHash)
		@sendMessagesSum += Integer(requestHash['snapshot']['send'])
		@receivedMessagesSum += Integer(requestHash['snapshot']['received'])
		@moneySum += Integer(requestHash['snapshot']['accountBalance'])
		logInfo()
		if(@sendMessagesSum == @receivedMessagesSum)
			puts "END."
		end
	end

	def forward(requestHash)
		@moneySum += Integer(requestHash['msg']['moneyAmount'])
		@receivedMessagesSum += 1
		logInfo()
	end
end

