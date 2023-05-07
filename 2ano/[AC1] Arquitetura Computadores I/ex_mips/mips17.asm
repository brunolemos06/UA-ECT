# Mapa de registos
# std -> $t0
# n   -> $a1
# i   -> $t2
# sum -> $f2

	.data
	.eqv print_string, 4
	.eqv print_float, 2
k0:	.float 0.0
k1:	.float 2.0
std:	.asciiz	"Rei Eusebio"
	.space 38
	.word	12345
	.float	17.2
	.byte	'F'
	.space 3
	.asciiz	"Rainha Amalia"
	.space 36
	.word	23450
	.float	12.5
	.byte	'C'
	.space 3
	
	.space 36
	.text
	.globl main
# --------------------------------------------------------------------
main:
	addiu	$sp,$sp,-4
	sw	$ra,0($sp)

	la	$a0,std		
	li	$a1,2	
	jal	fun3			# static student std[2]
	
	mov.s	$f12,$f0
	li	$v0,print_float
	syscall				# print_float(fun3(std, 2));

	li	$v0,-1			# return -1; 

	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	jr	$ra
# --------------------------------------------------------------------
fun3:
	l.s	$f2,k0		# sum = 0
	li	$t2,0		# i   = 0
	move	$t0,$a0		# $t0 -> std
for:	bge	$t2,$a1,endf	# for(i=0; i < n; i++)
	mul	$t3,$t2,64	# $t3 -> i*64
	add	$a0,$t0,$t3	# $a0 -> std+i
	li	$v0,print_string
	syscall
	
	l.s	$f12,56($a0)
	li	$v0,print_float
	syscall

	add.s	$f2,$f2,$f12
	
	addi	$t2,$t2,1	# i++
	j	for
endf:	
	l.s	$f4,k1
	div.s	$f0,$f2,$f4
	jr	$ra
	





		