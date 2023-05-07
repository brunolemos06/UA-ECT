#include<stdio.h>
#include<assert.h>
int funcao1(int array[],int size,char indice);
int main(void){
    int array1[10] = {1,2,3,4,5,6,7,8,9,10};
    int array2[10] = {1,2,1,4,5,6,7,8,9,10};
    int array3[10] = {1,2,1,3,2,6,7,8,9,10};
    int array4[10] = {0,2,2,0,3,3,0,4,4,0};
    int array5[10] = {0,0,0,0,0,0,0,0,0,0};
    int array6[4] = {0,0,0,0};

    funcao1(array1,10,'1');
    funcao1(array2,10,'2');
    funcao1(array3,10,'3');
    funcao1(array4,10,'4');
    funcao1(array5,10,'5');
    funcao1(array6,4,'6');

    return 0;
}
int funcao1(int array[],int size,char indice){
    assert(size>2);
    int result = 0;
    int n_op = 0;
    for(int i=1;i<size-1;i++){
        if(array[i] == array[i-1]+array[i+1]){
            result+=1;
        }
        n_op+=1;
    }
    printf("%C[] = resultado -> %d operações -> %d\n",indice,result,n_op);
    return 0;
}


