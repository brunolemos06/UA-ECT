#include <detpic32.h>
void delay(int ms);
int voltageConversion(int VAL_AD);
void send2displays(char value);
int toBcd(int value);
void configureAll();
void configurationAD();

volatile unsigned char voltage = 0; // Global variable
void configureAll(){
    //------------------------------------------------------------
    // Configure Timer T1 (100 Hz with interrupts disabled) [TIMER 1]
    T1CONbits.TCKPS = 7; 
    PR1 = 19531;
    TMR1 = 0;
    T1CONbits.TON = 1;
    // Configure Timer T3 (4 Hz with interrupts disabled) [TIMER 3]
    T3CONbits.TCKPS = 2; 
    PR3 = 49999;
    TMR3 = 0;
    T3CONbits.TON = 1;
    //#########################
    IPC1bits.T1IP = 2; // Interrupt priority (must be in range [1..6])
    IEC0bits.T1IE = 1; // Enable timer T1 interrupts
    IFS0bits.T1IF = 0; // Reset timer T1 interrupt flag
    //########################
    IPC3bits.T3IP = 1; // Interrupt priority (must be in range [1..6])
    IEC0bits.T3IE = 1; // Enable timer T3 interrupts
    IFS0bits.T3IF = 0; // Reset timer T3 interrupt flag

    //------------------------------------------------------------
    // Configure all (digital I/O, analog input, A/D module)
    LATB = LATB & 0X80FF;
    TRISB = TRISB | 0x000F;             // 0000 0000 0000 1111
    TRISB = TRISB & 0x80FF;
    TRISDbits.TRISD5 = 0;               // RD5 -> OUTPUT
    TRISDbits.TRISD6 = 0;               // RD6 -> OUTPUT
    configurationAD();
    
    // Enable interrupts ADC
    IPC6bits.AD1IP = 2;         // configure priority of A/D interrupts
    IFS1bits.AD1IF = 0;         // clear A/D interrupt flag
    IEC1bits.AD1IE = 1;         // enable A/D interrupts

     // Configure displays
    TRISB = TRISB & 0x80FF;         // RB14 to RB8 as output
    TRISD = TRISD & 0xFF9F;         // Displays high/low as output

    //configure deepswitchs
    TRISB = TRISB | 0x0003;
}
void configurationAD(){
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4= 0;
    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1;

    AD1CON3bits.SAMC = 16;
    AD1CON2bits.SMPI = 8-1;
    AD1CHSbits.CH0SA = 4;
    AD1CON1bits.ON = 1;
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
int voltageConversion(int VAL_AD){
    return (VAL_AD * 33 + 511) / 1023; 
}
int toBcd(int value){
    return ((value/10) << 4) + (value % 10);
}
void delay(int ms){
    for (; ms > 0; ms--)
    {
        resetCoreTimer();
        while (readCoreTimer() < 20000);
    }
}
void _int_(27) isr_adc(void) {
    int *p = (int *) &ADC1BUF0;
    int i, average = 0;

    for (i = 0; i < 8; i++)
        average += p[i * 4];

    voltage = toBcd(voltageConversion(average / 8));
    
    IFS1bits.AD1IF = 0;
}
void _int_(12) isr_T3(void){ //TIMER 3
    send2displays(voltage);
    IFS0bits.T3IF = 0;// Reset T3 interrupt flag
}
void _int_(4) isr_T1(void){ //TIMER 1
    AD1CON1bits.ASAM = 1; 
    IFS0bits.T1IF = 0;// Reset T1 interrupt flag
}
int main(void){
    configureAll();
    EnableInterrupts();
    int in;
    while(1){
        in = PORTB & 0x03; // mete -> 0000 0011
        if(in == 1){
            IEC0bits.T1IE = 0;
        }else{
            IEC0bits.T1IE = 1;
        }
    }
    return 0;
}