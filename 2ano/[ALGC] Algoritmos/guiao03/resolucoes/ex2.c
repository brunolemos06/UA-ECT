#include<stdio.h>
#include <math.h>
long double iterativa(int n,long double ant,long double antant);

int main(void){
    int size = 100;
    // Solução iterativa
    long double valor_anterior=1.0;
    long double valor_anterior_anterior=0.0;
    long double valor_atual;
    printf("P(N) -> iterativa\n");
    for(int n=0;n<=size;n++){
        valor_atual = iterativa(n,valor_anterior,valor_anterior_anterior);
        printf("P(%d) = %Lf\n",n,valor_atual);
        valor_anterior = valor_atual;
        valor_anterior_anterior = valor_anterior;
    }
}
// Solução iterativa
long double iterativa(int n,long double ant,long double antant){
    if(n<2) return n;
    return 3*ant+2*antant;
}