#include <detpic32.h>
void configureUART(){
    // Configure UART2
    U2BRG = 10;                 // U2BRG = (20Mhz / (16[fator de divisao]*115200[bps]))-1 ~ 10          
    U2MODEbits.PDSEL = 0b00;    // 00 = 8-bit data, no parity
    U2MODEbits.STSEL = 0;       // only 1 stop bit
    U2MODEbits.BRGH = 0;        // divide by 16 = 0 // divide by 4 = 1
    U2STAbits.URXEN = 1;        // Enable Receiver
    U2STAbits.UTXEN = 1;        // Enable Transmitter
    U2MODEbits.ON = 1;          // Enable UART2
}
int main(void){
    configureUART();
    return 0;
}