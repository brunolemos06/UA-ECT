#include <stdio.h>
int main(void){ 

    printf("\nsizeof(void *) ...... %I64ld\n",sizeof(void *));
    printf("sizeof(void) ........ %I64ld\n",sizeof(void));
    printf("sizeof(char) ........ %I64ld\n",sizeof(char));
    printf("sizeof(short) ....... %I64ld\n",sizeof(short));
    printf("sizeof(int) ......... %I64ld\n",sizeof(int));
    printf("sizeof(long) ........ %I64ld\n",sizeof(long));
    printf("sizeof(long long) ... %I64ld\n",sizeof(long long));
    printf("sizeof(float) ....... %I64ld\n",sizeof(float));
    printf("sizeof(double) ...... %I64ld\n\n",sizeof(double));

    return 0;
}
