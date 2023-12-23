#include <stdio.h>

#define ALL_SIZE 16*16
#define SIZE 

int main(int argc, char **argv) {
    unsigned char magic[ALL_SIZE];
    FILE *file = fopen(argv[1], "rb");

    if (!file || fread(magic, 1, ALL_SIZE, file) != ALL_SIZE) {
        fprintf(stderr, "Failure to read file magic.\n");
        return 1;
    }


    /* Hexadecimal */
    for (int i = 0; i < ALL_SIZE; i++) {
        printf("%02x ", magic[i]);
        if ((i + 1) % 16 == 0) {
            printf("\n");
        }
    }

    printf("--\n");


    // print elements in this sequence 0 16 32 48 64 80 96 112 128 144 160 176 192 208 224 240
    // next sequence 1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241
    for (int i = 0; i < 16; i++) {
        for (int j = 0; j < 16; j++) {
            printf("%02x ", magic[i + j * 16]);
        }
        printf("\n");
    }
    
    fclose(file);
}