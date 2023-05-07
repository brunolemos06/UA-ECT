	.data
k1:	.float	5.0
k2:	.float	9.0
k3:	.float	32.0
	.text
	.globl main
f2c:	
	l.d	$f2,k1			# $f2 = 5.0	
	l.d	$f4,k2			# $f4 = 9.0	
	l.d	$f6,k3			# $f6 = 32.0

	div.d	$f8,$f2,$f4
	sub.d	$f0,$f12,$f6
	mul.d	$f0,$f8,$f0
	jr	$ra	
	