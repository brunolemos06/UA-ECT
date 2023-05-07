
#include <fstream>
#include <string>
#include <bitset>
#include <bits/stdc++.h>
#include <opencv2/opencv.hpp>
#include "golomb.h"
#include "codec_image.h"
#include "codec_image.h"

using namespace std;

// Function to write YUV420 file to frames
int YUV420_write(const char* fileOut, uint32_t n_frames, uint32_t height, uint32_t width, Mat* to_write, string header){
    //open file with fopen
    FILE* output = fopen(fileOut, "w");
    
    //write header
    fprintf(output, "%s", header.c_str());

    fprintf(output, "\n");
    //write frames
    for(uint32_t i = 0; i < n_frames; i++){
        // cout << "Writing frame n: " << i << endl;
        //write FRAME\n
        fprintf(output, "FRAME\n");

        //write Y values
        for(uint32_t j = 0; j < height; j++){
            for(uint32_t k = 0; k < width; k++){
                // cout << (int)to_write[i].at<Vec3b>(j,k)[0] << endl;
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

uint32_t calc_m(double avg){
    double alfa = avg / (avg + 1);
    double res = ceil(-1/log2(alfa));
    // cout << "M: " << res << endl;
    if (res == 0){
        return 1;
    }
    return res;
}

// Function to write YUV420 file to frames
int write_YUV420_from_frames(const char* fileOut, uint32_t n_frames, uint32_t height, uint32_t width, uint32_t frame_type, Mat* to_write, string header){
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

// Function to read YUV420 file to frames
string read_YUV420_to_frames(const char* fileIn, uint32_t n_frames, uint32_t height, uint32_t width, uint32_t frame_type, Mat* to_store ){
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
        Mat tmp = Mat(height, width, frame_type);   //frame to store
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

        //break;
    }

    fclose(input);
    return header;
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

//main
int main(int argc, char const *argv[]){

    clock_t time_req;                           //for time measurement
    time_req = clock();                         //start time measurement
    
    image_codec decoder(8,100);   

    golomb codec(2);
    codec.change_m_decode(2);
    const char* fileIn = argv[1];               //input file
    const char* fileOut = argv[2];              //output file

    //read encoded data from file
    string encoded = read_bin_from_file(fileIn);
    
    //read header
    uint32_t width = bitset<32>(encoded.substr(0,32)).to_ulong();
    uint32_t height = bitset<32>(encoded.substr(32,32)).to_ulong();
    uint32_t frames = bitset<32>(encoded.substr(64,32)).to_ulong();
    uint16_t header_size = bitset<16>(encoded.substr(96,16)).to_ulong();
    uint16_t keyframe = bitset<16>(encoded.substr(112,16)).to_ulong();
    uint16_t block_size = bitset<16>(encoded.substr(128,16)).to_ulong();

    string header_bin = encoded.substr(144,header_size*8);
    string header = "";

    for(uint16_t i = 0; i < header_size; i++){
        header += (char)bitset<8>(header_bin.substr(i*8,8)).to_ulong();
    }

    encoded = encoded.substr(144+header_size*8);    //remove header from encoded string

    cout << "Width: " << width << endl;
    cout << "Height: " << height << endl;
    cout << "Frames: " << frames << endl;
    cout << "Keyframe: " << keyframe << endl;
    cout << "HeadSize: " << header_size << endl;
    cout << "Block Size: " << block_size << endl;
    cout << "Header: " << header << endl;

    Mat frame_key(height, width, CV_8UC3); //pointer to decoded frame
    
    // Array of Mats to store the frames to write to video file with parameters (height, width, frame_type)
    Mat* to_write = new Mat[frames];        //array of frames to store
    for(uint32_t i = 0; i < frames; i++){
        to_write[i] = Mat(height, width, CV_8UC3);
    }
    
    Mat decoded_frame(height, width, CV_8UC3); //pointer to decoded frame
    Mat decoded_frame2(height, width, CV_8UC3); //pointer to decoded frame
    
    char* encoded_ptr = &encoded[0];    //pointer encoded string  
    //long * tmp_val = (long*)malloc(sizeof(long));    //pointer to store decoded number
    long tmp_val = 0;

    int lastkeyframe = 0;
    int index = 0;
    int index2 = 0;
    int vector_i;
    int vector_j;
    int inter_intra = 0;
    int pixel_a = 0;
    int pixel_b = 0;
    int pixel_c = 0;
    int pixel_d = 0;
    int pixel_e = 0;
    int pixel_f = 0;
    int period = 2500;

    int* frames_n = new int[height*width*3];
    int* vectores = new int[(height/block_size)*(width/block_size)*2];
    cout << "Decoding..." << endl;
    for(uint32_t i_frames = 0; i_frames < frames; i_frames++){
        if (i_frames%keyframe == 0){
            encoded_ptr = decoder.YUV420_decode_video_frame(encoded_ptr, &decoded_frame, height, width);

            to_write[i_frames] = decoded_frame;
            lastkeyframe = i_frames;
            
        }else{
            //decode frame
            //decode motion vectors
            
            codec.change_m_decode(2);
            encoded_ptr = codec.decode_string(encoded_ptr,&tmp_val,1);
            inter_intra = tmp_val;

            if (inter_intra == 1){
                encoded_ptr = decoder.YUV420_decode_video_frame(encoded_ptr, &decoded_frame, height, width);
                to_write[i_frames] = decoded_frame;
            }else{
                index = 0;
                for (int i = 0; i < ((height/block_size)*(width/block_size)*2); i++){
                    index++;

                    encoded_ptr = codec.decode_string(encoded_ptr,&tmp_val,1);
                    vectores[i] = tmp_val;

                    if((index) % period == 0){
                        double avg = 0;
                        for(uint32_t j = index - period; j < index; j++){
                            if (vectores[j] < 0){
                                vectores[j] = vectores[j] * -2;
                            }else{
                                vectores[j] = vectores[j] * 2 + 1;
                            }
                            avg += vectores[j];
                        }
                        if (avg < 0){
                            avg = 1;
                        }

                        codec.change_m_decode(calc_m(avg/period));
                        
                            // cout << "m: " << codec.get_m_encode() << endl;
                    }

                }
                // cout << "HERE" << endl;
                index = 0;
                for (int i = 0; i < height; i += block_size){
                    for (int j = 0; j < width; j += block_size){
                        vector_i = vectores[index];
                        vector_j = vectores[index+1];
                        index +=2;
                        for (int var_i = i; var_i< block_size+i; var_i++){
                            for(int var_j = j; var_j < block_size + j; var_j++){
                                to_write[i_frames].at<Vec3b>(var_i,var_j)[0] = to_write[lastkeyframe].at<Vec3b>(var_i+vector_i,var_j+vector_j)[0];
                                to_write[i_frames].at<Vec3b>(var_i,var_j)[1] = to_write[lastkeyframe].at<Vec3b>(var_i+vector_i,var_j+vector_j)[1];
                                to_write[i_frames].at<Vec3b>(var_i,var_j)[2] = to_write[lastkeyframe].at<Vec3b>(var_i+vector_i,var_j+vector_j)[2];

                            }
                        }
                    }
                }

                index  = 0;
                index2 = 0;
                // cout << "HERE" << endl;
                //  012 345 678 901 234 567 890 123 456 789 012 345 678 901 234 567
                //  111 100 100 100 111 100 100 100 111 100 100 100 111 100 100 100

                for (int i = 0; i < height; i += 2){
                    for (int j = 0; j < width; j += 2){
                        index++;
                        encoded_ptr = codec.decode_string(encoded_ptr, &tmp_val,1);
                        pixel_a = tmp_val;
                        encoded_ptr = codec.decode_string(encoded_ptr, &tmp_val,1);
                        pixel_b = tmp_val;
                        encoded_ptr = codec.decode_string(encoded_ptr, &tmp_val,1);
                        pixel_c = tmp_val;
                        encoded_ptr = codec.decode_string(encoded_ptr, &tmp_val,1);
                        pixel_d = tmp_val;
                        encoded_ptr = codec.decode_string(encoded_ptr, &tmp_val,1);
                        pixel_e = tmp_val;
                        encoded_ptr = codec.decode_string(encoded_ptr, &tmp_val,1);
                        pixel_f = tmp_val;

                        if(pixel_a < 0){
                            frames_n[index2++]= pixel_a * -2;
                        }else{
                            frames_n[index2++]= pixel_a * 2 + 1;
                        }
                        if(pixel_b < 0){
                            frames_n[index2++]= pixel_b * -2;
                        }else{
                            frames_n[index2++]= pixel_b * 2 + 1;
                        }
                        if(pixel_c < 0){
                            frames_n[index2++]= pixel_c * -2;
                        }else{
                            frames_n[index2++]= pixel_c * 2 + 1;
                        }
                        if(pixel_d < 0){
                            frames_n[index2++]= pixel_d * -2;
                        }else{
                            frames_n[index2++]= pixel_d * 2 + 1;
                        }
                        if(pixel_e < 0){
                            frames_n[index2++]= pixel_e * -2;
                        }else{
                            frames_n[index2++]= pixel_e * 2 + 1;
                        }
                        if(pixel_f < 0){
                            frames_n[index2++]= pixel_f * -2;
                        }else{
                            frames_n[index2++]= pixel_f * 2 + 1;
                        }


                        // [A E F] [B E F] [C E F] [D E F]
                        // cout << "pixel_a: " << pixel_a << endl;
                        // cout << "pixel_b: " << pixel_b << endl;
                        // cout << "pixel_c: " << pixel_c << endl;
                        if(index % period == 0){
                            double avg = 0;
                            for(uint32_t j = index - period; j < index; j++){
                                avg += frames_n[j];
                            }
                            if (avg < 0){
                                avg = -avg;
                            }
                            codec.change_m_decode(calc_m(avg/period));
                            // cout << "m: " << codec.get_m_encode() << endl;
                        }
                        to_write[i_frames].at<Vec3b>(i,j)[0]     -=  pixel_a;
                        to_write[i_frames].at<Vec3b>(i,j)[1]     -=  pixel_e;
                        to_write[i_frames].at<Vec3b>(i,j)[2]     -=  pixel_f;
                        to_write[i_frames].at<Vec3b>(i,j+1)[0]   -=  pixel_b;
                        to_write[i_frames].at<Vec3b>(i,j+1)[1]   -=  pixel_e;
                        to_write[i_frames].at<Vec3b>(i,j+1)[2]   -=  pixel_f;
                        to_write[i_frames].at<Vec3b>(i+1,j)[0]   -=  pixel_c;
                        to_write[i_frames].at<Vec3b>(i+1,j)[1]   -=  pixel_e;
                        to_write[i_frames].at<Vec3b>(i+1,j)[2]   -=  pixel_f;
                        to_write[i_frames].at<Vec3b>(i+1,j+1)[0] -=  pixel_d;
                        to_write[i_frames].at<Vec3b>(i+1,j+1)[1] -=  pixel_e;
                        to_write[i_frames].at<Vec3b>(i+1,j+1)[2] -=  pixel_f;
                    }
                }
            }
        }
        // cout << "Frame " << i_frames << " decoded" << endl;
    }
    if(YUV420_write(fileOut, frames, height, width, to_write, header)!=0){
        cout << "Error writing video" << endl;
        return -1;
    }
    cout << "finish" << endl;

    time_req = clock() - time_req;      //end time measurement
    cout << "Execution time: " << (float)time_req/CLOCKS_PER_SEC << " seconds" << endl;
}