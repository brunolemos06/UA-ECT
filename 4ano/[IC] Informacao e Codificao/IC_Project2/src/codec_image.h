#ifndef CODEC_GOLOMB_H
#define CODEC_GOLOMB_H

#include <bitset>
#include <stdio.h>
#include <stdlib.h>
#include <bits/stdc++.h>
#include <fstream>
#include <sndfile.hh>


#include <opencv2/opencv.hpp>
#include <iostream>

#include "golomb.h"

using namespace std;
using namespace cv;

constexpr size_t FRAMES_BUFFER_SIZE = 65536; // Buffer for reading/writing frames

uint32_t samples_size = 0;
size_t frames=0;
int format=0, samplerate=0;

class image_codec{
    private:
        golomb codec_alg;
        char buffer = 0;
        int count=0, num_channels=0;
        int x, y, order;
        string encoded;
    

        //  Function to write the encoded data to a file
        int write_bin_to_file(const char* fileOut, string encoded){
            ofstream filew(fileOut,ios::out | ios::binary);
            for (uint32_t i = 0; i < encoded.length(); i++){
                buffer <<= 1;
                if (encoded[i] == '1') {
                    buffer |= 1;
                }
                count++;
                if(count == 8) {
                    //print the buffer
                    //cout << "BUFFER VAL: "<< buffer << endl;
                    filew.write(&buffer, 1);
                    buffer = 0;
                    count = 0;
                }
            }
            //write last buffer
            //if buffer is not empty
            if(count != 0) {
                //write buffer + padding
                buffer <<= (8-count);
                filew.write(&buffer, 1);
                count = 0;
                buffer = 0;
            }
            filew.close();
            return 0;
        }

        //  Function to read the encoded data from a file
        string read_bin_from_file(const char* fileIn){
            //read file
            ifstream filer(fileIn, ios::in | ios::binary);

            //read file
            char c;
            string encoded;
            while(filer.get(c)){
                //cout << "BUFFER VAL: "<< (int)c << endl;
                //convert char to binary
                bitset<8> x(c);
                //cout << "BUFFER VAL: "<< x << endl;
                encoded += x.to_string();
            }
            filer.close();
            return encoded;
        }

        int calculate_prediction(int mode, int a, int b, int c){
            if(mode == 8){
                if (c >= max(a,b)){
                    return min(a,b);
                }else if (c <= min(a,b)){
                    return max(a,b);
                }else{
                    return a+b-c;
                }
            }else if(mode==2){
                //b
                return b;
            }else if(mode==3){
                //c
                return c;
            }else if(mode==4){
                //a+b-c
                return a+b-c;
            }else if(mode==5){
                return a+(b-c)/2;
            }else if(mode==6){
                //b+(a-c)/2
                return b+(a-c)/2;
            }else if(mode==7){
                return (a+b)/2;
            }else if(mode==1){
                //a
                return a;
            }else{
                //error
                cout << "ERROR: Wrong order" << endl;
                // system exit
                exit(0);
            }
        }

        uint32_t calc_m(double avg){
            double alfa = avg / (avg + 1);
            double res = ceil(-1/log2(alfa));
            if (res == 0){
                return 1;
            }
            return res;
        }

    public:
        image_codec(int n_order, int x_in, int y_in): codec_alg() { order = n_order; x = x_in; y = y_in; };        

        int encode_image_file(const char* fileIn, const char* fileOut){
            // init locktable

            int locktable[256];
            for(int i = 0; i < 256; i++){
                locktable[i] = i*2+1;
            } 
            
            clock_t time_req;                           //for time measurement
            time_req = clock();                         //start time measurement
            encoded = "";
            //  declaare char array to store fileIn
            Mat image;
            // size of file fileIn

            image = imread( fileIn , 1 );
                        
            if (!image.data){
                printf("No image data");
                return -1;
            }
            //  Get the image size
            int num_channels = 3;
            unsigned char a[3],b[3],c[3];
            int pred[3];
            Vec<int, 3> aux_finalvalue;
            Vec<unsigned short, 3> finalvalue;
            int m;
            int avg;

            // array with size of image
            int size = image.rows*image.cols*3;
            // cout << size << endl;
            // declare array
            int *arrayimage = new int[size];
            
            vector<int> saveindexOver;
            // for first line and first column
            int index = 0;
            for(int i = 0; i < image.rows; i++){
                for(int j = 0; j < image.cols; j++){
                    for (int k = 0; k < num_channels; k++){
                        if (j == 0 || i == 0){
                            arrayimage[index++] = locktable[image.at<Vec3b>(i,j)[k]];
                        }else{
                            a[k] = image.at<Vec3b>(i,j-1)[k];
                            b[k] = image.at<Vec3b>(i-1,j)[k];
                            c[k] = image.at<Vec3b>(i-1,j-1)[k];

                            pred[k] = calculate_prediction(order, a[k], b[k], c[k]);

                            aux_finalvalue[k] = image.at<Vec3b>(i,j)[k] - pred[k];


                            if(aux_finalvalue[k] < 0){
                                finalvalue[k] = (aux_finalvalue[k] * -2); 
                            } else {
                                finalvalue[k] = locktable[aux_finalvalue[k]]; //i * 2 + 1
                            }

                            arrayimage[index++] = (finalvalue[k]);
                        }
                    }
                }
                // cout << endl;
            }
            // cout all saveindexOver
        

            codec_alg.change_m_encode(4);
            m = codec_alg.get_m_encode();
            encoded += (codec_alg.encode_number(image.rows, 0) +  codec_alg.encode_number(image.cols, 0));


            encoded += codec_alg.encode_number(arrayimage[0],0);
            encoded += codec_alg.encode_number(arrayimage[1],0);
            encoded += codec_alg.encode_number(arrayimage[2],0);
            int med = 0;
            med = arrayimage[0]+arrayimage[1]+arrayimage[2];
            med = med/3;
            m = calc_m(med);
            codec_alg.change_m_encode(m);

            for (int i = 3; i < size; i++){ 
                // cout << "m" <<  m << ":" << arrayimage[i] << endl;
                encoded += codec_alg.encode_number(arrayimage[i],0);
                
                if(i % x == 0){ //every x samples  
                    med = 0;
                    // cout << "i: " << i << endl;
                    for(uint32_t j=i - y; j<i; j++){ //calculate average of last y samples
                        med += arrayimage[j];
                    }
                    m = calc_m(med/x);
                    codec_alg.change_m_encode(m);
                }
                //  40 -> 197
                // 128 -> 0
                // 128 -> 363
                // ...
            }

            write_bin_to_file(fileOut, encoded);
            time_req = clock() - time_req;
            // calculate th avgm    
            // cout << "Image to Encode   : " << fileIn << endl;
            // cout << "Encoded file      : " << fileOut << endl;
            cout << "Colors written     : " << size << endl;
            cout << "Taxa de Compressão : " << (float)encoded.length()/(image.rows*image.cols*3*8) << endl;
            cout << "Execution time     : " << (float)time_req/CLOCKS_PER_SEC << " seconds" << endl;
            return 0;
        }

    int decode_image_file(const char* fileIn, const char* fileOut){
            clock_t time_req;
            time_req = clock();

            //read encoded file
            string encoded = read_bin_from_file(fileIn);
            //pointer to encoded string
            char *p = &encoded[0];
            

            //print encoded size in bytes
            cout << "Encoded size in bytes: " << (double)encoded.size()/8 << endl;
            cout << "Encoded size in Mbytes: " << (double)encoded.size()/8/1024/1024 << endl;

            long * tmp_val = (long*)malloc(sizeof(long));    //pointer to store decoded number
            

            uint32_t i=0;
            unsigned char a,b,c;
            int index = 0;
            long soma=0;
            int m;

            vector<int> Lastvalues;
            
            codec_alg.change_m_decode(4);
            m = codec_alg.get_m_decode();
            int med;

            p = codec_alg.decode_string(p, tmp_val, 0);
            int rows = *tmp_val;
            p = codec_alg.decode_string(p, tmp_val, 0);
            int cols = *tmp_val;
            // cout << "rows: " << rows << " cols: " << cols << endl;



            int saveIndex_position = 0;

            Mat newimage(rows, cols, CV_8UC3, Scalar(0,0,0));

            for(int i = 0; i < rows; i++){
                for(int j = 0; j < cols; j++){
                    for (int k = 0; k < 3; k++){
                        p = codec_alg.decode_string(p, tmp_val, 0);                    
                        //  store tmo_val in array
                        Lastvalues.push_back(*tmp_val);
                        // cout << "tmp_val: " << *tmp_val << endl;

                        if(*tmp_val % 2 == 0){
                            *tmp_val = ( (*tmp_val) / (-2));
                        } else {
                            *tmp_val = ((*tmp_val - 1) / 2);
                        }

                        if (j == 0 || i == 0){ 
                            newimage.at<Vec3b>(i,j)[k] = *tmp_val;
                        }else{
                            a = newimage.at<Vec3b>(i,j-1)[k];
                            b = newimage.at<Vec3b>(i-1,j)[k];
                            c = newimage.at<Vec3b>(i-1,j-1)[k];
                            newimage.at<Vec3b>(i,j)[k] = *tmp_val + calculate_prediction(order, a, b, c);
                        }
                        // cout <<"s" << endl;
                        if(index % x == 0 && index > 2){ //every x samples  
                            med = 0;
                            for(uint32_t h=index - y; h<index; h++){ //calculate average of last y samples
                                med += Lastvalues[h];
                            }
                            m = calc_m(med/x);
                            codec_alg.change_m_decode(m);
                        }else if(index == 2){
                            // calculate avg of first 3 samples
                            med = 0;
                            med = (Lastvalues[0] + Lastvalues[1] + Lastvalues[2])/3;
                            m = calc_m(med);
                            codec_alg.change_m_decode(m);
                        }
                        // cout << "i" << ":"<< index <<"\nm" << m << endl;
                        index++;
                    }
                    // return 0;
                }
            }

            imwrite(fileOut, newimage);
            time_req = clock() - time_req;
            cout << "Execution time    : " << (float)time_req/CLOCKS_PER_SEC << " seconds" << endl;
            return 0;

        }
};

#endif