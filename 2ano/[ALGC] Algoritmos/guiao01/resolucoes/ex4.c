#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define PI 3.14159265

int main(void) {   
  int min;
  int max;
  int incr;
  FILE *arq;
  char url[]="table_ex4.txt";
  printf("Digite o menor valor do angulo: ");
  scanf("%d",&min);
  printf("Digite o maior valor do angulo: ");
  scanf("%d",&max);
  printf("Espacamento entre angulos: ");
  scanf("%d",&incr);


  arq = fopen(url, "w");
  if(arq == NULL) {
    
      printf("Erro, nao foi possivel abrir o arquivo\n");
      return -1;
  }
  printf("ang sin(ang)  cos(ang)\n");
  printf("--- -------  -------\n");
  fprintf(arq,"ang sin(ang)  cos(ang)\n");
  fprintf(arq,"--- -------  -------\n");
  for(int i=min;i<=max;i=i+incr) {
    printf("%3.1d %2.4f   %.4f\n",i,sin(i*PI/180),cos(i*PI/180));
    fprintf(arq,"%3.1d %2.4f   %.4f\n",i,sin(i*PI/180),cos(i*PI/180));
  }
  fclose(arq);
  return 0;
}