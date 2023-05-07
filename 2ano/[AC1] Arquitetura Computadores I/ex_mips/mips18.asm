	.data
k1:	.float 0x3A600000
k2:	.float 0xBA600000
	.text
	.globl main

main:	
	

	l.s		$f2,k1
	l.s		$f4,k2
		
	div.s		$f0,$f2,$f4	
	
	
