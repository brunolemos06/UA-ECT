        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12
        .equ SFR_BASE_HI, 0xBF88
        .equ TRISE, 0x6100
        .equ PORTE, 0x6110
        .equ LATE, 0x6120
        .equ TRISB, 0x6040
        .equ PORTB, 0x6050
        .equ LATB, 0x6060

        .data
        .text
        .globl main

main: 
        addiu           $sp,$sp,-12
        sw              $ra,0($sp) # SFR_BASE_HI
        sw              $s0,4($sp) # v
        sw              $s1,8($sp) # 

        li              $s0,0               #v = 0
        lui             $s1,SFR_BASE_HI

        lw      $t1,TRISE($s1)
        andi    $t1,$t1,0xFFFE      # Configura o porto 0 do registo E (RE0) como saída
        sw      $t1,TRISE($s1)
loop:                               # while(1) {

        lw      $t2,LATE($s1)       # apagar ultimo bit
        andi    $t2,$t2,0xFFFE      #
        
        or      $t2,$t2,$s0         # escrever dados
        sw      $t2,LATE($s1)       # ...

        li      $a0,500
        jal     delay

        xori    $s0,$s0,0x0001      # v ^= 1

        j loop

        li		    $v0,0
        lw		    $ra, 0($sp)
        lw		    $s0, 4($sp)
        lw          $s1, 8($sp)
        addiu	    $sp,$sp,12
        jr          $ra 

        jr $ra
delay:  or              $t0,$a0,$0
for:    ble             $t0,$0,end
        li              $v0,RESET_CORE_TIMER
        syscall

while:  li              $v0,READ_CORE_TIMER
        syscall

        blt             $v0,20000,while
        addi            $t0,$t0,-1                  # ms--
        j               for
end:    jr              $ra