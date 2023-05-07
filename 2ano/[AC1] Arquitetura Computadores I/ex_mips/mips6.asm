	.data
str:	.asciiz	"2016 e 2020 sao anos bissextos"
	.eqv	print_int10,1	
	.text
	.globl main

main:	
	addiu	$sp,$sp,-4
	sw	$ra,0($sp)
	la	$a0,str			# $a0 -> str
	jal	atoi
	move 	$a0,$v0
	li	$v0,print_int10
	syscall
	li	$v0,0
	lw	$ra, 0($sp)		# 
	addiu	$sp, $sp, 4
	jr	$ra
	




# Função atoi ------------------------------------------------------------
atoi:
# $a0 = *s
# $v0 = res
# $t1 = digit
# $t2 = s[i]
	li	$t0,0
while1:	
	lb	$t2,0($a0)		# $t2 = s[i]
	blt	$t2,'0',endw1
	bgt	$t2,'9',endw1
	sub	$t1,$t2,'0'		#	digit = *s - '0'
	addi	$a0,$a0,1		# 	s++
	mul	$v0,$v0,10		#	res = res * 10
	add	$v0,$v0,$t1		# 	res = res * 10 + digit
	j	while1
endw1:
	jr	$ra
	