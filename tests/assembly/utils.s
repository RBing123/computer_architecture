.globl utils
.section .data
# Buffer to hold the ASCII representation of the integer.
    buffer: .space 12
.text
# ==================================================
# This function is used to debug locally `print_int`
# Arguments:
# a0: integer to print
# ==================================================
utils:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)

    # Load the address of the buffer
    la s0, buffer
    addi s1, s0, 11  # End of buffer (space for null terminator)
    sb zero, 0(s1)   # Null-terminate the buffer

    # Handle negative numbers
    li t0, 0         # t0 will be the negative flag
    blt a0, zero, negative
    j convert_to_string

negative:
    neg a0, a0      # Make the number positive for conversion
    li t0, 1        # Set the negative flag

convert_to_string:
    # Convert integer to string by extracting digits
    li t1, 10       # t1 = 10 (divisor)
1:
    div t2, a0, t1  # t2 = a0 / 10 (quotient)
    rem t3, a0, t1  # t3 = a0 % 10 (remainder, i.e., the digit)
    addi t3, t3, 48 # Convert remainder to ASCII ('0' = 48)
    addi s1, s1, -1 # Move to the previous position in the buffer
    sb t3, 0(s1)    # Store the ASCII character in the buffer
    mv a0, t2       # Update a0 with the quotient
    bnez a0, 1b     # Repeat if the quotient is not zero

    # Add minus sign if the number was negative
    beqz t0, print_string
    addi s1, s1, -1
    sb 45, 0(s1)    # ASCII '-' = 45

print_string:
    # Print the string starting from s1
    mv a0, s1       # a0 = pointer to the string
    li a7, 4        # a7 = 4 (syscall for printing string)
    ecall

    # Restore the return address and saved registers
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    addi sp, sp, 16

    # Return from the function
    ret