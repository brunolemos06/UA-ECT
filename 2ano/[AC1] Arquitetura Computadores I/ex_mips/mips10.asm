	.data
k0:	.double	0.0
array:	.space	80
	.eqv 	read_int,5
	.eqv	print_double,3
	.eqv	size,10
	.text
	.globl main
# $t0 -> array
# $t1 -> i
# $t2 -> array[i]
main:
	addiu	$sp,$sp,-4
	sw	$ra,0($sp)

	la	$t0,array		# $t0 -> array
	li	$t1,0
for2:	
	bge	$t1,size,endf2
	li	$v0,read_int
	syscall
	mtc1.d	$v0,$f2
	cvt.d.w	$f2,$f2
	sll	$t4,$t1,3
	add	$t2,$t0,$t4
	s.d	$f2,0($t2)
	addi	$t1,$t1,1
	j	for2
endf2:	la	$a0,array
	li	$a1,size
	jal	average
	mov.d 	$f12,$f0
	
	li	$v0,print_double
	syscall
	li	$v0,0

	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	jr	$ra
	
average:
# $f2 -> sum
# $f12 -> *array
# $a1 -> n
# $t0 -> i
	l.d	$f2,k0			# $f2 = 0.0
	move	$t0,$a1			# i = n
for1:
	blez	$t0,endf1		
	addi	$t1,$t0,-1
	sll	$t3,$t1,3		# $t3 = (i-1)*8	
	addu	$t3,$a0,$t3
	l.d	$f4,0($t3)
	add.d	$f2,$f2,$f4
	addi	$t0,$t0,-1
	j for1
endf1:
	mtc1.d	$a1,$f6
	cvt.d.w	$f6,$f6
	div.d	$f0,$f2,$f6
	jr	$ra	
	
