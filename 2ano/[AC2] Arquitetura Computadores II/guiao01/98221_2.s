#int main(void) 
# { 
# char c; 
# do 
# { 
# c = getChar(); 
# if( c != '\n' ) 
# putChar( c ); 
# } while( c != '\n' ); 
# return 0; 
# }

		.equ	getChar, 2
		.equ	putChar, 3
		
		.data		
		.text
		.globl main

main:	li	$v0, getChar
		syscall
		
		beq		$v0, '\n', endw
		
		addi	$a0, $v0, 1
		li		$v0, putChar
		syscall
		
		j		main
		
endw:	li		$v0, 0
		jr		$ra