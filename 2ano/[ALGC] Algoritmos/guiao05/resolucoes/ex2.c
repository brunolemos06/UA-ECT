#include<stdio.h>
#include<assert.h>

//declaração de funções
void funcao2(int array[],int size,char indice);
int printarray(int array[],int size,char indice);
int Is_Multiplo_Divisor(int array[],int op1,int n);

//declaração de variáveis globais
int numero_comparacoes = 0;
int deslocamentos = 0;

//main
int main(void){
    int array1[10] = {2,2,2,3,3,4,5,8,8,9};
    int array2[10] = {7,8,2,2,3,3,3,8,8,9};
    int array3[10]  = {2,3,5,7,11,13,17,19,23,29};
    int array4[10] = {2,2,2,2,2,2,2,2,2,2};
    int array5[10] = {1,2,3,4,5,6,7,8,9,};
    int array6[10] = {2,2,3,5,7,11,13,17,19,23};


    funcao2(array1,10,'1');
    funcao2(array2,10,'2');
    funcao2(array3,10,'3');
    funcao2(array4,10,'4');
    funcao2(array5,10,'5');
    funcao2(array6,10,'6');
    
}

//funcoes
void funcao2(int array[],int size,char indice){
    assert(size>1);
    numero_comparacoes = 0;
    deslocamentos = 0;
    int n_op = 0;
    int n=1;
    for(int i=1;i<size;i++){
        numero_comparacoes++;
        if(!Is_Multiplo_Divisor(array,array[i],n)){
            numero_comparacoes++;
            if( array[n] != array[i] ){
                deslocamentos++;
                array[n] = array[i];
            }
            n++;
        }
    }
    printarray(array,n,indice);
}

int Is_Multiplo_Divisor(int array[],int op1,int n){
    for(int k=0;k<n;k++){
        int op2 = array[k];
        numero_comparacoes++;
        if(op1%op2 == 0){ // nem divisor nem multiplo
            return 1;
        }
        numero_comparacoes++;
        if(op2%op1 == 0){ // ....
            return 1;
        }
    }
    return 0;
}


int printarray(int array[],int size,char indice){
    printf("-> %C[] Array Final = [",indice);
    for( int i = 0 ; i < size; i++){
        printf(" %.1d ", array[i]);
    }
    printf("]\n");
    printf("-> operaçoes = %d\n",numero_comparacoes);
    printf("-> deslocamentos = %d\n\n",deslocamentos);
    return 0;
}

