# AVA Exercise 2

## Task 1 & 2
Moneytransaction & Observer Bot

### Create robots
`ruby createRobots.rb graphs/5nodes.dot`

### Init transactions & start observer
`ruby send.rb 2000 2001 moneytransaction moneyAmount=20; ruby observerBot.rb 2000 2001 2002 2003 2004 2005`

### KILLALL
`killall ruby`

## Task 3
Stock Exchange & Traders.

- Insolvency is not implemented.
- Focused on abstraction of the whole stock exchange scenario.
- New trader types (besides aggressive & relaxed) are easy to implement. (You just need to implement 2 functions)

### Create Stock Exchange
`ruby stockExchange.rb 2000 100`

### Create relaxed trader
`ruby relaxedTrader.rb 2001 2000 10000`

### Create aggressive trader
`ruby aggressiveTrader.rb 2002 2000 10000`
