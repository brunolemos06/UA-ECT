#include <iostream>
#include <stdio.h>
#include "codec_golomb.h"

using namespace std;

int main(int argc, char** argv ){
    if(argc < 4){
        cerr << "Usage: ./golomb_codec_tests  encode <fileIn.wav> <encodedOut.txt> [-lossy n_bits_to_cut[1,15] (def:lossless)]\n";
        cerr << "                                                                  [-order [2,3] (def:3)]\n";
        cerr << "                                (update m every x samples) (X>0)  [-x (def:2000)]\n"; 
        cerr << "                    (calculate medium of y samples) (x >= y > 0)  [-y (def:1750)]\n";
        cerr << "Usage: ./golomb_codec_tests  decode <encodedIn.txt> <decodedOut.wav>\n";
        return -1;
    }

    if(string(argv[1]) == "encode"){
        int lossless = 1;
        int n_bits_to_cut = 0;
        for(int n = 1 ; n < argc ; n++)
            if(string(argv[n]) == "-lossy") {
                lossless = 0;
                //read the number of bits to cut
                n_bits_to_cut = atoi(argv[n+1]);
                if(n_bits_to_cut < 1 || n_bits_to_cut > 15){
                    cerr << "Error: invalid number of bits to cut\n";
                    return -1;
                }
                break;
            }

        int order = 3;
        for(int n = 1 ; n < argc ; n++) 
            if(string(argv[n]) == "-order") {
                order = atoi(argv[n+1]);
                if(order < 2 || order > 3){
                    cerr << "Error: invalid order\n";
                    return -1;
                }
                break;
            }

        int x = 2000;
        for(int n = 1 ; n < argc ; n++) 
            if(string(argv[n]) == "-x") {
                x = atoi(argv[n+1]);
                if(x < 1){
                    cerr << "Error: invalid x\n";
                    return -1;
                }
                break;
            }

        int y = 1750;
        for(int n = 1 ; n < argc ; n++) 
            if(string(argv[n]) == "-y") {
                y = atoi(argv[n+1]);
                if(y < 1 || y >= x){
                    cerr << "Error: invalid y\n";
                    return -1;
                }
                break;
            }

        //create codec to encode
        golomb_codec encode(order, x, y, lossless, n_bits_to_cut);
        cout << "Creating new codec to encoding file " << argv[2] << " to file " << argv[3] << endl;
        encode.encode_wav_file(argv[2], argv[3]);
    }
    else if(string(argv[1]) == "decode"){
        //create codec to decode
        golomb_codec decode = golomb_codec();
        cout << "\nCreating new codec to decode file " << argv[2] << " to file " << argv[3] << endl;
        decode.decode_to_wav(argv[2], argv[3]);
    }
    else{
        cerr << "Error: invalid command\n";
        return -1;
    }
}