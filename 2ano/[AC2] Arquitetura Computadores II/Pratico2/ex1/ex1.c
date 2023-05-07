#include <detpic32.h>
void setPWM(unsigned int dutyCycle){
    if(dutyCycle <= 100 || dutyCycle >= 0){
        OC2RS = ((PR2 + 1)*dutyCycle)/100;
    }
}
void configAll(){
    // timer2 280hz
    T2CONbits.TCKPS = 1;    // 1:2
    PR2 = 35714;            //
    TMR2 = 0;               //
    T2CONbits.TON = 1;      //

    OC2CONbits.OCM = 6;     //PWM mode on OCx; fault pin disabled
    OC2CONbits.OCTSEL = 0; //Use timer T2 as the time base for PWM generation
    setPWM(0);
    OC2CONbits.ON = 1; // Enable OC1 module

    IPC2bits.T2IP = 2; // Interrupt priority (must be in range [1..6])
    IEC0bits.T2IE = 1; // Enable timer T2 interrupts
    IFS0bits.T2IF = 0; // Reset timer T2 interrupt flag

}
void delay(int ns){ // micro segundos
    while(ns>0){
        resetCoreTimer();
        while(readCoreTimer() < (20000/100));
        ns--;
    }
}

int main(void){
    TRISB = TRISB | 0x000F; // configurar como entrada [1] (1 é o elemento abosrvente de ou)
    configAll();
    int ds4;
    int ds1;
    while(1){
        ds4 = PORTB & 0x0008;
        ds1 = PORTB & 0x0001;
        if(ds4 == 8 && ds1 == 0){
            setPWM(25);
            putChar('A');
            putChar('\n');
        }
        else if(ds4 == 0 && ds1 == 1){
            setPWM(70);
            putChar('B');
            putChar('\n');
        }
        delay(250);
    }
    return 0;
}