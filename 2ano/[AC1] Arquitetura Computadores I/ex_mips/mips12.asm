	.data
k0:	.float	2.59375
k1:	.float	0.0
	.eqv	read_int, 5
	.eqv	print_float, 2
	.text
	.globl main
main:

do:
	li	$v0,read_int
	syscall
	
	l.s	$f2,k0
	l.s	$f6,k1	
	mtc1	$v0,$f4
	cvt.s.w	$f4,$f4
	mul.s	$f12,$f4,$f2
	li	$v0,print_float
	syscall
	
while:	c.eq.s	$f12,$f6
	bc1f	do
end:	li	$v0,0
	jr	$ra		