  #ifndef BITSTREAM_H
  #define BITSTREAM_H

  #include <iostream>
  #include <vector>
  #include <fstream>
  #include <algorithm>
  #include <bits/stdc++.h>
  using namespace std;
  
  class BitStream {
      private:
        fstream file;
        char mode;
        char buffer;
        int count;
  
      public:
        //constructor to initialize file and mode
        BitStream(const char* filename, char mode){
            if (mode == 'z'){
                this->mode = mode;
                file.open(filename, ios::in | ios::out | ios::binary);
            }else if (mode == 'w'){
                this->mode = mode;
                file.open(filename, ios::out | ios::binary);
            }else if (mode == 'r'){
                this->mode = mode;
                file.open(filename, ios::in | ios::binary);
            }else{
                cout << "Invalid mode" << endl;
              }
            buffer = 0;
            count = 0;
          }
          
        
        //Function readbit
        void readbit(){
            //read the content of the file byte by byte until the end of the file
            ofstream filew("decoder.txt",ios::in | ios::binary);
            char c;
            //read only the first byte of the file
            file.read(&c, 1);
            //convert the byte to binary
            string binary = bitset<8>(c).to_string();
            //write only the first bit of the byte
            filew << binary[1];
            //write the byte
            // filew << binary;
            file.close();
        }

        //Function readNbits
        void readNbits(int n){
            //read the content of the file byte by byte until the end of the file
            ofstream filew("decoder.txt",ios::in | ios::binary);
            char c;
            int nbytes = ceil(n/8.0);
            int excess = n%8;
            for (size_t i = 0; i < nbytes; i++){
                file.read(&c, 1);
                string binary = bitset<8>(c).to_string();
                //if the excess is not zero and it is the last byte to be read then read only the excess bits of the byte
                if (excess != 0 && i == nbytes-1){
                    string binary = bitset<8>(c).to_string();
                    for (int j = 0; j < excess; j++){
                        filew << binary[j];
                    }
                }else{
                    string binary = bitset<8>(c).to_string();
                    filew << binary;
                }
            }
        }
        
        void writebit(const char* filename) {
          //read the first char of the file and set the bit with the value of the char
          ifstream filer(filename, ios::in | ios::binary);
          char bit;
          filer.read(&bit, 1);
            buffer <<= 1;
                if (bit == '1') {
                    buffer |= 1;
                  }
                count++;
                if(count == 8) {
                    file.write(&buffer, 1);
                    buffer = 0;
                    count = 0;
                }
        }
        void write_bit(char bit) {
            buffer <<= 1;
                if (bit == '1') {
                    buffer |= 1;
                  }
                count++;
                if(count == 8) {
                    file.write(&buffer, 1);
                    buffer = 0;
                    count = 0;
                }
        }
        //Function Encoder to N bits
        void writeNbits(const char* filename,int n) {
            ofstream filew(filename, ios::out | ios::binary);
            vector<char> bits;
            char bit;
            //read the file and store the bits in a vector but in reverse order
            while (file >> bit){
                bits.push_back(bit);
              }

            file.close(); 

            //get the & of the bits and the buffer
            for (int i = 0; i < bits.size(); i++){
                buffer <<= 1;
                if (bits[i] == '1') {
                    buffer |= 1;
                }
                count++;
                if(count == n) {
                    //print the buffer
                    //cout << "BUFFER VAL: "<< buffer << endl;
                    filew.write(&buffer, 1);
                    buffer = 0;
                    count = 0;
                  }
            }
            filew.close();

        }
        //Function Decoder
        void decoder(const char* filename){
            //read the content of the file byte by byte until the end of the file
            ofstream filew(filename,ios::out | ios::binary);
            char c;
            //read the bits that are stored in the file
            while (file.get(c)){
                //convert the char to int
                int x = (int)c;
                string s = bitset<8>(x).to_string();
                filew << s;
            }
            file.close();
        }

        //Function Encoder
        void encoder(const char* filename, int n){
            writeNbits(filename, n);
            flushl();
        }

        //function to flush the buffer
        void flushl() {
            if (mode == 'w'){
                if(count == 0) {
                    return;
                }
              file.write(&buffer, 1);
              buffer=0;
              count=0;
              }
          }
        //function to to flush the buffer filling it with zeros
        void flushr() {
            if (mode == 'w'){
                while(count != 0) {
                   write_bit('0');
                  }
              }
          }
    };
    #endif