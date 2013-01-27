# AVA Exercise 4
Moneytransactions & [Snapshot algorithm](http://en.wikipedia.org/wiki/Snapshot_algorithm)

### Create robots
	ruby createRobots.rb graphs/5nodes.dot

### Init transactions & start observer
	ruby send.rb 2000 2001 moneytransaction moneyAmount=20; ruby observerBot.rb 2000 2001 2002 2003 2004 2005

### KILLALL
	killall ruby
