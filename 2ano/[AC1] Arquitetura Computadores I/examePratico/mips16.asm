# p =  $s0
# k =  $s1
# n =  $s2
# *p = $t1
	.data
	.text
	.globl fun2
fun2:

	addi	$sp,$sp,-16
	sw	$ra,0($sp)		# $ra
	sw	$s0,4($sp)		# p
	sw	$s1,8($sp)		# k
	sw	$s2,12($sp)		# n
	
	move	$s0,$a0			# p
	move	$s1,$a1			# k
	li	$s2,0			# n = 0

while:	
	lw	$t0,0($s0)		# $t0 = *p
	beq	$t0,$s1,endw		#  while ( *p != k ) 
	move	$a0,$t0			#
	move	$a1,$s1			
	jal	funk
	add	$s2,$s2,$v0		# n = n + funk(*p, k);
	addi	$s0,$s0,4		# p++
	j	while
endw:	
	move	$v0,$s2

	lw	$ra,0($sp)		# $ra
	lw	$s0,4($sp)		# p
	lw	$s1,8($sp)		# k
	lw	$s2,12($sp)		# n	
	addi	$sp,$sp,16

	jr	$ra