# Computer Architecture
## Assignment1: Compute Hamming Distance with counting leading zero
The assignment is implemented with [RISC-V](https://en.wikipedia.org/wiki/RISC-V) assembly code and [Ripes](https://github.com/mortbopet/Ripes)
### Analyze
Problem C in the quiz1 contains about count leading zero (CLZ). Counting leading zeros is crucial in converting floating-point numbers, particularly in the context of normalization and precision representation.
### Motivation
[Hamming distance](https://en.wikipedia.org/wiki/Hamming_distance) is a metric used to measure the difference between two binary strings (or bit sequences) of equal length. It is defined as the number of positions at which the corresponding bits are different.

### Problem
According to the above description, the CLZ problem is similar to calculating hamming distance.
[leetcode 461. Hamming Distance](https://leetcode.com/problems/hamming-distance/description/)
> Description : The Hamming distance between two integers is the number of positions at which the corresponding bits are different.
> 
> Given two integers x and y, return the Hamming distance between them.

```
Example : 
Input: x = 1, y = 4
Output: 2
Explanation:
1   (0 0 0 1)
4   (0 1 0 0)
       ↑   ↑
```

The above arrows point to positions where the corresponding bits are different.
