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

### Solution
The Hamming distance between two integers is defined as the number of bit positions at which the corresponding bits are different. This can be calculated by performing a bitwise XOR operation on the two integers and then counting the number of '1's in the resulting binary number `diff`. Instead of directly counting all the '1's in `diff`, count the leading zeros using a function `my_clz`, which identifies how many irrelevant bits precede the first '1'. By shifting diff left by the number of leading zeros, we can eliminate these unnecessary bits and focus on the significant ones. Finally, iterate through the remaining bits of the shifted result to count the '1's, yielding the Hamming distance more efficiently by reducing the number of bits processed.
