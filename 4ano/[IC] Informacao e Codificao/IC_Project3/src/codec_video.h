#ifndef CODEC_VIDEO_H
#define CODEC_VIDEO_H

#include <fstream>
#include <string>
#include <bitset>
#include <bits/stdc++.h>
#include <opencv2/opencv.hpp>


#include "codec_image.h"

using namespace std;

class codec_video{
    private:
        int mode;
        uint32_t period;
        int quantization;

        //  Function to write the encoded data to a file
        int write_bin_to_file(const char* fileOut, string encoded){
            ofstream filew(fileOut,ios::out | ios::binary);
            char buffer = 0;
            int count = 0;
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

        // Function to read YUV420 file to frames
        string YUV420_read(const char* fileIn, uint32_t n_frames, uint32_t height, uint32_t width, Mat* to_store ){
            //open file with fopen
            FILE* input = fopen(fileIn, "r");

            //read first line
            char header[100];
            fgets(header, 100, input);
            //remove trailing newline
            header[strlen(header)-1] = '\0';                           

            //read next line
            char line[100];                          //line to "FRAMES\n"
            for(uint32_t i = 0; i < n_frames; i++){
                //create frame to store
                Mat tmp = Mat::zeros(height, width, CV_8UC3);

                fgets(line, 100, input);                        //read line
                
                //read Y values
                for(uint32_t j = 0; j < height; j++){
                    for(uint32_t k = 0; k < width; k++){
                        char c = fgetc(input);
                        tmp.at<Vec3b>(j,k)[0] = (unsigned int) c;
                    }
                }


                //read U values, 4 pixels per byte
                for(uint32_t j = 0; j < height; j+=2){
                    for(uint32_t k = 0; k < width; k+=2){
                        char c = fgetc(input);
                        tmp.at<Vec3b>(j,k)[1] = (unsigned int) c;
                        tmp.at<Vec3b>(j,k+1)[1] = (unsigned int) c;
                        tmp.at<Vec3b>(j+1,k)[1] = (unsigned int) c;
                        tmp.at<Vec3b>(j+1,k+1)[1] = (unsigned int) c;
                    }
                }

                //read V values, 4 pixels per byte
                for(uint32_t j = 0; j < height; j+=2){
                    for(uint32_t k = 0; k < width; k+=2){
                        char c = fgetc(input);
                        tmp.at<Vec3b>(j,k)[2] = (unsigned int) c;
                        tmp.at<Vec3b>(j,k+1)[2] = (unsigned int) c;
                        tmp.at<Vec3b>(j+1,k)[2] = (unsigned int) c;
                        tmp.at<Vec3b>(j+1,k+1)[2] = (unsigned int) c;
                    }
                }

                //store frame
                to_store[i] = tmp.clone();
                //free(tmp);
                tmp.release();
            }

            fclose(input);
            return header;
        }

        // Function to write YUV420 file to frames
        int YUV420_write(const char* fileOut, uint32_t n_frames, uint32_t height, uint32_t width, Mat* to_write, string header){
            //open file with fopen
            FILE* output = fopen(fileOut, "w");

            //write header
            fprintf(output, "%s", header.c_str());

            fprintf(output, "\n");
            //write frames
            for(uint32_t i = 0; i < n_frames; i++){
                //write FRAME\n
                fprintf(output, "FRAME\n");

                //write Y values
                for(uint32_t j = 0; j < height; j++){
                    for(uint32_t k = 0; k < width; k++){
                        fputc(to_write[i].at<Vec3b>(j,k)[0], output);
                    }
                }

                //write U values, 4 pixels per byte
                for(uint32_t j = 0; j < height; j+=2){
                    for(uint32_t k = 0; k < width; k+=2){
                        fputc(to_write[i].at<Vec3b>(j,k)[1], output);
                    }
                }

                //write V values, 4 pixels per byte
                for(uint32_t j = 0; j < height; j+=2){
                    for(uint32_t k = 0; k < width; k+=2){
                        fputc(to_write[i].at<Vec3b>(j,k)[2], output);
                    }
                }
            }

            fclose(output);
            return 0;
        }

        // Function to read YUV422 file to frames
        string YUV422_read(const char* fileIn, uint32_t n_frames, uint32_t height, uint32_t width, Mat* to_store ){
            //open file with fopen
            FILE* input = fopen(fileIn, "r");

            //read first line
            char header[100];
            fgets(header, 100, input);
            //remove trailing newline
            header[strlen(header)-1] = '\0';                           

            //read next line
            char line[100];                          //line to "FRAMES\n"
            for(uint32_t i = 0; i < n_frames; i++){
                //create frame to store
                Mat tmp = Mat::zeros(height, width, CV_8UC3);

                fgets(line, 100, input);                        //read line
                
                //read Y values
                for(uint32_t j = 0; j < height; j++){
                    for(uint32_t k = 0; k < width; k++){
                        char c = fgetc(input);
                        tmp.at<Vec3b>(j,k)[0] = (unsigned int) c;
                    }
                }

                //read U values 
                for(uint32_t j = 0; j < height; j++){
                    for(uint32_t k = 0; k < width; k+=2){
                        char c = fgetc(input);
                        tmp.at<Vec3b>(j,k)[1] = (unsigned int) c;
                        tmp.at<Vec3b>(j,k+1)[1] = (unsigned int) c;
                    }
                }

                //read V values
                for(uint32_t j = 0; j < height; j++){
                    for(uint32_t k = 0; k < width; k+=2){
                        char c = fgetc(input);
                        tmp.at<Vec3b>(j,k)[2] = (unsigned int) c;
                        tmp.at<Vec3b>(j,k+1)[2] = (unsigned int) c;
                    }
                }

                //store frame
                to_store[i] = tmp.clone();
                //free(tmp);
                tmp.release();

                //break;
            }

            fclose(input);
            return header;
        }

        // Function to write YUV422 file to frames
        int YUV422_write(const char* fileOut, uint32_t n_frames, uint32_t height, uint32_t width, Mat* to_write, string header){
            //open file with fopen
            FILE* output = fopen(fileOut, "w");

            //write header
            fprintf(output, "%s", header.c_str());

            fprintf(output, "\n");
            //write frames
            for(uint32_t i = 0; i < n_frames; i++){
                //write FRAME\n
                fprintf(output, "FRAME\n");

                //write Y values
                for(uint32_t j = 0; j < height; j++){
                    for(uint32_t k = 0; k < width; k++){
                        fputc(to_write[i].at<Vec3b>(j,k)[0], output);
                    }
                }

                //write U values, 2 pixels per byte
                for(uint32_t j = 0; j < height; j++){
                    for(uint32_t k = 0; k < width; k+=2){
                        fputc(to_write[i].at<Vec3b>(j,k)[1], output);
                    }
                }

                //write V values, 2 pixels per byte
                for(uint32_t j = 0; j < height; j++){
                    for(uint32_t k = 0; k < width; k+=2){
                        fputc(to_write[i].at<Vec3b>(j,k)[2], output);
                    }
                }
            }

            fclose(output);
            return 0;
        }

    public:
        codec_video(int mode, uint32_t p,uint8_t quantization){
            this->mode = mode;
            this->period = p;
            this->quantization = quantization;
        }

        codec_video(){
            this->mode = 8;
            this->period = 100;
            this->quantization = 0;
        }

        codec_video(int mode, uint32_t p){
            this->mode = mode;
            this->period = p;
            this->quantization = 0;
        }

        //  Function to encode a video file
        int encode_video(const char* fileIn, const char* fileOut, string yuv_format){
            
            clock_t time_req;                           //for time measurement
            time_req = clock();                         //start time measurement
            
            VideoCapture cap(fileIn);   //read video

            //check if video is opened
            if(!cap.isOpened()){
                cout << "Error opening video stream or file" << endl;
                return -1;
            }

            //get video info
            uint32_t width = cap.get(CAP_PROP_FRAME_WIDTH);
            uint32_t height = cap.get(CAP_PROP_FRAME_HEIGHT);
            uint32_t frames = cap.get(CAP_PROP_FRAME_COUNT);
            //close    
            cap.release();

            //create image codec
            image_codec encoder(this->mode, this->period,this->quantization);
        
            string encoded=""; //string to store encoded data

            //print header info
            cout << "Video info: " << endl;
            cout << "\tWidth: " << width << endl;
            cout << "\tHeight: " << height << endl;
            cout << "\tFrames: " << frames << endl;
            cout << "\tPeriod: " << this->period << endl;
            cout << "\tMode: " << this->mode << endl;
            cout << "\tQuantization: " << this->quantization << endl;
            cout << "\tYUV format: " << yuv_format << endl;

            //alloc space for frames
            Mat* to_store = new Mat[frames];

            //create header of encoded file to store video info
            //width 32 bits, height 32 bits, frames 32 bits, period 32 bits, mode 4 bits, quantization 8 bits, yuv_format 3 bytes(420,422), header size 16 bits, header n bytes
            encoded += bitset<32>(width).to_string();
            encoded += bitset<32>(height).to_string();
            encoded += bitset<32>(frames).to_string();
            encoded += bitset<32>(this->period).to_string();
            encoded += bitset<4>(this->mode).to_string();
            encoded += bitset<8>(this->quantization).to_string();
            
            string header = "";     //string to store header
            if(yuv_format=="YUV420"){
                header = YUV420_read(fileIn, frames, height, width, to_store);  //read YUV420 file
                encoded += bitset<8>('4').to_string();
                encoded += bitset<8>('2').to_string();
                encoded += bitset<8>('0').to_string();
            }else if(yuv_format=="YUV422"){
                header = YUV422_read(fileIn, frames, height, width, to_store);  //read YUV422 file
                encoded += bitset<8>('4').to_string();
                encoded += bitset<8>('2').to_string();
                encoded += bitset<8>('2').to_string();
            }else{
                cout << "Error: YUV format not supported" << endl;
                return -1;
            }

            encoded += bitset<16>(header.size()).to_string();
            for(uint32_t i = 0; i < header.size(); i++){
                encoded += bitset<8>(header[i]).to_string();
            }

            cout << "\tHeader size: " << header.size() << endl;
            cout << "\tHeader: " << header << endl;   

            if(yuv_format=="YUV420"){
                cout << "\nEncoding YUV420 video..." << endl;
                //encode each frame
                for(uint32_t i = 0; i < frames; i++){
                    //encode frame
                    encoded += encoder.YUV420_encode_video_frame(to_store[i]);


                    //if(i==150) { cvtColor(to_store[i], to_store[i], COLOR_YUV2BGR); imwrite("422_encoded_frame" + to_string(i) + ".ppm", to_store[i]); }
                    //break;
                }
            }else if(yuv_format=="YUV422"){
                cout << "\nEncoding YUV422 video..." << endl;
                for(uint32_t i = 0; i < frames; i++){
                    //encode frame
                    encoded += encoder.YUV422_encode_video_frane(to_store[i]);

                    //if(i==0) { cvtColor(to_store[i], to_store[i], COLOR_YUV2BGR); imwrite("422_encoded_frame" + to_string(i) + ".ppm", to_store[i]); }
                    //break;
                }
            }else{
                cout << "Error: YUV format not supported" << endl;
                return -1;
            }

            //write encoded data to file
            write_bin_to_file(fileOut, encoded);
            
            //print execution time
            time_req = clock() - time_req;
            cout << "Execution time: " << (float)time_req/CLOCKS_PER_SEC << " seconds" << endl;
            //compare size of original and encoded file
            ifstream file1(fileIn, ios::binary | ios::ate);
            ifstream file2(fileOut, ios::binary | ios::ate);
            cout << "Original file size: " << file1.tellg() << " bytes" << endl;
            cout << "Encoded file size: " << file2.tellg() << " bytes" << endl;
            //compression ratio
            cout << "Compression ratio: " << (float)file1.tellg()/(float)file2.tellg() << endl;
            file1.close();
            file2.close();

            return 0;
        }

        //  Function to decode a video file
        int decode_video(const char* fileIn, const char* fileOut){
            clock_t time_req;                           //for time measurement
            time_req = clock();                         //start time measurement

            //read encoded data from file
            string encoded = read_bin_from_file(fileIn);

            //get video info from header
            //width 32 bits, height 32 bits, frames 32 bits, period 32 bits, mode 4 bits, quantization 8 bits, yuv_format 3 bytes(420,422), header size 16 bits, header n bytes
            uint32_t width = bitset<32>(encoded.substr(0,32)).to_ulong();
            uint32_t height = bitset<32>(encoded.substr(32,32)).to_ulong();
            uint32_t frames = bitset<32>(encoded.substr(64,32)).to_ulong();
            this->period = bitset<32>(encoded.substr(96,32)).to_ulong();
            this->mode = bitset<4>(encoded.substr(128,4)).to_ulong();
            this->quantization = bitset<8>(encoded.substr(132,8)).to_ulong();
            
            string yuv_format = "YUV";
            string yuv_bin = encoded.substr(140,24);
            for(uint8_t i = 0; i < 3; i++){
                yuv_format += (char)bitset<8>(yuv_bin.substr(i*8,8)).to_ulong();
            }
            
            uint16_t header_size = bitset<16>(encoded.substr(164,16)).to_ulong();

            string header_bin = encoded.substr(180,header_size*8);
            string header = "";
            for(uint16_t i = 0; i < header_size; i++){
                header += (char)bitset<8>(header_bin.substr(i*8,8)).to_ulong();
            }

            encoded = encoded.substr(180+header_size*8);    //remove header from encoded string


            //print video info
            cout << "Video info: " << endl;
            cout << "\tWidth: " << width << endl;
            cout << "\tHeight: " << height << endl;
            cout << "\tFrames: " << frames << endl;
            cout << "\tP: " << this->period << endl;
            cout << "\tMode: " << this->mode << endl;
            cout << "\tQuantization: " << this->quantization << endl;
            cout << "\tYUV format: " << yuv_format << endl;
            cout << "\tHeader size: " << header_size << endl;
            cout << "\tHeader: " << header << endl;

            char* encoded_ptr = &encoded[0];    //pointer encoded string  

            //create image codec
            image_codec codec_img(this->mode, this->period, this->quantization);      

            Mat* to_write = new Mat[frames];         //array of frames to write to video
            Mat* decoded_frame = new Mat(height, width, CV_8UC3); //pointer to decoded frame

            if(yuv_format=="YUV420"){
                //decode video
                for (uint32_t i = 0; i < frames; i++){
                    encoded_ptr = codec_img.YUV420_decode_video_frame(encoded_ptr, decoded_frame, height, width);
                    to_write[i] = *decoded_frame;

                    //cout << "Frame " << i << " decoded" << endl;

                    //if(i==150) { cvtColor(*decoded_frame, *decoded_frame, COLOR_YUV2BGR); imwrite("420_decoded_frame" + to_string(i) + ".ppm", *decoded_frame); }
                    //break;
                }
                //write decoded video to file
                if(YUV420_write(fileOut, frames, height, width, to_write, header)!=0){
                    cout << "Error writing video" << endl;
                    return -1;
                }
            }else if(yuv_format=="YUV422"){
                //decode video
                for (uint32_t i = 0; i < frames; i++){
                    encoded_ptr = codec_img.YUV422_decode_video_frame(encoded_ptr, decoded_frame, height, width);
                    to_write[i] = *decoded_frame;

                    //cout << "Frame " << i << " decoded" << endl;

                    //if(i==0) { cvtColor(*decoded_frame, *decoded_frame, COLOR_YUV2BGR); imwrite("422_decoded_frame" + to_string(i) + ".ppm", *decoded_frame); }
                    //break;
                }
                //write decoded video to file
                if(YUV422_write(fileOut, frames, height, width, to_write, header)!=0){
                    cout << "Error writing video" << endl;
                    return -1;
                }
            }else{
                cout << "Error: YUV format not supported" << endl;
                return -1;
            }

            time_req = clock() - time_req;
            cout << "Execution time: " << (float)time_req/CLOCKS_PER_SEC << " seconds" << endl;

            return 0;
        }
};

#endif