#int main(void){
# int value;
#   while(1){
#       printStr("\nIntroduza um numero (sinal e módulo): ");
#       value = readInt10();
#       printStr("\nValor lido, em base 2: ");
#       printInt(value, 2);
#       printStr("\nValor lido, em base 16: ");
#       printInt(value, 16);
#       printStr("\nValor lido, em base 10 (unsigned): ");
#       printInt(value, 10);
#       printStr("\nValor lido, em base 10 (signed): ");
#       printInt10(value);
#   }
#   return 0;
#}

            .equ    readInt10,5
            .equ    printStr,8
            .equ    printInt,6
		    .data
msg:        .asciiz "\nIntroduza um numero (sinal e módulo): \n"
msgb2:      .asciiz "\nValor lido, em base 2: "
msgb16:     .asciiz "\nValor lido, em base 16: "
msgb10t:    .asciiz "\nValor lido, em base 10 (unsigned): "
msgb10f:    .asciiz "\nValor lido, em base 10 (signed): "
		    .text
		    .globl main

main:       
            #printStr("\nIntroduza um numero (sinal e módulo): ");
            la      $a0,msg
            li	    $v0, printStr
		    syscall

            #value = readInt10();
            li      $v0,readInt10
            syscall
            or     $t0,$v0,$0

            #Valor lido, em base 2
            la      $a0,msgb2
            li	    $v0, printStr
		    syscall

            or      $a0,$t0,$0
            li      $a1,2
            la      $v0,printInt
            syscall

            #Valor lido, em base 16
            la      $a0,msgb16
            li	    $v0, printStr
		    syscall

            or      $a0,$t0,$0
            li      $a1,16
            la      $v0,printInt
            syscall

            #Valor lido, em base 10 (unsigned)
            la      $a0,msgb10t
            li	    $v0, printStr
		    syscall

            or      $a0,$t0,$0
            li      $a1,10
            la      $v0,printInt
            syscall

            #Valor lido, em base 10 (signed)
            la      $a0,msgb10f
            li	    $v0, printStr
		    syscall

            or      $a0,$t0,$0
            li      $a1,10
            la      $v0,printInt
            syscall

            #printInt10(value);
            or      $a0,$t0,$0
            li	    $v0, printStr
		    syscall

            #end
		    j		main
jr      $ra