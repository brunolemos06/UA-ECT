#include<detpic32.h>

unsigned const char display7Scodes[16] = {0x3F, 0x06, 0x5b, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
void delay(int ms){
    while(ms>0){
            resetCoreTimer();
            while(readCoreTimer() < 20000);
            ms--;
    }
}
void send2displays(unsigned char value){
    static char displayFlag = 0; // static variable: doesn't loose its value
    int valor;

    int dh = value >> 4 ;
    int dl = value & 0x0F;

    if(displayFlag){
        LATDbits.LATD5 = 0;
        LATDbits.LATD6 = 1;
        valor = display7Scodes[dh] << 8;
        LATB = LATB & 0x80FF | valor;
    }else{
        LATDbits.LATD5 = 1;
        LATDbits.LATD6 = 0;
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

    // select display low
    unsigned int i = 0;
    int counter = 0;
    while(1){
        i++;
        send2displays(counter);
        delay(10);
        if(i % 5 == 0){
            counter++;
        }
    }
    return 0;
}