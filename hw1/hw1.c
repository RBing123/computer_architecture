#include <stdio.h>
#include <stdint.h>

uint32_t test_11 = 0xFFFFFFFF; // 32
uint32_t test_12 = 0x00000000;
uint32_t test_21 = 0x7FF00132; // 14
uint32_t test_22 = 0xCAE65324;
uint32_t test_31 = 0x00000000; // 0
uint32_t test_32 = 0x00000000;
    
static inline int my_clz(uint32_t x) {
    int count = 0;
    for (int i = 31; i >= 0; --i) {
        if (x & (1U << i))
            break;
        count++;
    }
    return count;
}

int hamming_distance(uint32_t x, uint32_t y) {
    uint32_t diff = x ^ y;
    int hamming_count = 0;

    // Shift out the leading zeros first
    int leading_zeros = my_clz(diff);
    diff <<= leading_zeros;  // Shift left to remove leading zeros

    // Count remaining '1's in diff
    for (int i = 0; i < 32 - leading_zeros; i++) {
        if (diff & (1U << (31 - i)))
            hamming_count++;
    }
    

    return hamming_count;
}

int main(void){
    printf("the hamming distance is : %d\n", hamming_distance(test_11, test_12));
    printf("the hamming distance is : %d\n", hamming_distance(test_21, test_22));
    printf("the hamming distance is : %d\n", hamming_distance(test_31, test_32));
}
