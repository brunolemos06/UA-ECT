	.data
str:	.asciiz  "Arquitetura de Computadores I"
	.eqv	print_int10,1						
	.text
	.globl main

main:	
	addiu	$sp,$sp,-4		# abrir espaço na pilha
	sw	$ra,0($sp)		# guardar valor de $ra
	
	la 	$a0,str
	jal	strlen
	move	$a0,$v0
	li	$v0,print_int10
	syscall
	
	lw	$ra,0($sp)		# repor o valor de $ra
	addiu	$sp,$sp,4		# repor o espaço na pilha
	li 	$v0, 0			# return 0
	jr 	$ra		
		

#funcão strlen
strlen:
	li 	$t0,0			# len = 0
while:	
	lb	$t1,0($a0)
	addi	$a0,$a0,1
	beqz	$t1,endw		# while(*s++ != '\0') 
	addi	$t0,$t0,1
	j while
endw:
	move 	$v0,$t0
	jr	$ra