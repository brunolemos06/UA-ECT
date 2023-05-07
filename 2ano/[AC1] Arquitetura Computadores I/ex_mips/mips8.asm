	.data
k1:	.float	2.59375
k2:	.float	0.0
	.eqv	print_float,2
	.eqv	read_int,5
	.text
	.globl main
	
do:
	li	$v0,read_int			# $v0 = read_int;
	syscall							
	l.s	$f4,k1				# $f4 = 2.59375
	mtc1	$v0,$f6				# $f6 = val;
	cvt.s.w	$f6,$f6				# $f6 = (float)val;
	mul.s	$f12,$f6,$f4			# res = $f12
	li	$v0,print_float			#
	syscall
while:
	l.s	$f8,k2				# $f8 = 0.0
	mtc1	$f8,$f8
	c.eq.s	$f12,$f8
	bc1f	do
	jr	$ra		