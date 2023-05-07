#include <stdio.h>
void printArray(char *s,int size,int a[]);
void cumSum(int a[],int size,int b[]);

int main(void){
    int a[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
    printArray("a",12,a);

    int b[12];
    cumSum(a,12,b);
    printArray("b",12,b);
}

void printArray(char *s,int size,int a[]){
    printf("%s : ",s);
    for (int i = 0; i < size; i++){
       printf("%d ",a[i]); 
    }
    printf("\n");
}

void cumSum(int a[],int size,int b[]){
    int c = 0;
    for (int i = 0; i < size; i++){
        c += a[i];
        b[i] = c;
    }   
}
