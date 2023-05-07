# Mapa de registos
# a -> 		$a0
# N -> 		$a1
# b -> 		$a2
# k -> 		$t0
# p -> 		$t1
# a + N -> 	$t2
	.data
k0:	.double	2.0
k1:	.double 0.0
	.text
	.globl fun1
fun1:
	li	$t0,0		# k = 0
	move 	$t1,$a0		# p = a
	sll	$t2,$a1,3	# $t2 -> N * 8
	add	$t2,$a0,$t2	# $t2 -> a + (N * 8)
	
	l.d	$f2,k0		# $f2 -> 2.0
	l.d	$f4,k1		# $f4 -> 0.0
for:
	bge	$t1,$t2,endfor
	
	l.d	$f6,0($t1)	# $f6 = *P
	div.d	$f8,$f6,$f2	# $f8 = *p / 2.0
if:	c.eq.d	$f8,$f4		# (*p / 2.0) != 0.0)
	bc1t	else
	
	s.d	$f6,0($a2)	#
	addi	$a2,$a2,8	# b++
	j	endif
else:	
	addi	$t0,$t0,1	# k++
endif:	
	addi	$t1,$t1,8	# p++
	j	for
endfor:
	sub	$v0,$a1,$t0	# return (N - k); 	
	jr	$ra