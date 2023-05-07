#include<detpic32.h>
unsigned const char display7Scodes[16] = {0x3F, 0x06, 0x5b, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
int X=4;
void delay(int ms){
    while(ms>0){
            resetCoreTimer();
            while(readCoreTimer() < 20000);
            ms--;
    }
}
void configurationAD(){
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4= 0;
    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1;
    AD1CON3bits.SAMC = 16;
    AD1CON2bits.SMPI = X-1;
    AD1CHSbits.CH0SA = 4;
    AD1CON1bits.ON = 1;
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
int main(){
    // Configure all (digital I/O, analog input, A/D module)
    LATB = LATB & 0X80FF;
    TRISB = TRISB | 0x000F; // 0000 0000 0000 1111
    TRISB = TRISB & 0x80FF;
    TRISDbits.TRISD5 = 0; // RD5 -> OUTPUT
    TRISDbits.TRISD6 = 0; // RD6 -> OUTPUT
    configurationAD();
    int i = 0;
    while(1){
        int voltage;
        if(i++ % 25 == 0){ // 0, 250ms, 500ms, 750ms, ...
            // Convert analog input (4 samples)
            int soma = 0;
            AD1CON1bits.ASAM = 1; // start conversion

            while( IFS1bits.AD1IF == 0 ); // wait while conversion not done (AD1F == 0)
            int *p = (int *)(&ADC1BUF0);
            int i;
            for(i = 0; i < X; i++){
                int valor = p[i*4];
                printInt( valor, 16 | 3 << 16 );
                printStr(" ");
                soma+=valor;
            }
            voltage = (soma/X*33)/1023;
            int um = voltage/10;
            int dois = voltage%10;
            printStr(" Voltagem = ");
            printInt10(um);
            printStr(".");
            printInt10(dois);
            printStr("V\n");
            IFS1bits.AD1IF = 0;
        }
        // Send voltage value to displays
        int value = ((voltage % 10) * 0x01) + ((voltage / 10) * 0x10);
        send2displays(value);
        delay(10);
        // Wait 10 ms (using the core timer)
    }
    return 0;
}