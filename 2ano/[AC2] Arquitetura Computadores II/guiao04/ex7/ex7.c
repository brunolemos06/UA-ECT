#include <detpic32.h>
void delay(int ms){
    while(ms>0){
            resetCoreTimer();
            while(readCoreTimer() < 20000);
            ms--;
    }
}
int main(void){
    unsigned char display7Scodes[16] = {0x3F, 0x06, 0x5b, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
    
    LATB = LATB & 0X80FF;
    TRISB = TRISB | 0x000F; // 0000 0000 0000 1111
    TRISB = TRISB & 0x80FF; // 1000 0000 1111 1111

    TRISDbits.TRISD5 = 0; // RD5 -> OUTPUT
    TRISDbits.TRISD6 = 0; // RD6 -> OUTPUT

    // select display low
    LATDbits.LATD5 = 1;
    LATDbits.LATD6 = 0;
    while(1){
        // read dip-switch
        unsigned int var = PORTB & 0x000F;
        // convert to 7 segments code
        unsigned int code = display7Scodes[var];
        // send to display
        code = code << 8;
        LATB = LATB & 0x00FF;
        LATB = LATB | code;
        delay(100);
    }
    return 0;

}