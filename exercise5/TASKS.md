# a)
There are no problems with < 20 nodes. Increasing the nodes to > 20 results sometimes in two problems.
The more nodes are running the more likely it is that these two problems occur.

1. unkilled node processes 
2. no GCD

# b)
## 5 Nodes
5 Nodes || APPL: 4.0 Other: 15.4 Sum: 19.4

5 Nodes || APPL: 7.6 Other: 19.6 Sum: 27.2

5 Nodes || APPL: 8.8 Other: 22.6 Sum: 31.4

## 10 Nodes
10 Nodes || APPL: 32.5 Other: 52.6 Sum: 85.1

10 Nodes || APPL: 34.0 Other: 53.2 Sum: 87.2

10 Nodes || APPL: 31.5 Other: 58.0 Sum: 89.5

## 15 Nodes
15 Nodes || APPL: 20.0 Other: 88.4 Sum: 108.4

15 Nodes || APPL: 24.667 Other: 85.4 Sum: 110.066666666667

15 Nodes || APPL: 22.333 Other: 83.1333333333333 Sum: 105.466666666667


## 20 Nodes
20 Nodes || APPL: 35.25 Other: 117.0 Sum: 152.25

20 Nodes || APPL: 31.25 Other: 115.95 Sum: 147.2

20 Nodes || APPL: 32.5 Other: 113.1 Sum: 145.6

## 25 Nodes
25 Nodes || APPL: 18.8 Other: 142.84 Sum: 161.64

25 Nodes || APPL: 34.8 Other: 145.2 Sum: 180.0

25 Nodes || APPL: 29.8 Other: 138.84 Sum: 168.64


## 30 Nodes
30 Nodes || APPL: 23.5 Other: 171.866666666667 Sum: 195.366666666667

30 Nodes || APPL: 29.833 Other: 163.666666666667 Sum: 193.5

30 Nodes || APPL: 29.666 Other: 167.233333333333 Sum: 196.9

## 40 Nodes
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
