.globl relu

.text
    # ==========================================
    # Arguments:
    #   a0: address of matrix
    #   a1: number of elements in the matrix (n)
    # Returns:
    #   a0: relu(a0)
    # ==========================================
relu:
    # Prologue
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    mv s0, a0               # Save original a0 (matrix start address)
    li t0, 0                # counter

calculate_relu:    
    bge t0, a1, end_relu    # If we've processed n elements, end loop

    lw t1, 0(a0)            # t1: element of the matrix
    ble t1, x0, neg_value
    sw t1, 0(a0)
    j next_element

neg_value:
    sw x0, 0(a0)            # if ele. is neg. store 0

next_element:
    addi a0, a0, 4          # move to next element
    addi t0, t0, 1          # counter++
    j calculate_relu        

end_relu:
    mv a0, s0               # Restore original matrix start address into a0
    
    # Epilogue
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    
    ret