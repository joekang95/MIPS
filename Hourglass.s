# This program reads input 1 to print hourglass shape and 2 to print star
# Then read integer n (1<n<10) to decide the length of sides (2*n for hourglass and n for star)
    
        .text
        .globl  main
main:
		# Read which shape to print
        li      $v0, 4                  # String
        la      $a0, hello
        syscall
		la      $a0, prompt
		syscall
		li      $v0, 5                  # Read int, into $s0
        syscall
        move    $s0, $v0
		li		$t0, 1				
		li		$t1, 2
		li		$t2, -1
		beq		$s0, $t2, exit			# If input is -1, exit
		blt		$s0, $t0, main			# To insure input is 1 or 2
		bgt		$s0, $t1, main
len:
		# Read length of sides
		li      $v0, 4 					# String
		la      $a0, size
        syscall
		la      $a0, prompt
		syscall
		li      $v0, 5                  # Read int, into $s1
        syscall
        move    $s1, $v0			
		li		$t1, 10
		ble		$s1, $t0, len			# To insure input n is 1<n<10
		bge 	$s1, $t1, len
check:
		# Check which shape
		li      $t0, 1
        beq     $s0, $t0, hg
		li		$t0, 2
		beq		$s0, $t0, star
hg:		
		# Shape hourglass
		li		$v0, 4					# String
		sll		$s1, $s1, 1				# $s1 = $s1 * 2
		li		$t0, 0					# Initialize $t0
		move	$t1, $s1				# Temp for size (descending for spaces)
		move	$t2, $s1				# Counter for layer
		li		$t3, 1					# Upcounting for spaces
hg1:									
		# Print first layer
		la		$a0, st					# Print *
		addi	$s1, $s1, -1			# $s1 = #s1 - 1
		syscall
		bne		$s1, $t0, hg1			# Loop until $s1 = 0
		j 		hgnl					# Next line
hgd:	
		# Hourglass descending
		bne		$s1, $t2, hgsp
		la 		$a0, st
		addi	$s1, $s1, -1
		syscall
hgd2:
		# Hourglass descending
		bne		$s1, $t3, hgsp2
		la 		$a0, st
		syscall
		j 		hgnl
hga:
		# Hourglass ascending
		bne		$s1, $t3, hgsp
		la 		$a0, st
		addi	$s1, $s1, -1
		syscall
hga2:
		# Hourglass ascending
		bne		$s1, $t2, hgsp2
		la 		$a0, st
		syscall
		j		hgnl
hg2:
		# Print last layer
		la		$a0, st					# Print *
		addi	$s1, $s1, -1			# $s1 = #s1 - 1
		syscall
		bne		$s1, $t0, hg2			# Loop until $s1 = 0
		j 		main		
hgnl:		
		# Hourglass next line
		move	$s1, $t1
		la		$a0, nl
		addi	$t2, $t2, -1
		addi	$t3, $t3, 1
		syscall
		beq		$s1, $t3, hg2
		blt		$t3, $t2, hgd
		bgt		$t3, $t2, hga
hgsp:
		# Hourglass spaces before first *
		la		$a0, sp
		addi	$s1, $s1, -1
		syscall
		blt		$t3, $t2, hgd
		bgt		$t3, $t2, hga
hgsp2:
		# Hourglass spaces between *
		la		$a0, sp
		addi	$s1, $s1, -1
		syscall
		blt		$t3, $t2, hgd2
		bgt		$t3, $t2, hga2
star:
		# Shape star
		li		$v0, 4					# String
		li		$t0, 3
		move	$t3, $s1				# $t3 = size
		mult	$s1, $t0				# $s1 = $s1 * 3
		mflo	$s1
		addi	$s1, 1					# $s1 = $s1 + 1
		li		$t0, 0					# Initialize $t0
		move	$t1, $s1				# Temp for size * 3 + 1
		li		$t2, 1					# $t2 for counting layers
		li		$t4, -1					# $t4 for temp of main body of star
		move	$s2, $t4				# $s2 for main body of star
		move 	$s3, $t3				# $s3 = $s3 * 2 + 1 for getting middle layer
		sll		$s3, $s3, 1
		addi	$s3, 2
star1:
		# Print top point
		bgt		$s1, $t2, stsp1
		beq		$s1, $t0, stnl
		ble		$s1, $t2, ststp
stard:
		# Star descending
		bne		$t4, $t0, stsp2
		beq		$s1, $t0, stnl
		j		ststp
stara:
		# Star ascending
		bne		$t4, $t0, stsp2
		beq		$s1, $t0, stnl2
		j		ststp
star2:
		# Print bottom point
		bgt		$s1, $t2, stsp1
		beq		$s1, $t0, stnl3
		ble		$s1, $s2, ststp
stsp1:
		# Star spaces for top and bottom points
		la		$a0, sp
		addi	$s1, $s1, -1
		syscall
		bgt		$t2, $t1, star2
		j		star1
stsp2:
		# Star spaces for main body
		la		$a0, sp
		addi	$s1, $s1, -1
		addi	$t4, $t4, -1
		syscall
		bge		$t2, $s3, stara
		j		stard
ststp:
		# Star star with space
		la		$a0, stsp
		addi	$s1, $s1, -1
		syscall
		bgt		$t2, $t1, star2
		bge		$t2, $s3, stara
		bgt		$t2, $t3, stard
		j		star1
stnl:		
		# Star next line for top point, main body
		la		$a0, nl
		syscall
		move	$s1, $t1
		addi	$t2, $t2, 1
		beq		$s2, $t3, count2
		bgt		$t2, $t3, count
		j		star1
stnl2:
		# Star next line for main body
		bge		$t2, $t1, stnl3
		la		$a0, nl
		syscall
		move	$s1, $t1
		addi	$t2, $t2, 1
		j		count2
stnl3:
		# Star next line for bottom point
		beq		$t3, $t0, main
		la		$a0, nl
		syscall
		move	$s1, $t1
		addi	$t2, $t2, 1
		move	$s2, $t3
		addi	$t3, $t3, -1
		j		star2
		
count:
		# Counter for main star descending
		move	$t4, $s2
		addi	$t4, $t4, 1
		move	$s2, $t4
		j		stard
count2:
		# Counter for main star ascending
		addi	$s2, $s2, -1
		move	$t4, $s2
		j		stara
exit:		
		li      $v0, 10
		syscall
		
		.data
prompt: .asciiz ">"                     # Input prompt		
hello:	.asciiz "\nInput integer to decide which shape (1:hourglass 2:star -1:exit)\n"
size: 	.asciiz "\nInput integer to decide the length of sides(1<n<10)\n"
nl:     .asciiz "\n"                    # Newline
st:		.asciiz "*"						# Star
sp:		.asciiz " "						# Space
stsp:	.asciiz	"* "					# Star with space
