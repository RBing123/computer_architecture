.data
    test_data_1: .dword 0xFFFFFFFF, 0x00000000 # decimal is 4294967295 and 0, hamming distance is
    test_data_2: .dword 0x7FF00132, 0xCAE65324 # decimal is 2146435378 and 3404092196, hamming distance is
    test_data_3: .dword 0x00028E20, 0x00001843 # decimal is 167456 and 6211, hamming distance is
    print_string: .string

.text
# clz function
my_clz:
    addi sp, sp, -8      # return count and hold 1U
    sw ra, 0(sp)         # save return address
    mv s2, a0            # move input argument to saved register
    addi t0, zero, 31    # init i=31
    addi s0, zero, 1     # hold 1U
    addi s1, zero, 0     # init count = 0
    bgez t0, my_clz_loop

my_clz_loop:
    sll t1, s0, t0       # (1U << i)
    and a1, s2, t1       # x & (1U << i)
    
    beqz t2, clz_finish
    addi s1, s1, 1       # count++
    addi t0, t0, -1      # i--
    bgez t0, my_clz_loop

clz_finish:
    mv a0, t1
    ret

# hamming distance function
hamming_distance:
    addi sp, sp, -24
    xor x2, x1, x2

# main function
main:
    addi sp, sp, -12 # 3 variables need to be saved

    # store the data to stack
    lw t0, test_data_1
    sw t0, 0(sp)
    lw t0, test_data_2
    sw t0, 4(sp)
    lw t0, test_data_3
    sw t0, 8(sp)

    # initialize main loop
    addi s0, zero, 3 # number of test cases
    addi s1, zero, 1 # count of test case
    addi s2, sp, 0 # point to test_data_1

main_func:
    la a0, print_string
    li a7, 4
    ecall

    lw a1, 0(sp)
    


