	.data
	.globl exchange
# função exchange   CHE CHE PEDRO
exchange:
	lb	$t0,0($a0)  	# $t0 =  *c1
	lb	$t1,0($a1)  	# $t1 =  *c2
	sb	$t0,0($a1)	# *c1 = *c2;
	sb 	$t1,0($a0)	# *c2 = aux; 	
	jr 	$ra
