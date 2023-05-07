#include <iostream>
#include <stdio.h>
#include "golomb.h"

using namespace std;

int main(int argc, char** argv ){
    if(argc != 5){
        cout << "Usage: ./golomb_code_tests <encode/decode> <m> <toencode/decoded file> <todecode/encoded file>" << endl;
        return -1;
    }
    int m = atoi(argv[2]);


    golomb tmp(m);
    string arg1 = argv[1];
    if(arg1 == "encode"){
        cout << "Encoding..." << endl;
        //read the values from the file separated by spaces
        FILE *fp = fopen(argv[3], "r");
        if(fp == NULL){
            cout << "Error opening file" << endl;
            return -1;
        }
        int value;
        string encoded;
        while(fscanf(fp, "%d", &value) != EOF){
            //cout << value << endl;
            encoded += tmp.encode_number(value, 1);
        } 
        fclose(fp);

        //write the encoded values to the file
        FILE *fp2 = fopen(argv[4], "w");
        if(fp2 == NULL){
            cout << "Error opening file" << endl;
            return -1;
        }
        fprintf(fp2, "%s", encoded.c_str());
        fclose(fp2);
        cout << "Encoding done!" << endl;
    }

    if(arg1 == "decode"){
        cout << "Decoding..." << endl;
        //read the values from the file separated by spaces
        FILE *fp = fopen(argv[3], "r");
        if(fp == NULL){
            cout << "Error opening file" << endl;
            return -1;
        }
        string encoded;
        //read the encoded values from the file
        char c;
        while(fscanf(fp, "%c", &c) != EOF){
            encoded += c;
        }
        long *decoded = (long*) malloc(sizeof(long));
        char *encoded_c = &encoded[0];
        vector<long> decoded_values;
        while(*encoded_c != '\0'){
            encoded_c = tmp.decode_string(encoded_c, decoded, 1);
            //cout << *decoded << endl;
            decoded_values.push_back(*decoded);
        }
        fclose(fp);

        //write the decoded values to the file
        FILE *fp2 = fopen(argv[4], "w");
        if(fp2 == NULL){
            cout << "Error opening file" << endl;
            return -1;
        }
        for(int i = 0; i < decoded_values.size(); i++){
            fprintf(fp2, "%ld ", decoded_values[i]);
        }
        fclose(fp2);
        cout << "Decoding done!" << endl;
    }
    return 0;
}