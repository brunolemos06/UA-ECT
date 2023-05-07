#include <detpic32.h>
void delay(int ms){
    while(ms>0){
        resetCoreTimer();
        while(readCoreTimer() < 20000);
        ms--;
    }
}
int main(void){
    while(1){
        TRISB = TRISB & 0x80FF; // SAÍDAS = 0
        TRISDbits.TRISD5 = 1;
        TRISDbits.TRISD6 = 0;

        LATB = LATB & 0x80FF;   // dar reset em todos os valores

        while(1){
            
            char input = getChar();
            if((input <='G' && input >='A'))input += 0x20;
            LATB = LATB & 0x80FF;   // dar reset em todos os valores

            switch (input){
                case 'a':
                    LATBbits.LATB8 = 1;
                    break;
                case 'b':
                    LATBbits.LATB9 = 1;
                    break;
                case 'c':
                    LATBbits.LATB10 = 1;
                    break;
                case 'd':
                    LATBbits.LATB11 = 1;
                    break;
                case 'e':
                    LATBbits.LATB12 = 1;
                    break;
                case 'f':
                    LATBbits.LATB13 = 1;
                    break;
                case 'g':
                    LATBbits.LATB14 = 1;
                    break;
                default:
                    LATB = LATB & 0x80FF;   // dar reset em todos os valores
                    break;
                    
            }
        }

    }

    return 0;
}