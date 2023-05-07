	.data
str:	.asciiz	"ITED - orievA ed edadisrevinU"
	.eqv	print_string,4
	.text
	.globl main
# função main
main:
	addiu	$sp,$sp,-4
	sw	$ra,0($sp)
	la	$a0,str
	jal	strrev
	move	$a0,$v0
	li	$v0,print_string
	syscall

	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	li	$v0,0
	jr	$ra

# função strrev
strrev:
	addiu	$sp,$sp,-16
	sw	$ra,0($sp)	# $ra
	sw	$s0,4($sp)	# $p1
	sw	$s1,8($sp)	# $p2
	sw	$s2,12($sp)	# $v0
	
	move	$s0,$a0		# *p1 = str
	move	$s1,$a0		# *p2 = str
	move	$s2,$a0		# str = parametro de entrada

while1:
	lb	$t0,0($s1)
	beqz	$t0,endw1
	addi	$s1,$s1,1	# p2++
	j	while1	
endw1:
	addi	$s1,$s1,-1	# p2--
while2:
	bge	$s0,$s1,endw2
	move	$a1,$s1
	move	$a0,$s0
	jal	exchange
	addi	$s0,$s0,1	# p1++
	addi	$s1,$s1,-1	# p2--
	j while2
endw2:
	move 	$v0, $s2

	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	lw	$s2,12($sp)
	addiu	$sp,$sp,16
	jr	$ra

# função exchange   CHE CHE PEDRO
exchange:
	lb	$t0,0($a0)  	# $t0 =  *c1
	lb	$t1,0($a1)  	# $t1 =  *c2
	sb	$t0,0($a1)	# *c1 = *c2;
	sb 	$t1,0($a0)	# *c2 = aux; 	
	jr 	$ra
