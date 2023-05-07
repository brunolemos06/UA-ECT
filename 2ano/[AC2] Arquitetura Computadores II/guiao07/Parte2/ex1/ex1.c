#include<detpic32.h>
void setPWM(unsigned int dutyCycle);

int main(void){
    //------------------------------------------------------------
    // Configure Timer T3 (100 Hz with interrupts disabled) [TIMER 1]
    T3CONbits.TCKPS = 2; 
    PR3 = 49999;
    TMR3 = 0;
    T3CONbits.TON = 1;

    OC1CONbits.OCM = 6;     //PWM mode on OCx; fault pin disabled
    OC1CONbits.OCTSEL = 0; //Use timer T2 as the time base for PWM generation
    setPWM(25); // Ton constant
    // ((PR3 + 1) * 25[dutyCicle]) / hz
    // neste caso fazemos
    // ((49999 + 1) * 25) / 100 = 12500;

    OC1CONbits.ON = 1; // Enable OC1 module

    IPC3bits.T3IP = 2; // Interrupt priority (must be in range [1..6])
    IEC0bits.T3IE = 1; // Enable timer T3 interrupts
    IFS0bits.T3IF = 0; // Reset timer T3 interrupt flag

    EnableInterrupts();
    while(1);
}
void setPWM(unsigned int dutyCycle){
    if(dutyCycle <= 100 || dutyCycle >= 0){
        OC1RS = ((PR3 + 1)*dutyCycle)/100;
    }
}
void _int_(12) isr_T3(void){
    IFS0bits.T3IF = 0;      //RESET TIMER 3
}

