	.data
k0:	.double	2.0
k1:	.double 0.0
	.text
	.globl	fun1
fun1:

# a = $a0
# N = $a1
# b = $t3
# k = $t0
# p = $t1

	li	$t0,0			# k = 0
	move	$t1,$a0
	sll	$t2,$a1,3
	add	$t2,$t2,$a0
for:	
	bge	$t1,$t2,endfor
if:
	l.d	$f2,0($t1)		# *p
	l.d	$f4,k0			# 2.0
	l.d	$f6,k1			# 0.0
	div.d	$f2,$f2,$f4		# *p / 2.0
	c.eq.d	$f2,$f6
	bc1t	else
	s.d	$f2,0($a2)
	addi	$a2,$a2,8
	j	endif
else:
	addi	$t0,$t0,1
endif:
	addi	$t1,$t1,8
	j	for
endfor:
	sub	$v0,$a1,$t0
	jr	$ra

