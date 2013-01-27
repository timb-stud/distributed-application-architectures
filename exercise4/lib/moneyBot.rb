require 'lib/bot.rb'

class MoneyBot < Bot
	def initialize(name, neighbors, accountBalance)
		super(name, neighbors)
		@moneyMsgCounter = @neighbors.size()
		@accountBalance = accountBalance
		@snapshotObserver = nil
	end

	def logInfo()
		puts "#{Time.now.strftime("%H:%M:%S")} | #{@name} iii      | #{@accountBalance}$ s:#{@sendMessagesCount} r:#{@receivedMessagesCount}"
	end

	def sendSnapshot(observer)
		@snapshotObserver = observer
		snapshot = {
			'snapshot' => {
				'send' => @sendMessagesCount,
				'received' => @receivedMessagesCount,
				'accountBalance' => @accountBalance
			}
		}
		sendMsg(@snapshotObserver, Actions::SNAPSHOT, snapshot)
		@sendMessagesCount -= 1
	end

	def forwardMessage(message, receiver)
		msg = {
			'msg' => message
		}
		sendMsg(receiver, Actions::FORWARD, msg)
		@sendMessagesCount -= 1
	end

	# Action Handlers
	
	def moneytransaction(requestHash)
		@receivedMessagesCount -= 1
		snapshotObserver = requestHash['snapshotObserver']
		if(@snapshotObserver == nil)
			if(snapshotObserver != nil)
				sendSnapshot(snapshotObserver)
			end
		else
			if(snapshotObserver == nil)
				forwardMessage(requestHash, @snapshotObserver)
			end
		end
		@receivedMessagesCount += 1
		incomingMoneyAmount = Integer(requestHash['moneyAmount'])
		@accountBalance += incomingMoneyAmount
		logInfo()
		sleep(4)
		@moneyMsgCounter.times do
			outgoingMoneyAmount = 1 + rand(10)
			if(sendMsg(randomNeighbor(), Actions::MONEYTRANSACTION, {'moneyAmount'=> outgoingMoneyAmount, 'snapshotObserver' => @snapshotObserver}))
				@accountBalance -= outgoingMoneyAmount
			end
		end
		@moneyMsgCounter -= 1
	end

	def snapshot(requestHash)
		if(@snapshotObserver != requestHash['sender'])
			sendSnapshot(requestHash['sender'])
		end
	end
end
