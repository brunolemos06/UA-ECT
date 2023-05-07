#include<detpic32.h>

void main(void){
    // Configure Timer T1 (2 Hz with interrupts disabled) [TIMER 1]
    T1CONbits.TCKPS = 7; 
    PR1 = 39062;
    TMR1 = 0;
    T1CONbits.TON = 1;
    // Configure Timer T3 (10 Hz with interrupts disabled) [TIMER 3]
    T3CONbits.TCKPS = 5; 
    PR3 = 62499;
    TMR3 = 0;
    T3CONbits.TON = 1;
    //#########################
    IPC1bits.T1IP = 2; // Interrupt priority (must be in range [1..6])
    IEC0bits.T1IE = 1; // Enable timer T1 interrupts
    IFS0bits.T1IF = 0; // Reset timer T1 interrupt flag
    //########################
    IPC3bits.T3IP = 3; // Interrupt priority (must be in range [1..6])
    IEC0bits.T3IE = 1; // Enable timer T3 interrupts
    IFS0bits.T3IF = 0; // Reset timer T3 interrupt flag



    EnableInterrupts();
    while(1);
}

void _int_(12) isr_T3(void){ //TIMER 3
    //CODE HERE
    putChar('1');
    IFS0bits.T3IF = 0;// Reset T3 interrupt flag
}
void _int_(4) isr_T1(void){ //TIMER 1
    //CODE HERE
    putChar('3');
    IFS0bits.T1IF = 0;// Reset T1 interrupt flag
}