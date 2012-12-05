require 'lib/bot.rb'
require 'lib/trader.rb'

# Imlementation of a realxed trader:
#  - buys as much stocks as possible if the current market price is lower than the average market price
#  - sells as much stocks as possible if the current market price is higher than the average market price

class RelaxedTrader < Trader

	def determineStocksToBuy(max)
		if(@currentMarketPrice < avgMarketPrice())
			return max
		else
			return 0
		end
	end

	def determineStocksToSell(max)
		if(@currentMarketPrice > avgMarketPrice())
			return max
		else
			return 0
		end
	end

end
