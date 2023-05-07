#include<stdio.h>
#include <math.h>
double recursiva(int n);

int main(void){   
    int size = 100;

    //Solução recursiva
    printf("P(N) -> recursiva\n");
    for(int n=0;n<=size;n++){
        printf("P(%d) = %f\n",n,recursiva(n));
    }
}


// Solução recursiva
double recursiva(int n){
    if(n<2) return n;
    return 3*recursiva(n-1)+2*recursiva(n-2);
}
