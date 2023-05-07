#include <iostream>
#include <sndfile.hh>
#include <vector>
#include <cmath>
#include "BitStream.h"
using namespace std;


int main() {
    //test the class BitStream
    BitStream bs("test.txt", 'w');
    //Read 1 bit
    // bs.readbit();

    //Read N bits
    // bs.readNbits(20);

    //Write 1 bit
    // bs.write_bit('0');
    //alternative way to write 1 bit
    //for loop to write 1 bit
    for (int i = 0; i < 8; i++){
        bs.writebit("decoder.txt");
    }

    //Lê os caracters do decoder.txt e escreve os bits lidos no test.txt
    // bs.writeNbits("decoder.txt", 10);


    //Lê os bits do test.txt e escreve os caracteres lidos correspondentes aos bits no decoder.txt
    // bs.decoder();

    //
    bs.encoder("decoder.txt", 8);

    //test the class BitStream
    // -----------------------------------------------
    // |   w1bits   |  wNbits  |  r1bit?  |  rNbits  |
    // -----------------------------------------------
    // |  done      |  done    |  not     |  done    |
    // | tested     |  tested  |  not     |  tested  |
    // -----------------------------------------------
}