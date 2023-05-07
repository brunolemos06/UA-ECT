	.data
str8:	.asciiz	", "
str1:	.asciiz "Size of array : "
str2:	.asciiz "array["
str3:	.asciiz "] = "
str4:	.asciiz "Enter the value to be inserted:  "
str5:	.asciiz "Enter the position: "
str6:	.asciiz "\nOriginal array: "
str7:	.asciiz "\nModified array: "
	.eqv	print_string,4
	.eqv	print_int10,1
	.eqv	read_int,5
array:	.space	200 			# 50*4 = 200
	.text
	.globl	main

# Mapa de registos
# $t0 - i
# $s0 - &array
# $s1 - array_size
# $s2 - insert_value
# $s3 - insert_pos
# $t5 - &(array[i])
# $t6 - i*4

main:	addiu 	$sp, $sp,-28		# alucar espaço
	sw	$ra,0($sp)		# salvaguardar $ra
	sw	$s0,4($sp)		#
	sw	$s1,8($sp)		#
	sw	$s2,12($sp)		#
	sw	$s3,16($sp)		#
	sw	$s4,20($sp)		#
	sw	$s5,24($sp)		#
	la	$s5,array		#
	la	$a0,str2		# print_string("Size of array : ");   
	li 	$v0,print_string	#
	syscall				#
	li 	$v0,read_int		#
	syscall					#
	move 	$s1,$v0			# array_size = read_int();
	li 	$t0,0			# i=0
for:	bge 	$s0,$s1,endfor		# while(i < array_size)
	la	$a0,str3		# print_string("array["); 
	li 	$v0,print_string	#
	syscall				#
	move 	$a0,$s0			# print_int(i); 
	li 	$v0,print_int10	#
	syscall				#
	la	$a0,str4		# print_string("] = ");  
	li 	$v0,print_string	#
	syscall				#
	li 	$v0,read_int		#
	syscall				# 
	sll	$s4,$s0,2		# i*4
	addu	$s4,$s4,$s5		# s4 = &array[i]
	sw	$v0,0($s4)		# array[i] = read_int(); 
	addi 	$s0,$s0,1		# i++
	j 	for
endfor:	la	$a0,str5		# print_string("Enter the value to be inserted: "); 
	li 	$v0,print_string	#
	syscall				#
	li 	$v0,read_int		#
	syscall				#
	move	$s2,$v0			# insert_value = read_int(); 
	la	$a0,str6		# print_string("Enter the position: ");
	li 	$v0,print_string	#
	syscall				#
	li 	$v0,read_int		#
	syscall				#
	move	$s3,$v0			# insert_pos = read_int(); 
	la	$a0,str7		# print_string("\nOriginal array: ");
	li 	$v0,print_string	#
	syscall				#
	move 	$a0,$s5			# array
	move	$a1,$s1			# array_size
	jal 	print_array		# print_array(array, array_size);
	move 	$a0,$s5			# array
	move	$a1,$s2			# insert_value
	move 	$a2,$s3			# insert_pos
	move	$a3,$s1			# insert_pos
	jal	insert			#insert(array, insert_value, insert_pos,  insert_pos);
	la	$a0,str8		#print_string("\nModified array: ");  
	li 	$v0,print_string	#
	syscall				#
 	move 	$a0,$s5			# array
	move	$a1,$s1			# array_size
	addiu	$a1,$a1,1		# array_size + 1
	jal 	print_array		# print_array(array, array_size + 1);
 	lw	$ra,0($sp)		# salvaguardar $ra	
 	lw	$s0,4($sp)		
	lw	$s1,8($sp)
	lw	$s2,12($sp)
	lw	$s3,16($sp)
	lw	$s4,20($sp)
	lw	$s5,24($sp)
	li 	$v0,0		# return 0; 
	addiu 	$sp, $sp,28	# libertar espaço
	jr 	$ra
# $t0 -> i
# $t1 -> &array[i]
# $t2 -> *array[i]
# função print_array
print_array:
	move	$t0, $a0		# $t0 = *a
	move	$t1, $a1		# $t1 = n;
	sll	$t1, $t1, 2		# n = n*4;
	add	$t2,$t0,$t1		# *p = a + n;
fora:	
	bge	$t0,$t2,endf		# for(; a < p; a++)
	lw	$a0,0($t0)		# $a0 = *a
	li	$v0,print_int10
	syscall
	
	la	$a0,str8
	li	$v0,print_int10
	syscall
	addi	$t0,$t0,4
	j 	fora
endf:	
	jr 	$ra
	
	
		
# função insert
insert:
	move	$t0, $a0		#	$t0 = *array
	move	$t1, $a1		#	$t1 = value;
	move 	$t2, $a2		#	$t2 = pos;
	move	$t3, $a3		#	$t3 = size;
if:	ble	$t2,$t3,else
	li	$v0,1
	j	endif
else:
	addi	$t4,$t3,-1		# i = size-1	
for1:	
	blt	$t4,$t2,endfor89		# 
	sll	$t5, $t4, 2		# $t5 = i*4
	addu	$t0,$t0,$t5		# $t5 = array + i*4
	lw	$t6,0($t0)		# $t6 = array[i*4]
	sw	$t6,4($t0)		# array[(i*4)+1] = array[i*4]
	addi	$t4, $t4, -1		# i--
	j 	for1
endfor89:
	sll	$t6,$t2,2		# $t6 = pos*4
	add 	$t0,$t0,$t6		# $t6 = array + pos*4
	sw	$t1,0($t0)		#
	li 	$v0,0			# return 0
endif:	
	jr 	$ra
