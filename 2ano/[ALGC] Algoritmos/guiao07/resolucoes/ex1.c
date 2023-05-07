#include<stdio.h>
#include<assert.h>
int F_recursiva(int n);
int F_iterativa(int n);
void printfuncao(int n);
int multiplicacoes=0;

int main(void){

    printfuncao(1); // recursiva
    printfuncao(0); // iterativa
}
int F_recursiva(int n){
    if(n<=2) return 1;

    int somatorio = F_recursiva(n-1)+F_recursiva(n-2);

    for(int k=0;k<=n-3;k++){
        multiplicacoes++;
        somatorio += F_recursiva(k)*F_recursiva(n-3-k);
    }
    return somatorio;
}

int F_iterativa(int n){
    int array[n];
    for(int i = 0;i<=n;i++){
        if(i<=2){
            array[i] = 1;
        }
        else{
            int valor = 0;
            for(int k=0;k<=i-3;k++){
                multiplicacoes++;
                valor += array[k]*array[i-3-k];
            }
            array[i] = valor+array[i-1]+array[i-2];
        }
    }
    return array[n];
}
void printfuncao(int n){
    if(n==1){ //recursiva
        printf("\n-------------------Recursiva-------------------\n");
        for(int i=0;i<=25;i++){
            int value = F_recursiva(i);
            printf("|%2.1d| resultado -> %9.1d, multi -> %8.1d\n",i,value,multiplicacoes);
            multiplicacoes=0;
        }
    }else if(n==0){ //iterativa
        printf("\n-------------------Iterativa-------------------\n");
        for(int i=0;i<=25;i++){
            int value = F_iterativa(i);
            printf("|%2.1d| resultado -> %9.1d, multi -> %8.1d\n",i,value,multiplicacoes);
            multiplicacoes=0;
        } 
    }
}