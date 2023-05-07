#include<stdio.h>
#include <math.h>

long long recorr(int n);

int main(void){   
    int size = 100;

    //Equaçao de recorrencia
    printf("P(N) -> recorrencia\n");
    for(int n=0;n<=size;n++){
        printf("P(%d) = %Ld\n",n,recorr(n));
    }
}
long long recorr(int n){
    long double c1 = 0.24253562503633297352;
    long double c2 = 1.27019663313689157536;
    long double base = 2.71828182846;
    long double exp = c2*n;
    long double valor = pow(base,exp);
    return round(c1*valor);
}