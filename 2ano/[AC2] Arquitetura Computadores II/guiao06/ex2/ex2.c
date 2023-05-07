#include <detpic32.h>
void delay(int ms);
int voltageConversion(int VAL_AD);
void send2displays(char value);
int toBcd(int value);

volatile unsigned char voltage = 0; // Global variable

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
int main(void){
    unsigned counter = 0;
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

    EnableInterrupts();
    // Global Interrupt Enable
    // Start A/D conversion
    while(1){
        if((counter % 25) == 0){ // 250ms ()
            AD1CON1bits.ASAM = 1; 
        }
        send2displays(voltage);
        counter++;
        delay(10);  // 1000/(ms) = (hz)
    }
    // all activity is done by the ISR
    return 0;
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