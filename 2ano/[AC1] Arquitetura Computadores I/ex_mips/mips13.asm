	.data
	.eqv	TRUE,1
	.eqv	FALSE,0
	.text
	.globl median
median:
# Mapa de registos
# $t0 -> houveTroca
# $t1 -> i
# $t2 -> nval-1
# $t3 -> array[i]

do:	
	li	$t0,FALSE
	li	$t1,1
	addi	$t2,$a1,-1
for:	
	bge	$t1,$t2,endf
	
	sll	$t1,$t1,3	
	add	$t3,$a0,$t1
	l.d	$f2,0($t3)
	l.d	$f4,8($t3)		# OBIRGADO PEDRO, sou o burno
if:	c.le.d	$f2,$f4
	bc1t	endif
	(...)
endif:
	addi	$t1,$t1,1		# i++
	j	for
endfor:
while:	beq 	$t0,TRUE,do
	
	sll	$t3,$a1,3
	srl	$t3,$t3,1	
	add	$t3,$a0,$t3
	l.d	$f0,0($t3)
	jr	$ra