require 'lib/bot.rb'
require 'lib/trader.rb'

# Imlementation of an aggressive trader:
#  - buys as much stocks as possible if the current market price is higher than the last market price update
#  - sells as much stocks as possible if the current market price is lower than the last market price udpate

class AggressiveTrader < Trader

	def determineStocksToBuy(max)
		if(@currentMarketPrice > @marketPrices[@marketPrices.size() -2])
			return max
		else
			return 0
		end
	end

	def determineStocksToSell(max)
		if(@currentMarketPrice < @marketPrices[@marketPrices.size() -2])
			return max
		else
			return 0
		end
	end

end
