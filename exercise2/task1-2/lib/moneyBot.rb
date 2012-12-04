require 'lib/bot.rb'

class MoneyBot < Bot
	def initialize(name, neighbors, accountBalance)
		super(name, neighbors)
		@moneyMsgCounter = @neighbors.size()
		@accountBalance = accountBalance
	end

	def logInfo()
		puts "#{Time.now.strftime("%H:%M:%S")} | #{@name} iii      | #{@accountBalance}$"
	end

	# Action Handlers
	
	def moneytransaction(requestHash)
		sleep(2)
		incomingMoneyAmount = Integer(requestHash['moneyAmount'])
		logInfo()
		@accountBalance += incomingMoneyAmount
		logInfo()
		@moneyMsgCounter.times do
			outgoingMoneyAmount = 1 + rand(10)
			if(sendMsg(randomNeighbor(), Actions::MONEYTRANSACTION, {'moneyAmount'=> outgoingMoneyAmount}))
				@accountBalance -= outgoingMoneyAmount
			end
		end
		@moneyMsgCounter -= 1
		logInfo()
	end
end
