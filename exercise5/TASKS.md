# a)
There are no problems with < 20 nodes. Increasing the nodes to > 20 results sometimes in two problems.
The more nodes are running the more likely it is that these two problems occur.

1. unkilled node processes 
2. no GCD

# b)
## 3 Nodes
3 Nodes || APPL: 6.666 Other: 14.0 Sum: 20.6666666666667

3 Nodes || APPL: 6.666 Other: 11.0 Sum: 17.6666666666667

3 Nodes || APPL: 11.333 Other: 12.0 Sum: 23.3333333333333

## 5 Nodes
5 Nodes || APPL: 4.0 Other: 15.4 Sum: 19.4

5 Nodes || APPL: 7.6 Other: 19.6 Sum: 27.2

5 Nodes || APPL: 8.8 Other: 22.6 Sum: 31.4

## 7 Nodes
7 Nodes || APPL: 3.71428571428571 Other: 33.8571428571429 Sum: 37.5714285714286

7 Nodes || APPL: 5.14285714285714 Other: 23.0 Sum: 28.1428571428571

7 Nodes || APPL: 5.71428571428571 Other: 27.4285714285714 Sum: 33.1428571428571

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
SUM: 0.263960838317883, COUNTER: 77.0, AVG: 0.00342806283529718

## 10 Nodes
SUM: 18.2281904220584, COUNTER: 851.0, AVG: 0.0214197302256855

## 20 Nodes
SUM: 154.235277414318, COUNTER: 2527.0, AVG: 0.0610349336819622

## 40 Nodes
SUM: 6105.47464466105, COUNTER: 9033.0, AVG: 0.675907743237136

# d)
If n < 10, every node sends approximately 7 APPL messages.

If n >= 10, every node sends approximately 30 APPL messages.

Every node sends approximately (n * 5) Other messages.
