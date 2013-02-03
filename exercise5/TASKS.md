# a)
There are no problems with < 20 nodes. Increasing the nodes to > 20 results sometimes in two problems.
The more nodes are running the more likely it is that these two problems occur.

1. unkilled node processes 
2. no GCD

# b)

5 Nodes || APPL: 4.0 Other: 15.4 Sum: 19.4
5 Nodes || APPL: 7.6 Other: 19.6 Sum: 27.2
5 Nodes || APPL: 8.8 Other: 22.6 Sum: 31.4


10 Nodes || APPL: 32.5 Other: 52.6 Sum: 85.1
10 Nodes || APPL: 34.0 Other: 53.2 Sum: 87.2
10 Nodes || APPL: 31.5 Other: 58.0 Sum: 89.5

20 Nodes || APPL: 35.25 Other: 117.0 Sum: 152.25
20 Nodes || APPL: 31.25 Other: 115.95 Sum: 147.2
20 Nodes || APPL: 32.5 Other: 113.1 Sum: 145.6


40 Nodes || APPL: 26.75 Other: 224.05 Sum: 250.8
40 Nodes || APPL: 14.375 Other: 214.175 Sum: 228.55
40 Nodes || APPL: 19.875 Other: 222.975 Sum: 242.85


# c)
## 3 Nodes
SUM: 0.246732, COUNTER: 54.0, AVG: 0.00456911111111111

## 10 Nodes
SUM: 4.569707, COUNTER: 678.0, AVG: 0.0067399808259587

## 20 Nodes
SUM: 21.596311, COUNTER: 2279.0, AVG: 0.00947622246599387

## 40 Nodes
SUM: 93.827462, COUNTER: 7156.0, AVG: 0.013111719116825

# d)

APPL = is not linear. I would need to test with more than 40 nodes to be more precise here. But unfortunately I don't get a GCD with 100 nodes or more.

Other = n * 5
