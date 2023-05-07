#include <detpic32.h>
void delay(int ms){
       while(ms>0){
              resetCoreTimer();
              while(readCoreTimer() < 20000);
              ms--;
       }
}
int main(void){
    TRISE = TRISE & 0xFFF0;  // configurar a 0 os ultimos 4 bits
    int counter = 0;
    while(1){
        delay(250);
        LATE = LATE & 0xFFF0;
        LATE = LATE | counter;
        counter++;
    }
    return 0;
}