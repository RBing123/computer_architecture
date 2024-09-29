.data
    test_data_1: .dword 0xFFFFFFFF, 0x00000000 # decimal is 4294967295 and 0, hamming distance is
    test_data_2: .dword 0x7FF00132, 0xCAE65324 # decimal is 2146435378 and 3404092196, hamming distance is
    test_data_3: .dword 0x00028E20, 0x00001843 # decimal is 167456 and 6211, hamming distance is
    print_string: .string

.text
# clz function
my_clz:
    li t0, 0 # t0 is int count 
    li t1, 31 # t1 is int i

my_clz_loop:
    slli t2, a0, 1
    beqz t2, clz_finish
    addi t0, t0, 1 # count++
    addi t1, t1, -1 # i--
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

