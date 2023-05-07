#include<detpic32.h>
void delay(int ms){
    while(ms>0){
            resetCoreTimer();
            while(readCoreTimer() < 20000);
            ms--;
    }
}
void configA_D(){

    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4= 0;
    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1;
    AD1CON3bits.SAMC = 16;
    AD1CON2bits.SMPI = 4-1;
    AD1CHSbits.CH0SA = 4;
    AD1CON1bits.ON = 1;

}
int main(void){
    configA_D();                        // Configure the A/D module and port RB4 as analog input
    while(1){
        AD1CON1bits.ASAM = 1;           // Start conversition
        while( IFS1bits.AD1IF == 0 );   // Wait while conversion not done (AD1IF == 0)
        delay(500);
        int *p = (int *)(&ADC1BUF0);
        int i;
        int soma =0;
        for(i = 0; i < 4; i++){
            int valor = p[i*4];
            printInt( valor, 16 | 3 << 16 );
            printStr(" ");
            soma+=valor;
        }
        int V = (soma/4*33)/1023;
        int frac1 = V%10;
        int frac2 = V/10;
        printStr("Voltagem -> ");
        printInt10(frac1);
        printStr(".");
        printInt10(frac2);
        printStr("V\n");
        IFS1bits.AD1IF = 0;
    }
}
