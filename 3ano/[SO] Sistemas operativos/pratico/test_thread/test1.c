#include <stdio.h>
#include <pthread.h>
int counter = 10;
/*thread function definition*/
void* threadFunction(void* args){
    while(counter > 0){
        printf("I am threadFunction.\n");
    }
}

int main()
{
    /*creating thread id*/
    pthread_t id;
    int ret;
    
    /*creating thread*/
    ret=pthread_create(&id,NULL,&threadFunction,NULL);
    if(ret==0){
        printf("Thread created successfully.\n");
    }
    else{
        printf("Thread not created.\n");
        return 0; /*return from main*/
    }
    
    while(counter >= 0){
        printf("c: %d , I am main function.\n",counter--);   
    }
    
    return 0;
}
