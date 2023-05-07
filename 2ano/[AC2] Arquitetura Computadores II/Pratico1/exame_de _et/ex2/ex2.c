#include<detpic32.h>
unsigned const char display7Scodes[16] = {0x3F, 0x06, 0x5b, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
void delay(int ms){
    while(ms>0){
        resetCoreTimer();
        while(readCoreTimer() < 20000);
        ms--;
    }
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
int main(void){
    TRISE = TRISE & 0xFF80 ;                 // configurar como saida 1111 1111 1000 0000
    TRISB = (TRISB | 0x0003) & 0x80FF ;      // configurar com entrada 0000 0000 0000 0011 e 1000 0000 1111 1111
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;
    int counter = 0;
    int in;
    int i=0;
    int k;
    while(1){
        // ler key
        in = inkey();
        if(in >= '1' & in <= '9') k=in;
        // Leitura dos dip-switches
        unsigned int op = PORTB & 0x0003 ;           // clean 0000 0000 0000 00011
        switch (op){
            case 0:
                LATDbits.LATD5 = 0;
                LATDbits.LATD6 = 0;
                break;
            case 1:
                if(k >= '1' & k <= '9'){
                    send2displays(k<<4);
                }        
                break;
            case 2:
                if(k >= '1' & k <= '9'){
                    send2displays(k & 0x0F);
                } 
                break;
            case 3:
                send2displays(counter);
                break;
        }
        LATE = (LATE & 0xFF80) | counter;
        if(i%20==0)counter++;
         if(counter == 60) counter = 0;
        delay(10);
        i++;
    }

}