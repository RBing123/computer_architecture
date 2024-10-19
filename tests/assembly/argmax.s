.globl argmax
.extern matmul
.text
argmax:
    # Arguments:
    #   a0: the pointer to the start of the vector
    #   a1: the # pointer of elements in the vector
    # Returns:
    #   a0: the first index of the largest element
    
    li t0, 1
    blt a1, t0, error_empty_vector

    # prologue
    addi sp, sp, -20
    sw ra, 16(sp)

error_empty_vector: