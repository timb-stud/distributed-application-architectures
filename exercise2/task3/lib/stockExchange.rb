require 'lib/bot.rb'

class StockExchange < Bot
	
	@@SLEEP_TIME = 3

	def initialize(name, marketPrice)
		super(name, [])
		@marketPrice = Integer(marketPrice)
		@marketPrices = [@marketPrice]
		@scatter = @marketPrice / 10
	end

	def logInfo()
		puts "#{Time.now.strftime("%H:%M:%S")} | #{@name} iii      | market price: #{@marketPrice}$"
		system('spark ' + @marketPrices.join(' '))
	end

	def updateMarketPrice()
		max = @scatter 
		r = rand((max * 2) + 1) - max
		@marketPrice  += r
		if(@marketPrice < 1)
			@marketPrice = 1
		end
		@marketPrices.push(@marketPrice)
		logInfo()
	end

	def start()
		Thread.new { loop { updateMarketPrice(); sleep(@@SLEEP_TIME)}}
		super.start()
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
		sendMsg(sender, Actions::BUYSTOCKS, {'stocks'=> stocks, 'money'=> money})
	end
	
	def sellstocks(requestHash)
		sender = requestHash['sender']
		marketPrice = Integer(requestHash['marketPrice'])
		stocks = Integer(requestHash['stocks'])
		if(marketPrice == @marketPrice)
			money = stocks * @marketPrice
			stocks = 0
		else
			money = 0
		end
		sendMsg(sender, Actions::SELLSTOCKS, {'stocks'=> stocks, 'money'=> money})
	end
	
end
