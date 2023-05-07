	.data
	.text
	.globl max
max:
# $t0 -> *p
# $t1 -> *u
# $t2 -> p[i]
	move	$t0,$a0

	addiu	$t1,$t1,-1		# $t1 = n-1
	sll	$t1,$a1,3		# $t1 =	(n-1)*8 
	addu	$t1,$t1,$t0		# $t1 = p  + (n-1)*8 ///// *u
	
	l.d	$f0, 0($t0)		# max = *p;
	addi	$t0,$t0,8		# p++
for1:
	bgt	$t0,$t1,endf1		# for(; p <= u; p++)
	l.d	$f2,0($t0)		# $f2 = *p
if1:	
	c.le.s	$f2,$f0
	bc1t	endif1
	mov.d	$f0,$f2		
endif1:	
	addiu	$t0, $t0, 8
	j 	for1
endf1: 	
	jr	$ra
		
	
				