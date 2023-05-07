#include<detpic32.h>
unsigned const char display7Scodes[16] = {0x3F, 0x06, 0x5b, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
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
    AD1CON2bits.SMPI = 2-1;
    AD1CHSbits.CH0SA = 4;
    AD1CON1bits.ON = 1;
}
int main(void){
    TRISB = TRISB & 0x80FF;      // saida 1000 0000 1111 1111      
    TRISDbits.TRISD5 = 0;       // RD5 -> OUTPUT
    TRISDbits.TRISD6 = 0;       // RD6 -> OUTPUT
    
    configurationAD();
    while(1){
        AD1CON1bits.ASAM = 1;           // Start conversition
        while( IFS1bits.AD1IF == 0 );   // Wait while conversion not done (AD1IF == 0)
        int *p = (int *)(&ADC1BUF0);
        int i;
        int soma =0;
        for(i = 0; i < 2; i++){
            soma+=p[i*4];
        }
        printStr("Hexa -> ");
        int valor  = soma/2;
        printInt(valor,16 | 3 << 16);
        printStr("\n");

        valor =  (valor*33)/1023;
        if(valor <12){     // mostra A l
            LATDbits.LATD5 = 1;
            LATDbits.LATD6 = 0;
            unsigned char valor = display7Scodes[10];
            LATB = LATB & 0x80FF | valor << 8; // limpa e mete o valor
        }else{              // mostra B h
            LATDbits.LATD5 = 0;
            LATDbits.LATD6 = 1;
            unsigned char valor = display7Scodes[11];
            LATB = LATB & 0x80FF | valor << 8; // limpa e mete o valor
        }
        delay(100);
        IFS1bits.AD1IF = 0;             // reset
    }

}