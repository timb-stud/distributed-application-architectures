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
		puts "#{Time.now.strftime("%H:%M:%S")} | #{@name} iii      | #{@accountBalance}$   #{@stocks}#  #{@currentMarketPrice}$  #{@currentMarketPrice * @stocks + @accountBalance}$"
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

	def can_buy?(marketPrice)
		return @accountBalance > marketPrice
	end

	def can_sell?(marketPrice)
		return @stocks > 0
	end

	def buy(marketPrice, money)
		@accountBalance -= money
		sendMsg(@stockExchange, Actions::BUYSTOCKS, {'marketPrice'=> marketPrice, 'money'=> money})
	end

	def sell(marketPrice, stocks)
		@stocks -= stocks
		sendMsg(@stockExchange, Actions::SELLSTOCKS, {'marketPrice'=> marketPrice, 'stocks'=> stocks})
	end

	def stocksToBuy(marketPrice)
		max = @accountBalance / marketPrice
		return rand(max)
	end

	def stocksToSell(marketPrice)
		max = @stocks
		return rand(max)
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
		if(can_buy?(marketPrice))
			money = stocksToBuy(marketPrice) * marketPrice
			buy(marketPrice, money)
		end
		if(can_sell?(marketPrice))
			stocks = stocksToSell(marketPrice)
			sell(marketPrice, stocks)
		end
	end

	def buystocks(requestHash)
		updateStocksAndMoney(requestHash)
	end
	
	def sellstocks(requestHash)
		updateStocksAndMoney(requestHash)
	end
end
