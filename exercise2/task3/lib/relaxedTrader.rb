require 'lib/bot.rb'
require 'lib/trader.rb'

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
