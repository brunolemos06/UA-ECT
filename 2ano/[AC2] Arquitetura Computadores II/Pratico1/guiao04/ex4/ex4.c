#include <detpic32.h>
void delay(int ms){
    while(ms>0){
        resetCoreTimer();
        while(readCoreTimer() < 20000);
        ms--;
    }
}
int main(void){
    unsigned char segment;
    LATDbits.LATD6 = 1;                     // display high active
    LATDbits.LATD5 = 0;                     // display low inactive

    TRISB = TRISB & 0x80FF;                 // configure RB8-RB14 as outputs
    TRISDbits.TRISD5 = 0;                   // configure RD5-RD6 as outputs
    TRISDbits.TRISD6 = 0;

    while(1){
        LATDbits.LATD6 = !LATDbits.LATD6;   //
        LATDbits.LATD5 = !LATDbits.LATD5;   // toggle display selection
        segment = 1;
        int i;
        for(i=0; i < 7; i++){
            LATB = ( LATB & 0x80FF ) | ( segment << 8 );   // send "segment" value to display
            delay(100);                     // wait 0.5 second -> 2hz
            segment = segment << 1;
        }
    }
    return 0;
}