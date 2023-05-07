#include<stdio.h>

unsigned int fatorial( int n );
int main (void){
    int valores[] = {fatorial(0),fatorial(1),fatorial(2),fatorial(3),fatorial(4),fatorial(5),fatorial(6),fatorial(7),fatorial(8),fatorial(9)};
    printf("Fatoriões -> ");
    for(int i=1;i<10000;i++){
        int sum=0;
        int number = i*1;
        while(number){
            sum += valores[number%10];
            number/=10;                                                                                                                                                                                                                                                                                                                                         
        }
        if(sum == i){
            printf("%d ",i);
        }

    }
    printf("\n");
}
unsigned int fatorial( int n ){
    unsigned int f = 1;
    for( ; n > 0; f *= n--);
    return f;
}
