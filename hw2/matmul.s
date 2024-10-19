.globl matmul

matmul:
    # a0: address of input matrix 1 (i * k)
    # a1: address of input matrix 2 (k * j)
    # a2: output (output matrix pointer)
    # a3: i (rows of matrix a)
    # a4: k (cols of matrix a / rows of matrix b)
    # a5: j (cols of matrix b)

    # m loop initialization
    li t0, 0            # t0 = m = 0

m_loop:
    bge t0, a3, m_done  # if m >= i, exit loop
    
    # n loop initialization
    li t1, 0            # t1 = n = 0

n_loop:
    bge t1, a4, n_done  # if n >= k, exit loop

    # calculate address of a[m * k + n]
    mul t2, t0, a4      # t2 = m * k
    add t2, t2, t1      # t2 = m * k + n
    slli t2, t2, 2      # t2 = (m * k + n) * 4 (each int is 4 bytes)
    add t3, a0, t2      # t3 = &a[m * k + n]
    lw t4, 0(t3)        # t4 = a[m * k + n], r = t4

    # l loop initialization
    li t5, 0            # t5 = l = 0

l_loop:
    bge t5, a5, l_done  # if l >= j, exit loop

    # calculate output[m * j + l]
    mul t6, t0, a5      # t6 = m * j
    add t6, t6, t5      # t6 = m * j + l
    slli t6, t6, 2      # t6 = (m * j + l) * 4
    add t7, a2, t6      # t7 = &output[m * j + l]
    lw t8, 0(t7)        # t8 = output[m * j + l]

    # calculate b[n * j + l]
    mul t9, t1, a5      # t9 = n * j
    add t9, t9, t5      # t9 = n * j + l
    slli t9, t9, 2      # t9 = (n * j + l) * 4
    add t10, a1, t9     # t10 = &b[n * j + l]
    lw t11, 0(t10)      # t11 = b[n * j + l]

    # multiply and accumulate
    mul t11, t11, t4    # t11 = r * b[n * j + l]
    add t8, t8, t11     # t8 = output[m * j + l] + r * b[n * j + l]
    sw t8, 0(t7)        # store back result

    # increment l loop counter
    addi t5, t5, 1      # l++

    j l_loop            # jump back to l_loop

l_done:
    # increment n loop counter
    addi t1, t1, 1      # n++

    j n_loop            # jump back to n_loop

n_done:
    # increment m loop counter
    addi t0, t0, 1      # m++

    j m_loop            # jump back to m_loop

m_done:
    ret                 # return from function