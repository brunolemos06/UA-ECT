#ifndef CODEC_GOLOMB_H
#define CODEC_GOLOMB_H

#include <bitset>
#include <stdio.h>
#include <stdlib.h>
#include <bits/stdc++.h>
#include <fstream>
#include <sndfile.hh>
#include <math.h>
#include <iostream>

#include <opencv2/opencv.hpp>
#include "golomb.h"

using namespace std;
using namespace cv;

int prints = 0;

class image_codec{
    private:
        int mode;
        uint32_t period;
        uint8_t quantization;

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
                cout << "ERROR: Wrong mode" << endl;
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
        image_codec(int n_mode, uint32_t n_period,uint8_t n_quantization){
            mode = n_mode;
            period = n_period;
            quantization = n_quantization;
        }

        image_codec(){
            mode = 8;
            period = 100;
            quantization = 0;
        }

        image_codec(int n_mode, uint32_t n_period){
            mode = n_mode;
            period = n_period;
            quantization = 0;
        } 

        //  Function to encode a frame, returns the string with the encoded frame data
        string YUV420_encode_video_frame(Mat image){
            if (!image.data){
                printf("No image data");
                return "";
            }

            int prediction;         //int to store the prediction
            string encoded = "";    //string to store the encoded frame

            //store the values to encode of the image    
            vector<uint32_t> image_values;

            //store the first column for Y channel
            for(int i = 0; i<image.rows; i++){
                image_values.push_back(image.at<Vec3b>(i,0)[0] * 2);   //this way we store the original values for first row
            }
            
            //store the first row for Y channel
            for(int i = 1; i<image.cols; i++){
                image_values.push_back(image.at<Vec3b>(0,i)[0] * 2);   //this way we store the original values for first column
            }

            //process Y channel for all pixels
            for(int i = 1; i < image.rows; i++){
                for(int j = 1; j < image.cols; j++){
                    prediction = (image.at<Vec3b>(i,j)[0] - calculate_prediction(mode, image.at<Vec3b>(i,j-1)[0], image.at<Vec3b>(i-1,j)[0], image.at<Vec3b>(i-1,j-1)[0])) >> quantization;    //calculate prediction
                    image.at<Vec3b>(i,j)[0] = (prediction << quantization) + calculate_prediction(mode, image.at<Vec3b>(i,j-1)[0], image.at<Vec3b>(i-1,j)[0], image.at<Vec3b>(i-1,j-1)[0]);    //replace the value with loss value
                    if(prediction < 0){
                        image_values.push_back((prediction * -2) + 1);  //map negative values to positive odd numbers
                    } else {
                        image_values.push_back(prediction * 2);         //map positive values to positive even numbers
                    }
                }
            }

            //store the first column for Cb and Cr channels
            for(int i = 0; i<image.rows; i+=2){
                image_values.push_back(image.at<Vec3b>(i,0)[1] * 2);   //this way we store the original values for first row
                image_values.push_back(image.at<Vec3b>(i,0)[2] * 2);   //this way we store the original values for first row
            }

            //store the first row for Cb and Cr channels
            for(int i = 2; i<image.cols; i+=2){ 
                image_values.push_back(image.at<Vec3b>(0,i)[1] * 2);   //this way we store the original values for first column
                image_values.push_back(image.at<Vec3b>(0,i)[2] * 2);   //this way we store the original values for first column
            }

            //process Cb and Cr channels for all pixels  cause -> number values of Cb = number of values of Cr
            for(int i = 2; i < image.rows; i+=2){
                for(int j = 2; j < image.cols; j+=2){
                    prediction = (image.at<Vec3b>(i,j)[1] - calculate_prediction(mode, image.at<Vec3b>(i,j-2)[1], image.at<Vec3b>(i-2,j)[1], image.at<Vec3b>(i-2,j-2)[1])) >> quantization;    //calculate prediction
                    image.at<Vec3b>(i,j)[1] = (prediction << quantization) + calculate_prediction(mode, image.at<Vec3b>(i,j-2)[1], image.at<Vec3b>(i-2,j)[1], image.at<Vec3b>(i-2,j-2)[1]);    //replace the value with loss value
                    if(prediction < 0){
                        image_values.push_back((prediction * -2) + 1);  //map negative values to positive odd numbers
                    } else {
                        image_values.push_back(prediction * 2);         //map positive values to positive even numbers
                    }

                    prediction = (image.at<Vec3b>(i,j)[2] - calculate_prediction(mode, image.at<Vec3b>(i,j-2)[2], image.at<Vec3b>(i-2,j)[2], image.at<Vec3b>(i-2,j-2)[2])) >> quantization;    //calculate prediction
                    image.at<Vec3b>(i,j)[2] = (prediction << quantization) + calculate_prediction(mode, image.at<Vec3b>(i,j-2)[2], image.at<Vec3b>(i-2,j)[2], image.at<Vec3b>(i-2,j-2)[2]);    //replace the value with loss value
                    if(prediction < 0){
                        image_values.push_back((prediction * -2) + 1);  //map negative values to positive odd numbers
                    } else {
                        image_values.push_back(prediction * 2);         //map positive values to positive even numbers
                    }
                }
            }

            golomb codec_alg;   //init codec_alg with golomb constructor
            codec_alg.change_m_encode(10);  //set m to 10

            //encode image_values
            for(uint32_t i = 0; i < image_values.size(); i++){
                encoded += codec_alg.encode_number(image_values[i], 0);
                if(i % period == 0){
                    double avg = 0;
                    for(uint32_t j = i - period; j < i; j++){
                        avg += image_values[j];
                    }
                    codec_alg.change_m_encode(calc_m(avg/period));
                }
                
            }   

            return encoded;
        }

        char* YUV420_decode_video_frame(char* p, Mat *ptr, uint32_t rows, uint32_t cols){

            long * tmp_val = (long*)malloc(sizeof(long));    //pointer to store decoded number

            //init codec_alg with golomb constructor
            golomb codec_alg;
            codec_alg.change_m_decode(10);
            
            //vector to store mapped values
            vector<uint32_t> mapped_values;
            //int to count number of mapped values
            uint32_t count = 0;

            Mat newImage = Mat(rows, cols, CV_8UC3);  //create new image with same size as original image

            //decode channel Y
            //decode first column
            for(uint32_t i = 0; i < rows; i++){
                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector
                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;

                newImage.at<Vec3b>(i,0)[0] = (*tmp_val/2);      //store decoded value in image
            }
            //decode first row
            for(uint32_t i = 1; i < cols; i++){
                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector
                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;

                newImage.at<Vec3b>(0,i)[0] = (*tmp_val/2);      //store decoded value in image
            }

            //decode remaining values
            for(uint32_t i = 1; i < rows; i++){
                for(uint32_t j = 1; j < cols; j++){
                    p = codec_alg.decode_string(p, tmp_val, 0);
                    mapped_values.push_back(*tmp_val);         //store mapped value in vector   
                    if(*tmp_val % 2 == 0){
                        *tmp_val = *tmp_val/2;
                    }else{
                        *tmp_val = (*tmp_val-1)/-2;
                    }
                    *tmp_val = *tmp_val << quantization;        //undo quantization
                    //calculate new m
                    if(count % period == 0){
                        double avg = 0;
                        for(uint32_t j = count - period; j < count; j++){
                            avg += mapped_values[j];
                        }
                        codec_alg.change_m_decode(calc_m(avg/period));
                    }
                    count++;

                    newImage.at<Vec3b>(i,j)[0] = *tmp_val + calculate_prediction(mode, newImage.at<Vec3b>(i,j-1)[0], newImage.at<Vec3b>(i-1,j)[0], newImage.at<Vec3b>(i-1,j-1)[0]);    //store decoded value in image
                }
            }

            //decode channel Cb and Cr
            //decode first columns of both channels
            for(uint32_t i = 0; i<rows; i+=2){
                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector

                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;
                
                newImage.at<Vec3b>(i,0)[1] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(i+1,0)[1] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(i,1)[1] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(i+1,1)[1] = (*tmp_val/2);      //store decoded value in image

                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector

                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;

                newImage.at<Vec3b>(i,0)[2] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(i+1,0)[2] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(i,1)[2] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(i+1,1)[2] = (*tmp_val/2);      //store decoded value in image
            }

            //decode first rows of both channels
            for(uint32_t i=2; i<cols; i+=2){
                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector

                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;

                newImage.at<Vec3b>(0,i)[1] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(0,i+1)[1] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(1,i)[1] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(1,i+1)[1] = (*tmp_val/2);      //store decoded value in image

                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector

                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;

                newImage.at<Vec3b>(0,i)[2] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(0,i+1)[2] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(1,i)[2] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(1,i+1)[2] = (*tmp_val/2);      //store decoded value in image
            }

            //decode remaining values
            for(uint32_t i = 2; i < rows; i+=2){
                for(uint32_t j = 2; j < cols; j+=2){
                    for(uint8_t n = 1; n<3; n++){
                        p = codec_alg.decode_string(p, tmp_val, 0);
                        mapped_values.push_back(*tmp_val);         //store mapped value in vector  

                        if(*tmp_val % 2 == 0){
                            *tmp_val = (*tmp_val/2);                //undo mapping
                        }else{
                            *tmp_val = ((*tmp_val-1)/-2);           //undo mapping
                        }
                        *tmp_val = *tmp_val << quantization;        //undo quantization

                        //calculate new m
                        if(count % period == 0){
                            double avg = 0;
                            for(uint32_t k = count - period; k < count; k++){
                                avg += mapped_values[k];
                            }
                            codec_alg.change_m_decode(calc_m(avg/period));
                        }
                        count++;

                        newImage.at<Vec3b>(i,j)[n] = (*tmp_val) + calculate_prediction(mode, newImage.at<Vec3b>(i,j-2)[n], newImage.at<Vec3b>(i-2,j)[n], newImage.at<Vec3b>(i-2,j-2)[n]);     //store decoded value in image
                        newImage.at<Vec3b>(i,j+1)[n] = (*tmp_val) + calculate_prediction(mode, newImage.at<Vec3b>(i,j-2)[n], newImage.at<Vec3b>(i-2,j)[n], newImage.at<Vec3b>(i-2,j-2)[n]);     //store decoded value in image
                        newImage.at<Vec3b>(i+1,j)[n] = (*tmp_val) + calculate_prediction(mode, newImage.at<Vec3b>(i,j-2)[n], newImage.at<Vec3b>(i-2,j)[n], newImage.at<Vec3b>(i-2,j-2)[n]);     //store decoded value in image
                        newImage.at<Vec3b>(i+1,j+1)[n] = (*tmp_val) + calculate_prediction(mode, newImage.at<Vec3b>(i,j-2)[n], newImage.at<Vec3b>(i-2,j)[n], newImage.at<Vec3b>(i-2,j-2)[n]);     //store decoded value in image
        
                    }
                }
            }

            *ptr = newImage;
            return p;
        }

        //YUV422
        string YUV422_encode_video_frane(Mat image){
            if (!image.data){
                printf("No image data");
                return "";
            }

            int prediction;         //int to store the prediction
            string encoded = "";    //string to store the encoded frame

            //store the values to encode of the image    
            vector<uint32_t> image_values;

            //store the first column for Y channel
            for(int i = 0; i<image.rows; i++){
                image_values.push_back(image.at<Vec3b>(i,0)[0] * 2);   //this way we store the original values for first row
            }
            
            //store the first row for Y channel
            for(int i = 1; i<image.cols; i++){
                image_values.push_back(image.at<Vec3b>(0,i)[0] * 2);   //this way we store the original values for first column
            }

            //process Y channel for all pixels
            for(int i = 1; i < image.rows; i++){
                for(int j = 1; j < image.cols; j++){
                    prediction = (image.at<Vec3b>(i,j)[0] - calculate_prediction(mode, image.at<Vec3b>(i,j-1)[0], image.at<Vec3b>(i-1,j)[0], image.at<Vec3b>(i-1,j-1)[0])) >> quantization;     //calculate prediction
                    image.at<Vec3b>(i,j)[0] = (prediction << quantization) + calculate_prediction(mode, image.at<Vec3b>(i,j-1)[0], image.at<Vec3b>(i-1,j)[0], image.at<Vec3b>(i-1,j-1)[0]);     //replace the value with loss value
                    if(prediction < 0){
                        image_values.push_back((prediction * -2) + 1);  //map negative values to positive odd numbers
                    } else {
                        image_values.push_back(prediction * 2);         //map positive values to positive even numbers
                    }
                }
            }

            //store the first column for Cb and Cr channel (2 consecutive pixels)
            for(int i = 0; i<image.rows; i++){
                image_values.push_back(image.at<Vec3b>(i,0)[1] * 2);   //this way we store the original values for first row
                image_values.push_back(image.at<Vec3b>(i,0)[2] * 2);   //this way we store the original values for first row
            }

            //store the first row for Cb and Cr channel (2 consecutive pixels)
            for(int i = 2; i<image.cols; i+=2){
                image_values.push_back(image.at<Vec3b>(0,i)[1] * 2);   //this way we store the original values for first column
                image_values.push_back(image.at<Vec3b>(0,i)[2] * 2);   //this way we store the original values for first column
            }

            //process Cb and Cr channel for all pixels (2 consecutive pixels)
            for(int i = 1; i < image.rows; i++){
                for(int j = 2; j < image.cols; j+=2){
                    prediction = (image.at<Vec3b>(i,j)[1] - calculate_prediction(mode, image.at<Vec3b>(i,j-2)[1], image.at<Vec3b>(i-1,j)[1], image.at<Vec3b>(i-1,j-2)[1])) >> quantization;     //calculate prediction
                    image.at<Vec3b>(i,j)[1] = (prediction << quantization) + calculate_prediction(mode, image.at<Vec3b>(i,j-2)[1], image.at<Vec3b>(i-1,j)[1], image.at<Vec3b>(i-1,j-2)[1]);     //replace the value with loss value
                    if(prediction < 0){
                        image_values.push_back((prediction * -2) + 1);  //map negative values to positive odd numbers
                    } else {
                        image_values.push_back(prediction * 2);         //map positive values to positive even numbers
                    }

                    prediction = (image.at<Vec3b>(i,j)[2] - calculate_prediction(mode, image.at<Vec3b>(i,j-2)[2], image.at<Vec3b>(i-1,j)[2], image.at<Vec3b>(i-1,j-2)[2])) >> quantization;    //calculate prediction
                    image.at<Vec3b>(i,j)[2] = (prediction << quantization) + calculate_prediction(mode, image.at<Vec3b>(i,j-2)[2], image.at<Vec3b>(i-1,j)[2], image.at<Vec3b>(i-1,j-2)[2]);    //replace the value with loss value
                    if(prediction < 0){
                        image_values.push_back((prediction * -2) + 1);  //map negative values to positive odd numbers
                    } else {
                        image_values.push_back(prediction * 2);         //map positive values to positive even numbers
                    }
                }
            }

            golomb codec_alg;   //init codec_alg with golomb constructor
            codec_alg.change_m_encode(10);  //set m to 10

            //encode image_values
            for(uint32_t i = 0; i < image_values.size(); i++){
                encoded += codec_alg.encode_number(image_values[i], 0);
                if(i % period == 0){
                    double avg = 0;
                    for(uint32_t j = i - period; j < i; j++){
                        avg += image_values[j];
                    }
                    
                    codec_alg.change_m_encode(calc_m(avg/period));
                }
                
            }

            return encoded;
        }

        char* YUV422_decode_video_frame(char* p, Mat *ptr, uint32_t rows, uint32_t cols){
            long * tmp_val = (long*)malloc(sizeof(long));    //pointer to store decoded number

            //init codec_alg with golomb constructor
            golomb codec_alg;
            codec_alg.change_m_decode(10);
            
            //vector to store mapped values
            vector<uint32_t> mapped_values;
            //int to count number of mapped values
            uint32_t count = 0;

            Mat newImage = Mat(rows, cols, CV_8UC3);  //create new image with same size as original image

            //decode channel Y
            //decode first column
            for(uint32_t i = 0; i < rows; i++){
                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector
                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;
                newImage.at<Vec3b>(i,0)[0] = (*tmp_val/2);      //store decoded value in image
            }
            //decode first row
            for(uint32_t i = 1; i < cols; i++){
                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector
                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;

                newImage.at<Vec3b>(0,i)[0] = (*tmp_val/2);      //store decoded value in image
            }

            //decode remaining values
            for(uint32_t i = 1; i < rows; i++){
                for(uint32_t j = 1; j < cols; j++){
                    p = codec_alg.decode_string(p, tmp_val, 0);
                    mapped_values.push_back(*tmp_val);         //store mapped value in vector   
                    if(*tmp_val % 2 == 0){
                        *tmp_val = (*tmp_val/2);
                    }else{
                        *tmp_val = ((*tmp_val-1)/-2);
                    }
                    *tmp_val = *tmp_val << quantization;
                    //calculate new m
                    if(count % period == 0){
                        double avg = 0;
                        for(uint32_t j = count - period; j < count; j++){
                            avg += mapped_values[j];
                        }
                        codec_alg.change_m_decode(calc_m(avg/period));
                    }
                    count++;

                    newImage.at<Vec3b>(i,j)[0] = *tmp_val + calculate_prediction(mode, newImage.at<Vec3b>(i,j-1)[0], newImage.at<Vec3b>(i-1,j)[0], newImage.at<Vec3b>(i-1,j-1)[0]);    //store decoded value in image
                }
            }

            //decode channel Cb and Cr
            //decode first column (read 2 values, 2 consecutive pixels) (i, 0) and (i, 1)
            for(uint32_t i = 0; i < rows; i++){
                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector
                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;

                newImage.at<Vec3b>(i,0)[1] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(i,1)[1] = (*tmp_val/2);      //store decoded value in image

                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector
                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;

                newImage.at<Vec3b>(i,0)[2] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(i,1)[2] = (*tmp_val/2);      //store decoded value in image
            }

            //decode first row (read 2 values, 2 consecutive pixels) (0, i) and (0, i+1)
            for(uint32_t i = 2; i < cols; i+=2){
                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector
                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;

                newImage.at<Vec3b>(0,i)[1] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(0,i+1)[1] = (*tmp_val/2);      //store decoded value in image

                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_values.push_back(*tmp_val);          //store mapped value in vector
                //calculate new m
                if(count % period == 0){
                    double avg = 0;
                    for(uint32_t j = count - period; j < count; j++){
                        avg += mapped_values[j];
                    }
                    codec_alg.change_m_decode(calc_m(avg/period));
                }
                count++;

                newImage.at<Vec3b>(0,i)[2] = (*tmp_val/2);      //store decoded value in image
                newImage.at<Vec3b>(0,i+1)[2] = (*tmp_val/2);      //store decoded value in image
            }

            //decode remaining values (i,j) (i,j+1) first value  channel [1], second value channel [2] 
            for(uint32_t i = 1; i < rows; i++){
                for(uint32_t j = 2; j < cols; j+=2){
                    for(uint8_t n=1; n<3; n++){
                        p = codec_alg.decode_string(p, tmp_val, 0);
                        mapped_values.push_back(*tmp_val);         //store mapped value in vector   
                        if(*tmp_val % 2 == 0){
                            *tmp_val = (*tmp_val/2);
                        }else{
                            *tmp_val = ((*tmp_val-1)/-2);
                        }
                        *tmp_val = *tmp_val << quantization;
                        //calculate new m
                        if(count % period == 0){
                            double avg = 0;
                            for(uint32_t j = count - period; j < count; j++){
                                avg += mapped_values[j];
                            }
                            codec_alg.change_m_decode(calc_m(avg/period));
                        }
                        count++;

                        newImage.at<Vec3b>(i,j)[n] = *tmp_val + calculate_prediction(mode, newImage.at<Vec3b>(i,j-1)[n], newImage.at<Vec3b>(i-1,j)[n], newImage.at<Vec3b>(i-1,j-1)[n]);    //store decoded value in image
                        newImage.at<Vec3b>(i,j+1)[n] = *tmp_val + calculate_prediction(mode, newImage.at<Vec3b>(i,j-1)[n], newImage.at<Vec3b>(i-1,j)[n], newImage.at<Vec3b>(i-1,j-1)[n]);    //store decoded value in image
                    }
                }
            }
          
            *ptr = newImage;
            return p;
        }
            
};

#endif