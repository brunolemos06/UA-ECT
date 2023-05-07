#int main(void)
# {
# char c;
# do
# {
# while( (c = inkey()) == 0 );
# if( c != '\n' )
# putChar( c );
# } while( c != '\n' );
# return 0;
# }

		.equ	putChar, 3
        .equ    inkey,   1
		
		.data		
		.text
		.globl main

main:	
do:
while:  
            li      $v0,inkey
            syscall
     	    bnez	$v0, endw
if:         beq     $v0,'\n',endif
            move	$a0, $v0
		    li		$v0, putChar
		    syscall
endif:		jr while
endw:
enddo:      bne		$v0, '\n', do
            jr		$ra
