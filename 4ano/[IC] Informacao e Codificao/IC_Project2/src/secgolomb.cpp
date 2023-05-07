#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include "secgolomb.h"
#include "time.h"


using namespace std;

int main(int argc, char** argv ){    
    time_t start, end;
    time(&start);
    if(argc != 5){
        cout << "Usage: ./secgolomb <encode/decode> <m> <toencode/decoded file> <todecode/encoded file>" << endl;
        return -1;
    }
    int i = 0;
    int m = atoi(argv[2]);
    string towrite;

    secgolomb secgolomb(i,m);
    string arg1 = argv[1];
    if(arg1 == "encode"){
        cout << "Encoding..." << endl;
        //read the values from the file separated by spaces
        FILE *fp = fopen(argv[3], "r");
        if(fp == NULL){
            cout << "Error opening file" << endl;
            return -1;
        }
        vector<int> values;
        vector<string> encoded;
        vector<string> quocients;

        // read the numbers from the file separated by spaces
        int num;
        while(fscanf(fp, "%d", &num) != EOF){
            quocients.push_back(secgolomb.encode(num,m));
        }
        fclose(fp);
        cout << endl;
        cout << "Writing to file..." << endl;
        //print the encoded values
        for(int i = 0; i < quocients.size(); i++){
            cout << quocients[i]<<endl;
        }

        //write the encoded values to the file
        FILE *fp2 = fopen(argv[4], "w");
        if(fp2 == NULL){
            cout << "Error opening file" << endl;
            return -1;
        }
        for(int i = 0; i < quocients.size(); i++){
            fprintf(fp2, "%s", quocients[i].c_str());
        }
        fclose(fp2);
        cout << endl;
        cout << "Done!" << endl;        
        
    }else if(arg1=="decode"){
        //read the values from the file separated by spaces
        FILE *fp = fopen(argv[4], "r");
        if(fp == NULL){
            cout << "Error opening file" << endl;
            return -1;
        }
        //read just the first string from the file
        char str[100];

        //read the numbers from the file separated by spaces

        vector<string> values;

        while(fscanf(fp, "%s", str) != EOF){
            towrite +=str;
            towrite += " ";
            values.push_back(str);
        }
        fclose(fp);
        cout << "Decoding..." << endl;
        for(int i = 0; i < values.size(); i++){
            values[i] =secgolomb.separator(values[i],m);
        }
        for(int i = 0; i < values.size(); i++){
            cout<<values[i]<<endl;
        }
        cout << endl;
        cout << "Writing to file..." << endl;
        FILE *fp2 = fopen(argv[3], "w");
        if(fp2 == NULL){
            cout << "Error opening file" << endl;
            return -1;
        }
        //write the values[i] to the file
        for(int i = 0; i < values.size(); i++){
            fprintf(fp2, "%s", values[i].c_str());
        }

        fclose(fp2);
        cout << endl;
    }
    
    time(&end);
    double time_taken = double(end - start);
    cout << "Time taken by program is : " << fixed
         << time_taken << setprecision(5);
    cout << " sec " << endl;
    return 0;
}