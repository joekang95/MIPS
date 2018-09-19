# This program reads input A and B to find out the x, y, and GCD by the Bézout’s identity(Ax+By=D)
    
        .text
        .globl  main
main:
		li 		$v0, 4						# String
		la 		$a0, inputA
		syscall
		la 		$a0, prompt
		syscall
		li		$v0, 5
		syscall
		move    $s0, $v0					# $s0 = A
		beq		$s0, $zero, exit			# 0 < $s0 < 214783648 (80000000h)
		blt		$s0, $zero, main
B:
		li 		$v0, 4						# String
		la 		$a0, inputB
		syscall
		la 		$a0, prompt
		syscall
		li		$v0, 5
		syscall
		move    $s1, $v0					# $s1 = B     
		beq 	$s1, $zero, exit			# 0 < $s1 < 214783648
		blt     $s1, $zero, B
		move	$t0, $s0					# $t0 = smaller of A and B
		move	$t1, $s1					# $t1 = larger of A and B
set:
		# Set smaller number
		bgt		$t0, $t1, swap
		j		GCD

swap:
		# Change smaller number
		move	$t0, $s1
		move	$t1, $s0
		j		set
GCD:
		# Find the GCD of A and B
		rem		$t2, $t1, $t0				# $t2 = remainder
		move	$t1, $t0					
		move	$t0, $t2
		bnez	$t0, GCD
		move	$s2, $t1					# $s2 = GCD
preset:
		# Preset of finding x and y (A/GCD)x+(B/GCD)y = 1
		beq		$s0, $s1, same2				# If inputs are same number
		beq		$s0, $s2, same				# If GCD is one of the input
		beq		$s1, $s2, same
		div		$t0, $s0, $s2				# $t0 = A/GCD
		div		$t1, $s1, $s2				# $t1 = B/GCD
		li		$t2, 1
		li		$s4, 0
		bge		$t0, $t1, pushing				
		move	$s3, $t0					# Let $t0 >= $t1
		move	$t0, $t1
		move	$t1, $s3
		li		$s3, 1						# $s3 = if swapped or not
pushing:
		# Push needed numbers to stack
		div		$t2, $t0, $t1				# $t2 = quotient
		rem		$t3, $t0, $t1				# $t3 = remainder
		addi	$sp, $sp, -12				# new 3 stack layer
		addi	$s4, $s4, 12				# $s4 = counter of layers
		sw		$t0, 8($sp)
		sw		$t1, 4($sp)
		sw		$t2, 0($sp)
		move	$t0, $t1
		move	$t1, $t3
		bnez	$t3, pushing
		addi	$sp, $sp, 12
		addi	$s4, $s4, -12
countset:
		# Preset of counting first set of (x,y)
		lw		$t0, 0($sp)
		lw		$t1, 4($sp)
		lw		$t2, 8($sp)
		addi	$sp, $sp, 12
		addi	$s4, $s4, -12
		sub		$t0, $zero, $t0
count:
		# Count first set of (x,y)
		lw		$t3, 0($sp)
		lw		$t4, 4($sp)
		lw		$t5, 8($sp)
		addi	$sp, $sp, 12
		addi	$s4, $s4, -12
		sub		$t3, $zero, $t3
		mul		$t1, $t0, $t5
		mul		$t6, $t3, $t4
		mul		$t0, $t0, $t6
		add		$t0, $t0, $t2
		div		$t0, $t0, $t4
		move	$t2, $t1
		move	$t1, $t4
		bnez	$s4, count	
		move	$s5, $t0					# $s5 = x
		div		$s6, $t2, $t5				# $s6 = y
		bnez	$s3, final
		move	$s4, $s5
		move	$s5, $s6
		move	$s6, $s4
		j		final
same2:
		# If inputs are the same
		li 		$s5, 0
		li 		$s6, 1
		j		final
same:
		# If GCD = A OR GCD = B
		slt		$s5, $s0, $s1
		slt		$s6, $s1, $s0
final:	
		# Save and print x and y and GCD
		li		$v0, 4						# String
		la		$a0, outputX
		syscall
		li		$v0, 1						# Print Int
		move	$a0, $s5
		syscall								# Print x
		li		$v0, 4						# String
		la		$a0, nl
		syscall
		la		$a0, outputY
		syscall
		li		$v0, 1						# Print Int
		move	$a0, $s6					
		syscall								# Print y								# Print x
		li		$v0, 4						# String
		la		$a0, nl
		syscall
		la		$a0, outGCD
		syscall
		li		$v0, 1						# Print Int
		move	$a0, $s2					# Print GCD				
		syscall	
		li		$v0, 4						# String
		la		$a0, nl
		syscall
		j		main
exit:			
		li      $v0, 10
		syscall
		
		.data
prompt: .asciiz ">"                    		# Input prompt	
nl:		.asciiz "\n"						# New line
inputA:	.asciiz "Please Enter Number A (0 < A < 2,147,483,648) <0 to exit>\n"
inputB:	.asciiz "Please Enter Number B (0 < B < 2,147,483,648) <0 to exit>\n"
outputX:.asciiz " x  = "
outputY:.asciiz " y  = "
outGCD:	.asciiz "GCD = "