#include<stdio.h>
#include<assert.h>

int funcao2(int array[],int size,char indice);
int main(void){
    int array1[10] = {1,2,3,4,5,6,7,8,9,10};
    int array2[10] = {1,2,1,4,5,6,7,8,9,10};
    int array3[10] = {1,2,1,3,2,6,7,8,9,10};
    int array4[10] = {0,2,2,0,3,3,0,4,4,0};
    int array5[10] = {0,0,0,0,0,0,0,0,0,0};
    int array6[5]  = {1,2,3,4,5};
    int array7[20] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20};
    int array8[30] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30};
    int array9[40] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40};
    int array10[80] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40};

    funcao2(array1,10,'a');
    funcao2(array2,10,'b');
    funcao2(array3,10,'c');
    funcao2(array4,10,'d');
    funcao2(array5,10,'e');
    funcao2(array6,5,'f');
    funcao2(array7,20,'g');
    funcao2(array8,30,'h');
    funcao2(array9,40,'i');
    funcao2(array10,80,'j');
    
    return 0;
}
int funcao2(int array[],int size,char indice){
    assert(size>2);
    int result = 0;
    int numop = 0;
    for(int k=2;k<size;k++){
        for(int j=1;j<k;j++){
            for(int i=0;i<j;i++){
                if(array[k] == array[i]+array[j]){
                    result+=1;
                }
                numop+=1;
            }
        }
    }
    printf("%C[] = result -> %3.0d numop -> %4.0d\n",indice,result,numop);
    return 0;
}


