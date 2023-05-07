#include<detpic32.h>
int flag = 0;
void main(void){
// Configure Timer T3 (2 Hz with interrupts disabled)
T3CONbits.TCKPS = 7; 
PR3 = 39062;
TMR3 = 0;
T3CONbits.TON = 1;

IPC3bits.T3IP = 2; // Interrupt priority (must be in range [1..6])
IEC0bits.T3IE = 1; // Enable timer T2 interrupts
IFS0bits.T3IF = 0; // Reset timer T2 interrupt flag



EnableInterrupts();
while(1);
}
void _int_(12) isr_T3(void){
    if(flag) putChar('.');
    flag = !flag;
    IFS0bits.T3IF = 0;// Reset T3 interrupt flag
}