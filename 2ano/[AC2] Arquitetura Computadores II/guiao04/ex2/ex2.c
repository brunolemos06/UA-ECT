#include <detpic32.h>
void delay(int ms);
int main(void){

        //Por o valor 0 nos 4 bits menos significativos do porto E
        LATE = LATE & 0xFFF0;
        //Definir os 4 bits menos significativos do porto E como saida
        TRISE = TRISE & 0xFFF0;
        int count = 0x0000;

       while(1){
              LATE = (LATE & 0xFFF0) | count;  // BLA + BLO
              delay(250);
              count++;
              if(count > 0x000F){
                     count = 0x0000;
              }
       }
}

void delay(int ms){
    while(ms>0){
            resetCoreTimer();
            while(readCoreTimer() < 20000);
            ms--;
    }
}