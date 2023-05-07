#include <detpic32.h>
// Global variable

int voltageConversion(int VAL_AD){
    return (VAL_AD * 33 + 511) / 1023; 
}
void send2displays(char value){
    static const char display7Scodes[] = { 0x3F, 0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71};

    static int displayFlag = 0;

    unsigned char dh = value >> 4;      // Get the index of the decimal part
    unsigned char dl = value & 0x0F;    // Get the index of the unitary part
    dh = display7Scodes[dh];
    dl = display7Scodes[dl];
    
    if (displayFlag == 0){
        LATD = (LATD | 0x0040) & 0xFFDF;    // Dipslay High active and Display Low OFF
        LATB = (LATB & 0x80FF) | ((unsigned int)(dh)) << 8; // Clean the display and set the right value
    } else {
        LATD = (LATD | 0x0020) & 0xFFBF;    // Display High OFF and Display High active
        LATB = (LATB & 0x80FF) | ((unsigned int)(dl)) << 8; // Clean the display and set the right value
    }
    displayFlag = !displayFlag;
}
char toBcd(char value)
{
	return ((value/10) << 4) + (value % 10);
}
void configureADC(){

        TRISBbits.TRISB4 = 1;
        AD1PCFGbits.PCFG4 = 0;
        AD1CON1bits.SSRC = 7;

        AD1CON1bits.CLRASAM = 1;

        AD1CON3bits.SAMC = 16;
        AD1CON2bits.SMPI = 2-1;

        AD1CHSbits.CH0SA = 4;

        AD1CON1bits.ON = 1;
}
void configureTimers(){
    // timer2 120hz
    T2CONbits.TCKPS = 2;    // 1:4
    PR2 = 41666;            //
    TMR2 = 0;               //
    T2CONbits.TON = 1;      //

    IPC2bits.T2IP = 2; // Interrupt priority (must be in range [1..6])
    IEC0bits.T2IE = 1; // Enable timer T2 interrupts
    IFS0bits.T2IF = 0; // Reset timer T2 interrupt flag
    // #################################################################
}
void delay(int ms){
    for (; ms > 0; ms--){
        resetCoreTimer();
        while (readCoreTimer() < 20000);
    }
}
static int temperatura = 0;
int main(void){

        configureADC();
        configureTimers();

        LATDbits.LATD5 = 0;
        LATDbits.LATD6 = 1;
        LATB = LATB & 0x80FF;

        TRISDbits.TRISD5 = 0;
        TRISDbits.TRISD6 = 0;
        TRISB = TRISB & 0x80FF;

        AD1CON1bits.ASAM = 1;
        //IFS0bits.T2IF = 0;
        EnableInterrupts();

        while(1){
            delay(100);
                AD1CON1bits.ASAM = 1;
                while(IFS1bits.AD1IF == 0);
                int i;
                int soma = 0;
                int *p = (int *)&ADC1BUF0;
                for(i = 0; i < 2; i++){
                        soma = soma + voltageConversion(p[i*4]);
                }
                temperatura = soma / 2;
                temperatura = (temperatura*45)/33 +20 ;
                IFS1bits.AD1IF = 0;
        }

        return 0;
}
void _int_(8) isr_t2(void){
    send2displays(toBcd(temperatura));
    IFS0bits.T2IF = 0;         // Reset T2 interrupt flag
}
