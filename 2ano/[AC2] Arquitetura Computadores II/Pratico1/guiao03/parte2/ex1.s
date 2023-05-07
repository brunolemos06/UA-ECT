        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12
        .equ SFR_BASE_HI, 0xBF88
        .equ TRISE, 0x6100
        .equ PORTE, 0x6110
        .equ LATE, 0x6120
        .equ TRISB, 0x6040
        .equ PORTB, 0x6050
        .equ LATB, 0x6060
        .equ increment, 1

        .data
        .text
        .globl main

main:   addiu $sp, $sp, -16
        sw $ra, 0($sp)
        sw $s0, 4($sp)
        sw $s1, 8($sp)
        sw $s2, 12($sp)

        lui $s0, SFR_BASE_HI    
                                    # configurar os portos RB como saídas
        lw $t1, TRISE($s0)
        andi $t1, $t1, 0xFFF0
        sw $t1, TRISE($s0)

        li $s1, 0

loop:   li $a0, 1000
        jal delay

        addi $s1, $s1, increment
        andi $s1, $s1, 0x000F

        lw $t0, LATE($s0)
        andi $t0, $t0, 0xFFF0
        or $t0, $t0, $s1
        sw $t0, LATE($s0)

        j loop

        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        addiu $sp, $sp, 16

        li $v0, 1
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