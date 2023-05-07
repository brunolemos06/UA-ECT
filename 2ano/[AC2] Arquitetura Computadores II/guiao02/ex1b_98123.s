
    .equ READ_CORE_TIMER,11
    .equ RESET_CORE_TIMER,12
    .equ PUT_CHAR,3
    .equ PRINT_INT,6
    .data
    .text
    .globl main
main: li $t0,0
while: li $v0,READ_CORE_TIMER # while (1) {
    syscall 
    blt $v0,200000,while
    li $v0,RESET_CORE_TIMER
    syscall
    addi $t0,$t0,1

    li $a1,0x0004000A
    move $a0,$t0
    li $v0,PRINT_INT
    syscall

    li $v0,PUT_CHAR
    li $a0,'\r'
    syscall

    j while
    li $v0,1
    jr $ra #