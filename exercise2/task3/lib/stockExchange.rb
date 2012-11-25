require 'lib/bot.rb'

class StockExchange < Bot
	def initialize(name, marketPrice)
		super(name, [])
		@marketPrice = Integer(marketPrice)
	end

	def logInfo()
		puts "#{Time.now.strftime("%H:%M:%S")} | #{@name} iii      | #{@accountBalance}$"
	end

	# Action Handlers
	
	def marketprice(requestHash)
		sender = requestHash['sender']
		sendMsg(sender, Actions::MARKETPRICE, {'marketPrice'=> @marketPrice})
	end

	def buystocks(requestHash)
		sender = requestHash['sender']
		marketPrice = Integer(requestHash['marketPrice'])
		money = Integer(requestHash['money'])
		if(marketPrice == @marketPrice)
			stocks = money / @marketPrice
			money = 0
		else
			stocks =0
		end
		send(sender, Actions::BUYSTOCKS, {'stocks'=> stocks, 'money'=> money})
	end
	
	def sellstocks(requestHash)
		sender = requestHash['sender']
		marketPrice = Integer(requestHash['marketPrice'])
		stocks = Integer(requestHash['stocks'])
		if(marketPrice == @marketPrice)
			stocks = 0
			money = stocks * @marketPrice
		else
			money =0
		end
		send(sender, Actions::BUYSTOCKS, {'stocks'=> stocks, 'money'=> money})
	end
	
end
