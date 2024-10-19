.globl matmul

.text
matmul:
    # prologue
    addi sp, sp, -16          # Allocate stack space for 4 registers
    sw ra, 12(sp)             # Save return address
    sw s0, 8(sp)              # Save s0 if used
    sw s1, 4(sp)              # Save s1 if used
    sw s2, 0(sp)              # Save s2 if used

    # a0: address of input matrix 1 (n * m)
    # a1: address of input matrix 2 (m * k)
    # a2: output (output matrix pointer)
    # a3: n (rows of matrix a)
    # a4: m (cols of matrix a / rows of matrix b)
    # a5: k (cols of matrix b)

    # i loop initialization
    li t0, 0            # t0: m = 0 for outer loop

outer_loop:
    bge t0, a3, outer_loop_done

    # l loop initialization
    li t1, 0            # t1: n = 0 for second_loop
second_loop:
    bge t1, a5, second_loop_done

    mul t2, t0, a4      # t2: m * k
    add t2, t2, t1      # t2: m * k + n
    slli t2, t2, 2      # t2: (m * k + n) * 4 (each int is 4 byte)
    lw s0, t2(a0)       # s0: hold the matrix 1 element
    
    li t2, 0            # t2: l = 0 for inner_loop

inner_loop:
    bge t2, a5, inner_loop_done

    mul t3, t1, a5      # t3: n * j
    add t3, t3, t2      # t3: n * j + l
    slli t3, t3, 2      # t3: (m * j + l) * 4 (each int is 4 byte)
    lw s1, t3(a1)       # s1: hold the output element

    mul s0, s0, s1      # matrix 1 element * matrix 2 element

    mul t4, t0, a6      # t4: m * j
    add t4, t4, t2      # t4: m * j + l
    slli t4, t4, 2      # t4: (m * j + l) * 4 (each int is 4 byte)
    lw s2, t4(a2)       # s2: hold output element

    add s2, s2, s0

    addi t2, t2, 1      # l++
    j inner_loop

inner_loop_done:
    addi t1, t1, 1

    j second_loop

second_loop_done:
    addi t0, t0, 1

    j outer_loop
outer_loop_done:
    # epilogue
    lw ra, 12(sp)
    lw s0, 8(sp)            # Restore s0 if used
    lw s1, 4(sp)            # Restore s1 if used
    lw s2, 0(sp)            # Restore s2 if used
    addi sp, sp, 16         # Deallocate stack space
    ret