#include<stdio.h>
#include<assert.h>
//declaração de funções
int funcao1(int array[],int size,char indice);

//main
int main(void){

    int array1[11] = {1,2,3,4,5,6,7,8,9,10,11};
    int array2[11] = {1,2,4,4,5,6,7,8,9,10,11};
    int array3[11] = {1,2,4,8,5,6,7,8,9,10,11};
    int array4[11] = {1,2,4,8,16,6,7,8,9,10,11};
    int array5[11] = {1,2,4,8,16,32,7,8,9,10,11};
    int array6[11] = {1,2,4,8,16,32,64,8,9,10,11};
    int array7[11] = {1,2,4,8,16,32,64,128,9,10,11};
    int array8[11] = {1,2,4,8,16,32,64,128,256,10,11};
    int array9[11] = {1,2,4,8,16,32,64,128,256,512,11};
    int array10[11] = {1,2,4,8,16,32,64,128,256,512,1024};

    funcao1(array1,11,'1');
    funcao1(array2,11,'2');
    funcao1(array3,11,'3');
    funcao1(array4,11,'4');
    funcao1(array5,11,'5');
    funcao1(array6,11,'6');
    funcao1(array7,11,'7');
    funcao1(array8,11,'8');
    funcao1(array9,11,'9');
    funcao1(array10,11,'a');
   
}

//funcoes
int funcao1(int array[],int size,char indice){
    assert(size>2);
    int result = 1;
    int n_op = 0;
    n_op++;
    double r = array[1]/array[0];
    for(int i=2;i<size;i++){
        n_op++;
        if(array[i]!=r*array[i-1]){
            result = 0;
            break;
        }
    }
    printf("%C[] = resultado -> %d operações -> %d\n",indice,result,n_op);
    return result;
}

