#include <detpic32.h>
void putc(char byte2send);
void puts(char *str);
void configUart(unsigned int baud, char party, unsigned int stopbits);
char getc(void);
int configurationAll(void);
int toBcd(int value);
unsigned int DS4, DS3, DS2, DS1;
volatile char global;

int main(void){
    configUart(115200,'N',1);
    
    IPC8bits.U2IP = 1;
	IFS1bits.U2RXIF = 0;
	IEC1bits.U2RXIE = 1;

    configurationAll();
    EnableInterrupts();
    while(1){
        DS1 = PORTB & 0x0001;
        DS2 = PORTB & 0x0002;
        DS3 = PORTB & 0x0004;
        DS4 = PORTB & 0x0008;

        if(global == 'P'){
            puts("DipSwitch=");
            if(DS1==1) putc('1');
            else putc('0');
            if(DS2==2) putc('1');
            else putc('0');
            if(DS3==4) putc('1');
            else putc('0');
            if(DS4==8) putc('1');
            else putc('0');
            putc('\n');
            global = '\0';
        }
        if(global == 'T'){
            LATEbits.LATE4 = !LATEbits.LATE4;
            global = '\0';
        }
    }
    return 0;
}

void _int_(32) isr_uart(void){
    global = getc();
    IFS1bits.U2RXIF = 0;
}

void configUart(unsigned int baud, char parity, unsigned int stopbits){
    // Configure UART2
    if (baud >= 600 && baud <= 115200)
        U2BRG = ((PBCLK + 8 * baud) / (16 * baud)) - 1;    // Aproximate to closest baudrate
    else
        U2BRG = 10;                     // DEFAULT 115200 baudrate
    
    if (parity == 'N')
        U2MODEbits.PDSEL = 0b00;        // 00 = 8-bit data, no parity
    else if (parity == 'E')
        U2MODEbits.PDSEL = 0b01;        // 01 = 8-bit data, even parity
    else if (parity == 'O')
        U2MODEbits.PDSEL = 0b10;        // 10 = 8-bit data, odd parity
    else
        U2MODEbits.PDSEL = 0b00;        // DEFAULT NO PARITY 8 BITS

    if (stopbits == 1 || stopbits == 2)  
        U2MODEbits.STSEL = stopbits - 1;// Number of stopbits
    else
        U2MODEbits.STSEL = 0;           // DEFAULT 1 STOPBIT

    U2MODEbits.BRGH = 0;                // Divide by 16
    U2STAbits.URXEN = 1;                // Enable Receiver
    U2STAbits.UTXEN = 1;                // Enable Transmitter
    U2MODEbits.ON = 1;                  // Enable UART2
}
int configurationAll(void){
    TRISB = TRISB | 0x000F; // configurar DEEPSWICTHS
    TRISEbits.TRISE4 = 0;   // LCONFIGURAR LED
    LATEbits.LATE4 = 1;     //LIGAR LED
}
char getc(void){
    if (U2STAbits.OERR == 1){
        U2STAbits.OERR = 0;
    }
    while(U2STAbits.URXDA == 0);
    return U2RXREG;
}
void putc(char c)
{
	while(U2STAbits.UTXBF == 1);
	U2TXREG = c;
}
void puts(char *str){
    while (*str != '\0'){
        putc(*str);
        str++;
    }
}
int toBcd(int value){
    return ((value % 10) * 0x01) + ((value / 10) * 0x10);
}