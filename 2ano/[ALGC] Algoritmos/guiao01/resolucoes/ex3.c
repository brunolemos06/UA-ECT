#include <stdio.h>
#include <math.h>

int main(void){   
   int col;
   printf("Digite o numero de linhas: ");
   scanf("%d",&col);
   printf("num   num^2     sqrt(num)\n");
   printf("---   ----      -------\n");
   for(int i=0;i<col;i++){
     printf("%2.1d     %3.1d      %2.5f\n",i,i*i,sqrt(i));
   }
}
