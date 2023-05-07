#include <stdio.h>

int main(void)
{   
   char nome[21], sobrenome[21];
 
    printf("Primeiro nome: ");
    scanf("%s", nome);
 
    printf("Ultimo sobrenome: ");
    scanf("%s", sobrenome);
 
    printf("Hello %s %s!!\n", nome, sobrenome);
    return 0;
}