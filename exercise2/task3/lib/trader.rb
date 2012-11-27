require 'lib/bot.rb'

class Trader < Bot

	@@SLEEP_TIME = 2
	
	def initialize(name, stockExchange, accountBalance)
		super(name, [stockExchange])
		@stockExchange = stockExchange
		@accountBalance = Integer(accountBalance)
		@stocks = 0
		@currentMarketPrice
	end

	def logInfo()
		puts "#{Time.now.strftime("%H:%M:%S")} | #{@name} iii      | #{@accountBalance}$   #{@stocks} 📈  "
	end

	def updateStocksAndMoney(requestHash)
		stocks = Integer(requestHash['stocks'])
		money = Integer(requestHash['money'])
		@stocks += stocks
		@accountBalance += money
	end

	def askMarketPrice()
		sendMsg(@stockExchange, Actions::MARKETPRICE, nil)
	end

	def buyRandom(marketPrice)
		stocks = rand(10)
		money = stocks * marketPrice
		@accountBalance -= money
		sendMsg(@stockExchange, Actions::BUYSTOCKS, {'marketPrice'=> marketPrice, 'money'=> money})
	end

	def sellRandom(marketPrice)
		stocks = rand(@stocks + 1)
		@stocks -= stocks
		sendMsg(@stockExchange, Actions::SELLSTOCKS, {'marketPrice'=> marketPrice, 'stocks'=> stocks})
	end

	def start()
		Thread.new { loop { askMarketPrice(); sleep(@@SLEEP_TIME)}}
		super.start()
	end

	# Action Handlers
	
	def marketprice(requestHash)
		marketPrice = Integer(requestHash['marketPrice'])
		@currentMarketPrice = marketPrice
		logInfo()
		buyRandom(marketPrice)
		sellRandom(marketPrice)
	end

	def buystocks(requestHash)
		updateStocksAndMoney(requestHash)
	end
	
	def sellstocks(requestHash)
		updateStocksAndMoney(requestHash)
	end
end
