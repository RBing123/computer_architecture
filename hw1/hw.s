.data
    test_data_1: .word 0xFFFFFFFF, 0x00000000 # decimal is 4294967295 and 0, hamming distance is 32
    test_data_2: .word 0x7FF00132, 0xCAE65324 # decimal is 2146435378 and 3404092196, hamming distance is 14
    test_data_3: .word 0x00028E20, 0x00001843 # decimal is 167456 and 6211, hamming distance is 9
    print_string: .string

.text
main:
    addi sp, sp, -12                # 3 variables need to be saved

    # store the data in stack
    lw t0, test_data_1
    sw t0, 0(sp)
    lw t1, test_data_2
    sw t1, 4(sp)
    lw t2, test_data_3
    sw t2, 8(sp)

    # initialize main loop
    addi s0, zero, 3        # number of test cases
    addi s1, zero, 1        # count of test case
    addi s2, sp, 0          # point to test_data_1
    
    # calculate hamming distance for each pair of data
    lw a0, 0(sp)            # load first number
    lw a1, 4(sp)            # load second number
    jal ra, hamming_distance

    lw a0, 4(sp)            # load first number of next pair
    lw a1, 8(sp)            # load second number
    jal ra, hamming_distance

    lw a0, 8(sp)            # load first number of the third pair
    lw a1, 12(sp)           # load second number
    jal ra, hamming_distance

# hamming distance
hamming_distance:
    addi sp, sp, -8         # Allocate memory for hamming_count on stack
    sw ra, 0(sp)            # save return address
    xor t0, a0, a1          # diff = x ^ y
    addi t1, t1, 0          # hamming_count = 0
    mv a0, t0               # move data to a0 and call my_clz
    jal ra, my_clz          # jump and link to my_clz

    # a0 involve with leading zero
    mv t2, a0               # move leading zero from a0 to t2
    sll t0, t0, t2          # remove leading zero
    
    # Calculate the number of remaining 1's in the diff
    addi t3, t3, 32         # 32 bits
    sub t3, t3, t2          # calculate 32 - leading zero

hamming_count_loop:
    beqz t3, hamming_done       # If t3 == 0, jump to done
    andi t4, t0, 1              # t4 = diff & 1
    beqz t4, skip_count         # If t4 == 0, skip counting
    addi t1, t1, 1              # hamming_count++

skip_count:
    srl t0, t0, 1            # diff >>= 1 (shift right)
    addi t3, t3, -1          # Decrease bit counter
    j hamming_count_loop     # Repeat loop

hamming_done:
    mv a0, t1                # Move hamming_count to a0 (return value)
    lw ra, 0(sp)             # Restore return address
    addi sp, sp, 8           # Restore stack space
    ret                      # Return from the function

# clz function
my_clz:
    addi sp, sp, -8         # return count and hold 1U
    sw ra, 0(sp)            # save return address
    mv s0, a0               # move input argument to saved register
    addi s1, zero, 0        # init count = 0
    addi t0, zero, 31       # init i=31
    addi s2, zero, 1        # hold 1U

my_clz_loop:
    sll t1, s2, t0          # (1U << i)
    and t1, s0, t1          # x & (1U << i)
    
    bnez t1, clz_finish     # if true break the loop
    addi s1, s1, 1          # count++
    addi t0, t0, -1         # i--
    bnez t0, my_clz_loop    # loop

clz_finish:
    mv a0, s1               # count(s1) move to return register
    lw ra, 0(sp)            # lw return address from 0(sp)
    addi sp, sp, 8          # stack pointer
    ret

main_func:
    la a0, print_string
    li a7, 4
    ecall

    lw a1, 0(sp)
    
end_call:
    ecall