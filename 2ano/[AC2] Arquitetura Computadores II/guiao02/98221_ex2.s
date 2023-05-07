        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12
        .equ PUT_CHAR,3
        .equ PRINT_INT,6
        .data
        .text
        .globl main
main: 
            addiu	$sp,$sp,-8
            sw	        $ra,0($sp)
            sw		$s0, 4($sp)	
            

            li      $s0,0
loop:      
            li		$a0,500
            jal     delay


            li		$a1,0x0004000A
            addi	$s0,$s0,1
            or	    $a0,$s0,$0
            li	    $v0,PRINT_INT
            syscall
            li		$a0,'\r'
            li	    $v0,PUT_CHAR
            syscall
            j loop


            li		$v0,0
            lw		$ra, 0($sp)
            lw		$s0, 4($sp)
            addiu	$sp,$sp,8
            jr          $ra        

delay:      or          $t0,$a0,$0
for:        ble		$t0, $0, end
            li		$v0,RESET_CORE_TIMER		# $v0 = reset 
            syscall
             
while:      li          $v0,READ_CORE_TIMER     
            syscall
            blt		$v0, 20000,while
            addi	$t0,$t0,-1        
            j           for
end:        jr          $ra


