	.data
k0:	.double	2.0
k1:	.double 0.0
	.text
	.globl fun1
# REGISTOS
# a -> $a0
# N -> $a1
# b -> $a2
# k -> $t0
# p -> $t1
# a + N -> $t2
# *p    -> $f2
fun1:
	li	$t0,0		# k = 0
	
	move	$t1,$a0		# p = a
	sll	$t2,$a1,3	# N * 8
	add	$t2,$a0,$t2	# a + (N*8)
	l.d	$f4,k0		# $f4 = 2.0
	l.d	$f8,k1		# $f8 = 0.0

for:	bge	$t1,$t2,endf	# for(p < (a + N))
	l.d	$f2,0($t1)	# $f2 = *p
	div.d	$f6,$f2,$f4	# $f6 = *p / 2.0
if:	c.eq.d	$f6,$f8
	bc1t	else
	s.d	$f2,0($a2)	# *b = *p
	addi	$a2,$a2,8	# b++
else:
	addi	$t0,$t0,1	# k++	
endif:
	addi	$t1,$t1,8	# p++
	j	for
endf:	
	sub	$v0,$a1,$t0	# return (N - k)
	jr	$ra	
	