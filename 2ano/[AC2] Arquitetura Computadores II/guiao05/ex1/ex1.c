#include<detpic32.h>
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


int main(void){
    configurationAD();
    while(1){
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
        int V = (soma/X*33)/1023;
        int um = V/10;
        int dois = V%10;
        printStr(" Voltagem = ");
        printInt10(um);
        printStr(".");
        printInt10(dois);
        printStr("V\n");
        delay(500);

        IFS1bits.AD1IF = 0;
    }
    return 0;
}
