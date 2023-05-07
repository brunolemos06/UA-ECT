#include <detpic32.h>

void delay(int ms);
int main(void){
    //TRIS -> escolher entre saida ou entrada
    //LATE -> POR VALOR NA SAIDA
    TRISDbits.TRISC5 = 0;
    TRISDbits.TRISC6 = 0;

    LATDbits.LATD5 = 1;
    LATDbits.LATD6 = 0;

    TRISB = TRISB & 0x00FF // 0000 0000 1111 1111




}

void delay(int ms){
    while(ms>0){
            resetCoreTimer();
            while(readCoreTimer() < 20000);
            ms--;
    }
}