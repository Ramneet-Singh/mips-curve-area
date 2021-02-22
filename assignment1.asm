# Data Declarations

.data
numPrompt : .asciiz "\nEnter the number of coordinates: "
ansPrompt : .asciiz "\nArea under the curve: "
firstXPrompt : .asciiz "\nEnter the first x-coordinate: "
firstYPrompt : .asciiz "\nEnter the first y-coordinate: "
nextXPrompt : .asciiz "\nEnter the next x-coordinate: "
nextYPrompt : .asciiz "\nEnter the next y-coordinate: "
endMessage : .asciiz "\nExecution Ending" 
zero : .double 0.0
two : .double 2.0

# Code Section

.text
.globl main
.ent main


# n is stored in $s0
# last x is stored in $s1
# last y is stored in $s2
# new x is stored in $s3
# new y is stored in $s4

main:
    # Display Prompt for n
    li $v0, 4
    la $a0, numPrompt
    syscall

    # Store user input as n
    li $v0, 5
    syscall

    # Save value of n to preserve through loop
    move $s0, $v0

    # If n<=1, output zero
    li $t0, 1 # store 1
    ble		$s0, $t0, outputZero	# if n <= 1 then output zero

    # Register Mapping: n => s0, x1 => s1, y1 => s2, x2 => s3, y2 => s4, area => f20-f21
    
    # Enter first x-coordinate:
    li $v0, 4
    la $a0, firstXPrompt
    syscall

    li $v0, 5
    syscall
    move $s1, $v0

    # Enter first y-coordinate:
    li $v0, 4
    la $a0, firstYPrompt
    syscall

    li $v0, 5
    syscall
    move $s2, $v0

    sub $s0, $s0, 1 # n <= n-1
    l.d $f20, zero # Initialize area to 0

computeLoop:
    # Enter next x-coordinate:
    li $v0, 4
    la $a0, nextXPrompt
    syscall

    li $v0, 5
    syscall
    move $s3, $v0

    # Enter next y-coordinate:
    li $v0, 4
    la $a0, nextYPrompt
    syscall

    li $v0, 5
    syscall
    move $s4, $v0

    # Perform some computation

    # Move x1, x2 to floating point registers
    # f4 => x1
    mtc1 $s1, $f4
    # f6 => x2
    mtc1 $s3, $f6
    # Convert representation from 32-bit integer to 64-bit floating point
    cvt.d.w $f4, $f4
    cvt.d.w $f6, $f6
    # f4 => x2-x1
    sub.d $f4, $f6, $f4
    # f4 => (x2-x1)/2.0
    l.d $f6, two
    div.d $f4, $f4, $f6

    # Move y1, y2 to floating point registers
    # f6 => y1
    mtc1 $s2, $f6
    #f8 => y2
    mtc1 $s4, $f8
    # Convert representation from 32-bit integer to 64-bit floating point
    cvt.d.w $f6, $f6
    cvt.d.w $f8, $f8

    bgez $s2, y1_pos
    
    # y1<0 if this is executed
    bgez $s4, neg_product

    # y1<0, y2<0 if this is executed
    j pos_product

    y1_pos:
    # y1>=0
    bgez $s4, pos_product

    # either y1<0 and y2>=0 or y1>=0 and y2<0
    neg_product:
    # f6 => absolute(y1)
    abs.d $f6, $f6
    # f8 => absolute(y2)
    abs.d $f8, $f8

    # Compute (y1^2 + y2^2)
    # f10 => y1^2
    mul.d $f10, $f6, $f6
    # f16 => y2^2
    mul.d $f16, $f8, $f8
    # f10 => (y1^2+y2^2)
    add.d $f10, $f10, $f16

    # Compute (absolute(y1)+absolute(y2))
    # f6 => (absolute(y1)+absolute(y2))
    add.d $f6, $f6, $f8

    # Compute (y1^2+y2^2)/(absolute(y1)+absolute(y2))
    # f6 => (y1^2+y2^2)/(absolute(y1)+absolute(y2))
    div.d $f6, $f10, $f6
    j post_product_step

    # either y1>=0 and y2>=0 or y1<0 and y2<0
    pos_product:
    # f6 => absolute(y1)
    abs.d $f6, $f6
    # f8 => absolute(y2)
    abs.d $f8, $f8

    # Compute (absolute(y1)+absolute(y2))
    # f6 => (absolute(y1)+absolute(y2))
    add.d $f6, $f6, $f8

    post_product_step:
    # Multiply f6 contents by (x2-x1)/2.0
    # f6 => Area between points (x1,y1) and (x2,y2)
    mul.d $f6, $f6, $f4

    # Update the total area calculated till now
    add.d $f20, $f20, $f6
    
    sub $s0, $s0, 1 # n <= n-1

    # Move x2,y2 to x1,y1 if not(x1==x2 AND y1>y2)
    
    bne $s1, $s3, notEqualX
    bgt $s2, $s4, skipMove
    
    notEqualX:
    move $s1, $s3
    move $s2, $s4
    
    skipMove:
    bgtz $s0, computeLoop 
    j terminate

outputZero:
    li $v0, 4
    la $a0, ansPrompt
    syscall
    
    li $a0, 0
    li $v0, 1
    syscall

terminate:
    li $v0, 4
    la $a0, ansPrompt
    syscall
    
    # Printing out area
    li $v0, 3
    mov.d $f12, $f20
    syscall

    li $v0, 4
    la $a0, endMessage
    syscall
    li $v0, 10
    syscall
.end main