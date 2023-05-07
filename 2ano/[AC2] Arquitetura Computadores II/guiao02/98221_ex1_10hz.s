    .equ READ_CORE_TIMER,11
    .equ RESET_CORE_TIMER,12
    .equ PUT_CHAR,3
    .equ PRINT_INT,6
    .data
    .text
    .globl main


main:       li      $t0,0
loop:
while:      li      $v0,READ_CORE_TIMER         # while (1) {
            syscall
            blt		$v0, 2000000,while	        # if $v0 >= $t1 then target
            li		$v0,RESET_CORE_TIMER		# $v0 = reset 
            syscall
            li		$a1,0x0004000A
            addi	$t0,$t0,1
            or	    $a0,$t0,$0
            li	    $v0,PRINT_INT
            syscall
            li		$a0,'\r'
            li	    $v0,PUT_CHAR
            syscall
            j loop
            jr $ra