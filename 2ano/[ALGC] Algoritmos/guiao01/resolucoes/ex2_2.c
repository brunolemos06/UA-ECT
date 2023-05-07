#include <stdio.h>

int main(int argc,char **argv){   
    if(argc>2){
        printf("Hello %s %s !!\n",argv[1],argv[2]);
    }else{
        printf("Usar: .\\ex2_2.exe nome apelido\n");
    }
    return 0;
}