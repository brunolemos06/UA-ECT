#include<stdio.h>
unsigned int f1(unsigned int n);
unsigned int f2(unsigned int n);
unsigned int f3(unsigned int n);
unsigned int f4(unsigned int n);
int main ( void ){
    for(int m=1;m<=15;m++){
        printf("----f(%d)----\n",m);
        //printf("f1(%d) -> %d\n",m,f1(m));
        //printf("f2(%d) -> %d\n",m,f2(m));
        //printf("f3(%d) -> %d\n",m,f3(m));
        printf("f4(%d) -> %d\n",m,f4(m));
    }
}

unsigned int f1(unsigned int n){
    unsigned int i, j, r, count = 0;
    for(i = 1;i <= n; i++){
        for(j = 1; j <= n; j++){
            count+=1;
            r += 1;
        }
    }
    printf("n-iterações -> %d\n",count);
    return r;
}

unsigned int f2(unsigned int n){
    unsigned int i, j, r, count = 0;
    for(i = 1;i <= n; i++){
        for(j = 1; j <= i; j++){
            count+=1;
            r += 1;
        }
    }
    printf("n-iterações -> %d\n",count);
    return r;
}

unsigned int f3(unsigned int n){
    unsigned int i, j, r, count = 0;
    for(i = 1;i <= n; i++){
        for(j = i; j <= n; j++){
            count+=1;
            r += j;
        }
    }
    printf("n-iterações -> %d\n",count);
    return r;
}
unsigned int f4(unsigned int n){
    unsigned int i, j, r, count= 0;
    for(i = 1;i <= n; i++){
        for(j = i; j >= 1; j/=10){
            count+=1;
            r += i;
        }
    }
    printf("n-iterações -> %d\n",count);
    return r;
}
