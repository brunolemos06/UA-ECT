#include<stdio.h>
#include<assert.h>

int chamadas = 0;
//declaração de funções
int T1(int n);
int T2(int n);
int T3(int n);

//main
int main(void){
    for(int i=0;i<=50;i++){
        int valor;

        valor = T1(i);
        printf(" T1(%2.1d) = %3.1d , chamadas = %d\n",i,valor,chamadas);
        chamadas=0;

        valor = T2(i);
        printf(" T2(%2.1d) = %3.1d , chamadas = %d\n",i,valor,chamadas);
        chamadas=0;

        // valor = T3(i);
        // printf(" T3(%2.1d) = %3.1d , chamadas = %d\n",i,valor,chamadas);
        // chamadas=0;

        printf("-----------------------------\n");
    }
}
int T1(int n){
    assert(n >= 0);
    if(n > 0){
        chamadas++;
        return T1(n/4)+n;
    }else{
        return 0;
    }
}

int T2(int n){
    assert(n >= 0);
    if(n > 3){
        chamadas+=2;
        return (T2(n/4)+T2((n+3)/4)+n);
    }else{
        return n;
    }
}

int T3(int n){
    assert(n >= 0);
    if(n<=3){
        return n;
    }else if(n%4==0){
        chamadas++;
        return (2*T3(n/4)+n );
    }else{
        chamadas+=2;
        return ( T3(n/4)+T3((n+3)/4)+ n );
    }
}