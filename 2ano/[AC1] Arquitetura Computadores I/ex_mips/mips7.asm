	.data
	.eqv read_int, 5
	.eqv	print_string, 4	
str:	.space	33	
str1: 	.asciiz	"\n"
	.text
	.globl main	
main:
	addiu	$sp,$sp,-8
	sw	$ra,0($sp)
	sw	$s0,4($sp)
	
do:	
	li	$v0,read_int
	syscall
	move	$s0,$v0			# val = read_int();
	
	
	li	$v0, print_string
	la	$a0, str1
	syscall

	move	$a0,$s0
	li	$a1,2
	la	$a3,str
	jal	itoa
	move	$a0,$v0
	li	$v0,print_string
	syscall

	li	$v0, print_string
	la	$a0, str1
	syscall

	move	$a0,$s0
	li	$a1,8
	la	$a3,str
	jal	itoa
	move	$a0,$v0
	li	$v0,print_string
	syscall

	li	$v0, print_string
	la	$a0, str1
	syscall

	move	$a0,$s0
	li	$a1,16
	la	$a3,str
	jal	itoa
	move	$a0,$v0
	li	$v0,print_string
	syscall

	li	$v0, print_string
	la	$a0, str1
	syscall
	
while:	bnez	$s0,do
	li	$v0,0
	
	lw	$ra,0($sp)
	lw	$s0,4($sp)
	addiu	$sp,$sp,8
	jr	$ra
		
# função itoa ----------------------------------------------------------
itoa:
	addiu	$sp,$sp,-20
	sw	$ra,0($sp)
	sw	$s0,4($sp)		# $s0 = n
	sw	$s1,8($sp)		# $s1 = b
	sw	$s2,12($sp)		# $s2 = s
	sw	$s3,16($sp)		# $s3 = * p
	
	move	$s0,$a0
	move	$s1,$a1
	move 	$s2,$a2

	move 	$s3,$a2			# *p = s;		
	
	
doo:
	rem	$a0,$s0,$s1
	div	$s0,$s0,$s1
	jal	toascii
	sb	$v0,0($s3)		# *p = toascii( digit );
	addi	$s3,$s3,1		# p++
while2:	bgtz	$s0,doo			# while( n > 0 );
	sb	$0,0($s3)
	move 	$a0,$s2
	jal	strrev

	lw	$ra,0($sp)
	lw	$s0,4($sp)		# $s0 = n
	lw	$s1,8($sp)		# $s1 = b
	lw	$s2,12($sp)		# $s2 = s
	lw	$s3,16($sp)		# $s3 = * p
	addiu	$sp,$sp,20

	jr	$ra


# Função toascii ----------------------------------------------------------
toascii:
# $v0 = v
# $a0 = char inicial
	addi	$v0,$a0,'0'
if1:	ble	$v0,'9',endif1
	addi	$v0,$v0,7
endif1:
	jr	$ra

# função strrev ----------------------------------------------------------
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
while3:
	bge	$s0,$s1,endw2
	move	$a1,$s1
	move	$a0,$s0
	jal	exchange
	addi	$s0,$s0,1	# p1++
	addi	$s1,$s1,-1	# p2--
	j while3
endw2:
	move 	$v0, $s2

	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	lw	$s2,12($sp)
	addiu	$sp,$sp,16
	jr	$ra
# função exchange
exchange:
	lb	$t0,0($a0)  	# $t0 =  *c1
	lb	$t1,0($a1)  	# $t1 =  *c2
	sb	$t0,0($a1)	# *c1 = *c2;
	sb 	$t1,0($a0)	# *c2 = aux; 	
	jr 	$ra
# -----------------------------------------------------------------
