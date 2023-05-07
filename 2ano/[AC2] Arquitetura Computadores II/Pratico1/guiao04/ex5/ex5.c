#include <detpic32.h>

unsigned const char display7Scodes[16] = {0x3F, 0x06, 0x5b, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
unsigned char toBcd(unsigned char value){
    return ((value / 10) << 4) + (value % 10);
}
void delay(int ms){
    while(ms>0){
        resetCoreTimer();
        while(readCoreTimer() < 20000);
        ms--;
    }
}
void send2display(unsigned char value){
    static char displayFlag = 0; // static variable: doesn't loose its value
    int valor;
    int dh = value >> 4;
    int dl = value & 0x0F;

    if(displayFlag){
        LATDbits.LATD6 = 1;                     // display high active
        LATDbits.LATD5 = 0;                     // display low inactive
        valor = display7Scodes[dh] << 8;
        LATB = LATB & 0x80FF | valor;
    }else{
        LATDbits.LATD6 = 0;                     // display high active
        LATDbits.LATD5 = 1;                     // display low inactive
        valor = display7Scodes[dl] << 8;
        LATB = LATB & 0x80FF | valor;
    }
    displayFlag = !displayFlag;
}
int main(void){
    LATB = LATB & 0X80FF;
    TRISB = TRISB | 0x000F; // 0000 0000 0000 1111
    TRISB = TRISB & 0x80FF; // 1000 0000 1111 1111
    TRISDbits.TRISD5 = 0; // RD5 -> OUTPUT
    TRISDbits.TRISD6 = 0; // RD6 -> OUTPUT

    int i = 0;
    while(1){
        int valor =  PORTB & 0x000F;
        i++;
        send2display(toBcd(valor));
        delay(10);
    }
    return 0;
}
