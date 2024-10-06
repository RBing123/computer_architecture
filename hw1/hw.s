.data
    test_data_1: .word 0xFFFFFFFF, 0x00000000 # decimal is 4294967295 and 0, hamming distance is 32
    test_data_2: .word 0x7FF00132, 0xCAE65324 # decimal is 2146435378 and 3404092196, hamming distance is 14
    test_data_3: .word 0x00028E20, 0x00001843 # decimal is 167456 and 6211, hamming distance is 9
    print_string: .string "\nHamming Distance is "

.text
main:
    addi sp, sp, -12                # 3 variables need to be saved

    # store the data in stack
    lw t0, test_data_1
    sw t0, 0(sp)
    lw t0, test_data_1+4
    sw t0, 4(sp)

    lw t0, test_data_2
    sw t0, 8(sp)
    lw t0, test_data_2+4
    sw t0, 12(sp)

    lw t0, test_data_3
    sw t0, 16(sp)
    lw t0, test_data_3+4
    sw t0, 20(sp)

    # initialize main loop
    addi s0, zero, 3        # number of test cases
    addi s1, zero, 2        # count of test case
    addi s2, sp, 0          # point to test_data_1

main_loop:    
    # Print results
    la a0, print_string     # Load print string address
    li a7, 4                # System call for print integer
    ecall

    # calculate hamming distance for each pair of data
    lw a0, 0(sp)            # load first number
    lw a1, 4(sp)          # load second number
    jal ra, hamming_distance

    li a7, 1            # print integer
    ecall               # print result of hd_cal (which is in a0)

    addi s2, s2, 4      # s2 : points to next test_data
    addi s1, s1, 1      # counter++
    bne s1, s0, main_loop

    # Exit program
    addi sp, sp, 12
    li a7, 10
    ecall

# hamming distance
hamming_distance:
    addi sp, sp, -8         # Allocate memory for hamming_count on stack
    sw ra, 0(sp)            # save return address
    xor s6, a0, a1          # diff = x ^ y
    li t4, 0                # hamming_count = 0
    mv a0, s6               # move data to a0 and call my_clz
    jal ra, my_clz          # jump and link to my_clz

    # a0 involve with leading zero
    mv t2, a0               # move leading zero from a0 to t2
    sll s6, s6, t2          # remove leading zero
    
    # Calculate the number of remaining 1's in the diff
    addi t3, zero, 32        # 32 bits
    sub t2, t3, t2          # calculate 32 - leading zero (for loop variable i)
    li a3, 1                # hold 1

hamming_count_loop:
    beqz t2, hamming_done       # If t2 == 0, jump to done
    sub s7, t3, t2              # 32-i
    sll t6, a3, s7              # (1U << (32 - i))
    and t6, s6, t6              # t6 = diff & 1U << (32 - i)
    beqz t6, skip_count         # If t6 == 0, skip counting
    addi t4, t4, 1              # hamming_count++

skip_count:
    addi t2, t2, -1          # Decrease bit counter
    j hamming_count_loop     # Repeat loop

hamming_done:
    mv a0, t4                # Move hamming_count to a0 (return value)
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

    beqz t1, count          # if (x & (1U << i)) == 0, count++
    j clz_finish

count:
    addi s1, s1, 1
    addi t0, t0, -1
    bgez t0, my_clz_loop

clz_finish:
    mv a0, s1               # count(s1) move to return register
    lw ra, 0(sp)            # lw return address from 0(sp)
    addi sp, sp, 8          # stack pointer
    ret