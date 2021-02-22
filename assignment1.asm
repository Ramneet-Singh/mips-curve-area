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

    # Update area
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
    la $a0, endMessage
    syscall
    li $v0, 10
    syscall
.end main