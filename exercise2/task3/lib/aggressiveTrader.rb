require 'lib/bot.rb'
require 'lib/trader.rb'

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
