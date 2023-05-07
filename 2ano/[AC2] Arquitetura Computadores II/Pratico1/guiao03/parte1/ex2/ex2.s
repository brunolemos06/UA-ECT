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

main:   lui     $t0,SFR_BASE_HI


        lw      $t1,TRISE($t0)
        andi    $t1,$t1,0xFFFE      # Configura o porto 0 do registo E (RE0) como saída
        sw      $t1,TRISE($t0)

        lw      $t1,TRISB($t0)
        ori     $t1,$t1,0x0001      # Configura o porto 0 do registo B (RE0) como entrada
        sw      $t1,TRISB($t0)

loop:                               # while(1) {
        lw	$t1, PORTB($t0)     #
        andi    $t1,$t1,0x0001      # Leitura do bit 0 do porto de entrada (fazendo reset aos restantes bits)
        xori    $t1,$t1,0x0001      # nega o bit 0            
   
        lw      $t2,LATE($t0)       # apagar ultimo bit
        andi    $t2,$t2,0xFFFE      # 

        or      $t2,$t2,$t1         # escrever dados
        sw      $t2,LATE($t0)       # ...
        j loop

        jr $ra              