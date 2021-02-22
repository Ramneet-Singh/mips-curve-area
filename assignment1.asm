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

    sub     $a0,    $s3,    $s1                 # f0 = x1 - x0
    add     $a1,    $s2,    $s2                 # a1 = y0+y1

    mtc1    $a1, $f2
    mtc1    $a0, $f0
    mul.d   $f0,    $f2,    $f0                 # f0 = (x1 - x0) * (y0 + y1)
    li      $t2, 2 
    mtc1    $t2, $f2
    div.d   $f0,    $f0,   $f2                  # f0 = (x1 - x0) * (y0 + y1) 
    
    mul     $t0,    $s2,    $s4
    bgt     $t0,    $zero,  pos                 # branch to label 'pos' if $a1 is greater than zero
                                                # if y0y1 > 0, jump directly to statement labelled pos
    mul     $t1,    $s4,    $s4
    mul     $t2,    $s2,    $s2                 # handle case when y0y1<0
    add     $t3,    $t2,    $t1
    sub     $t4,    $s4,    $s2

    div     $t0,    $t3,    $t4

    mtc1    $t0, $f2
    mul.d   $f0,    $f2,    $f0

                   

pos:    
    add.d   $f20,   $f20,   $f0                # f0 has current addition to the area, 
                                                # a has total area uptill now

    # Update area
    sub $s0, $s0, 1 # n <= n-1

    # Move x2,y2 to x1,y1
    
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
    la $a0, endMessage
    syscall
    li $v0, 10
    syscall
.end main