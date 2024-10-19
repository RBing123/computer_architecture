.globl matmul

.text
# =======================================
# Arguments    
#   a0: address of input matrix 1 (n * m)
#   a1: address of input matrix 2 (m * k)
# Returns:
#   a0: address of output matrix            
# =======================================
matmul:
    # Prologue
    addi sp, sp, -16          # Allocate stack space for 4 registers
    sw ra, 12(sp)             # Save return address
    sw s0, 8(sp)              # Save s0 if used
    sw s1, 4(sp)              # Save s1 if used
    sw s2, 0(sp)              # Save s2 if used

    # i loop initialization
    li t0, 0            # t0: i = 0 for outer loop

