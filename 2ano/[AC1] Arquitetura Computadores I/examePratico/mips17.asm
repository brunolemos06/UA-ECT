# Mapa de registos
# std -> $t1
# n   -> $t2
# i   -> $t0
# sum -> $f2
	.data
k0:	.float	0.0
k1:	.float	2.0
std:	.asciiz	"Rei Eusebio "
	.space 38
	.word	12345
	.float	17.2
	.byte	'F'
	.space 3
	.asciiz	 "Rainha Amalia "
	.space 36
	.word	23450
	.float	12.5
	.byte	'C'
	.space 3
virgul:	.asciiz	"\n"
	.eqv 	print_string,4
	.eqv	print_float, 2
	.text
	.globl main
# ________________________    main    ________________________
main:
	addiu	$sp,$sp,4
	sw	$ra,0($sp)

	la	$t0,std
	
	move	$a0,$t0
	li	$a1,2
	jal	fun3
	mov.s	$f12,$f0
	li	$v0,print_float
	syscall
	
	lw	$ra,0($sp)
	addiu	$sp,$sp,-4

	li	$v0,-1
	jr	$ra
# _______________________ função fun3  _______________________
fun3:
	l.s	$f2,k0			# $f2 -> 0.0
	li	$t0,0			# i = 0
	move	$t1,$a0			# $t1 -> std
	move	$t2,$a1			# $t2 -> n
	mul	$t2,$t2,64
for:	
	bge	$t0,$t2,endf		# print_string(std[i].name);
	add	$t3,$t1,$t0
	move	$a0,$t3
	li	$v0,print_string
	syscall
	
	l.s	$f12,56($t3)		# print_float(std[i].grade); 
	li	$v0,print_float
	syscall
	
	la	$a0,virgul
	li	$v0,print_string
	syscall

	add.s	$f2,$f2,$f12		# sum += std[i].grade; 
	
	addi	$t0,$t0,64		# i++
	j	for
endf:	
	l.s	$f4,k1			# $f2 -> 2.0
	div.s	$f0,$f2,$f4		# return sum / 2.0
	jr 	$ra