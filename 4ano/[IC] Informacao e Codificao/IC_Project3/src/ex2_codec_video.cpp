
#include <fstream>
#include <string>
#include <bitset>
#include <bits/stdc++.h>
#include <opencv2/opencv.hpp>
#include "golomb.h"
#include "codec_image.h"
#include "codec_image.h"

using namespace std;


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

uint32_t calc_m(double avg){
    double alfa = avg / (avg + 1);
    double res = ceil(-1/log2(alfa));
    // cout << "M: " << res << endl;
    if (res == 0){
        return 1;
    }
    return res;
}
//main
int main(int argc, char const *argv[]){

    //  we need at least one argument
    //  codec_alg based on golomb
    golomb codec(2);

    if(argc < 3 ){
        cout << "USAGE ERROR : " << "../bin/ex2_codec_video <input.y4m> <out.txt> (opt --blocksize X --searcharea Y --keyframe Z)\n" << endl;
        return -1;
    }
    const char* fileIn = argv[1];
    const char* fileOut = argv[2];
    clock_t time_req;                           //for time measurement
    time_req = clock();                         //start time measurement

    int mode = 8;
    int p = 100;
    int is_intra = 1;

    // argument with arguments with options and default values
    // default values
    // keyframe = 2
    // search_area = 3
    // n = 16
    // --blocksize for n
    // --keyframe for keyframe
    // --searcharea for search_area
    uint16_t keyframe = 2;
    int search_area = 4;
    int n = 8;
    
    if (argc > 3){
        printf("argc: %d", argc);
        for (int i = 3; i < argc; i++){
            if (strcmp(argv[i], "--blocksize") == 0){
                n = atoi(argv[i+1]);
            }
            if (strcmp(argv[i], "--keyframe") == 0){
                keyframe = atoi(argv[i+1]);
            }
            if (strcmp(argv[i], "--searcharea") == 0){
                search_area = atoi(argv[i+1]);
            }
        }
    }



    int period = 2500;

    Mat frame;                  //frame to store video frame

    VideoCapture cap(fileIn);   //read video

    //check if video is opened
    if(!cap.isOpened()){
        cout << "Error opening video stream or file" << endl;
        return -1;
    }

    VideoCapture cap2(fileIn);
    cap2 >> frame;

    // get video info
    uint32_t width = cap.get(CAP_PROP_FRAME_WIDTH);
    uint32_t height = cap.get(CAP_PROP_FRAME_HEIGHT);
    uint32_t fps = cap.get(CAP_PROP_FPS);
    uint32_t frames = cap.get(CAP_PROP_FRAME_COUNT);
    uint32_t frame_type = frame.type();
    int fourcc = cap.get(CAP_PROP_FOURCC);    

    //close cap2   
    cap2.release();

    //create image codec
    image_codec encoder(8, 100); // change 
    
    codec.change_m_encode(calc_m(2));
    string encoded=""; //string to store encoded data
    
    //print header info
    cout << "Video info: " << endl;
    cout << "\tWidth: " << width << endl;
    cout << "\tHeight: " << height << endl;
    cout << "\tFPS: " << fps << endl;
    cout << "\tFrames: " << frames << endl;
    cout << "\tFrame type: " << frame_type << endl;
    cout << "\tFourCC: " << fourcc << endl;
    cout << "\tMode: " << mode << endl;
    cout << "\tIntra(1)/Inter(0): " << is_intra << endl;
    cout << "\tPeriod: " << p << endl;
    cout << "\tKeyframe: " << keyframe << endl;
    cout << "\tBlockSize: " << n << endl;
    cout << "\tSearch Area: " << search_area << endl;
    //alloc space for frames
    Mat* to_store = new Mat[frames];
    //read video
    string header = read_YUV420_to_frames(fileIn, frames, height, width, frame_type, to_store);

    //print header and size
    cout << "Header: " << header << endl;
    cout << "Header size: " << header.size() << endl;
    cout << "Coding ... " << endl;

    // --------------- Start encode ---------------
    encoded += bitset<32>(width).to_string();
    encoded += bitset<32>(height).to_string();
    encoded += bitset<32>(frames).to_string();
    encoded += bitset<16>(header.size()).to_string();
    encoded += bitset<16>(keyframe).to_string();
    encoded+=  bitset<16>(n).to_string();

    for(uint32_t i = 0; i < header.size(); i++){
        encoded += bitset<8>(header[i]).to_string();
    }


    Mat temp(height, width, CV_8UC3); //pointer to decoded frame
    uint64_t sum = 0;
    // n need to be multiple of height and width
    if (height%n != 0 || width%n != 0){
        cout << "ERROR: BlockSize need to be multiple of height and width" << endl;
        return -1;
    }
    string newencoded0 = "";
    string newencoded1 = "";

    int* frames_array = new int[height*width*3];
    int* vectors = new int[(2*(height*width))/(n*n)];

    int test[height][width][3];

    int sum_new = 0;
    int last_keyframe = 0;
    int index = 0;
    int index2 = 0;
    int numberofintra = 0;
    int numberofinter = 0;
    int quant = 1;

    int* lastvalues = new int[height*width*3];
    

    for(uint32_t i_frames = 0; i_frames < frames; i_frames++){
        index = 0;
        if (i_frames%keyframe == 0){
            // print to_store[i_frames] in blocks
            // cout << "Frame: " << i_frames << endl;

            encoded += encoder.YUV420_encode_video_frame(to_store[i_frames]);
            last_keyframe = i_frames;
            numberofintra++;
        }else{
            index = 0;
            sum_new = 0;
            newencoded1 = "";
            newencoded0 = "";
            newencoded1 = encoder.YUV420_encode_video_frame(to_store[i_frames]);
            codec.change_m_encode(2);
            for (int i = 0; i < height; i += n){
                for (int j = 0; j < width; j += n){
                    // start of block
                    int numberblock = (j/n) + (((i/n)*width)/n);

                    int start_i = i - search_area;
                    int start_j = j - search_area;
                    int end_i = i + search_area + n - 1;
                    int end_j = j + search_area + n - 1;

                    if (start_i < 0){
                        start_i = 0;
                    }
                    if (start_j < 0){
                        start_j = 0;
                    }
                    if (end_i > height){
                        end_i = height;
                    }
                    if (end_j > width){
                        end_j = width;
                    }


                    int min_i = start_i;
                    int min_j = start_j;
                    int min = 255*3*n*n;


                    for (int k = start_i; k < (end_i-n+1); k += 1){
                        for (int l = start_j; l < (end_j-n+1); l += 1){
                            sum = 0;
                            // cout << "starti: " << k << " startj: " << l << endl;
                            for(int var_i = k; var_i < k+n; var_i++){
                                for(int var_j = l; var_j < l+n; var_j++){
                                    // cout << "index" << i+var_i-k << " " << j+var_j-j << endl;
                                    sum += abs(to_store[i_frames].at<uchar>(var_i+i-k,var_j+j-l) - to_store[last_keyframe].at<uchar>(var_i,var_j));
                                }
                            }
                            
                            if (sum < min){
                                min = sum;
                                min_i = k;
                                min_j = l;
                            }
                        }
                    }

                    int motion_vector_i = min_i-i;                                                              // i+vector_i = min_i
                    int motion_vector_j = min_j-j;                                                              // j+vector_j = min_j
                    
                    // for block start at min_i, min_j
                    // subtract each pixel of block with the corresponding pixel of the keyframe
                    // add the result to the encoded string

                    for (int k = 0; k < n; k++){
                        for (int l = 0; l < n; l++){
                            
                            test[i+k][j+l][0] = to_store[last_keyframe].at<Vec3b>(min_i+k,min_j+l)[0] - to_store[i_frames].at<Vec3b>(i+k,j+l)[0];
                            test[i+k][j+l][1] = to_store[last_keyframe].at<Vec3b>(min_i+k,min_j+l)[1] - to_store[i_frames].at<Vec3b>(i+k,j+l)[1];
                            test[i+k][j+l][2] = to_store[last_keyframe].at<Vec3b>(min_i+k,min_j+l)[2] - to_store[i_frames].at<Vec3b>(i+k,j+l)[2];
                            // frames_array[index] = 
                            // index++;
                            // frames_array[index] = to_store[i_frames].at<Vec3b>(i+k,j+l)[1] - to_store[last_keyframe].at<Vec3b>(min_i+k,min_j+l)[1];
                            // index++;
                            // frames_array[index] = to_store[i_frames].at<Vec3b>(i+k,j+l)[2] - to_store[last_keyframe].at<Vec3b>(min_i+k,min_j+l)[2];
                            // index++;
                        }
                    }

                    vectors[numberblock*2] = motion_vector_i;   // 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30
                    vectors[numberblock*2+1] = motion_vector_j; // 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31
                }
            }

            // if (index != height*width*3){
            //     cout << "ERROR INDEX" <<  endl;
            //     return -1;
            // }
                        
            // ! vector to encoded
            // cout << "HERE" << endl;
            index = 0;
            for(int i = 0; i < (2*(height*width))/(n*n); i++){
                // dinamic m
                index++;
                newencoded0 += codec.encode_number(vectors[i],1);
                if((index) % period == 0){
                    double avg = 0;
                    for(uint32_t j = index - period; j < index; j++){
                        if (vectors[j] < 0){
                            vectors[j] = vectors[j] * -2;

                        }else{
                            vectors[j] = vectors[j] * 2 + 1;
                        }
                        avg += vectors[j];
                    }
                    if (avg < 0){
                        avg = 1;
                    }
                    codec.change_m_encode(calc_m(avg/period));
                    // cout << "m: " << codec.get_m_encode() << endl;
                }
            }
            index = 0;
            index2 = 0;
            for (int i = 0; i < height; i += 2){
                for (int j = 0; j < width; j += 2){
                    index2++;
                    // pixel1 0,0 -> i,j
                    // pixel2 0,1 -> i,j+1
                    // pixel3 1,0 -> i+1,j
                    // pixel4 1,1 -> i+1,j+1

                    // 10 b c 9 b c
                    // 32 b c 77 b c
                    // encode pixel1[0] pixel2[0] pixel3[0] pixel4[0]
                    // encode pixel1[1] pixel1[2]
                    
                    newencoded0 += codec.encode_number(test[i][j][0],1);  // pixel1[0]
                    newencoded0 += codec.encode_number(test[i][j+1][0],1);  // pixel2[0]
                    newencoded0 += codec.encode_number(test[i+1][j][0],1);  // pixel3[0]
                    newencoded0 += codec.encode_number(test[i+1][j+1][0],1);  // pixel4[0]
                    newencoded0 += codec.encode_number(test[i][j][1],1);  // pixel1[1]
                    newencoded0 += codec.encode_number(test[i][j][2],1);  // pixel1[2]
                    if (test[i][j][0] < 0){
                        lastvalues[index++] = -2*test[i][j][0];
                    }else{
                        lastvalues[index++] = 2*test[i][j][0]+1;
                    }
                    
                    if (test[i][j+1][0] < 0){
                        lastvalues[index++] = -2*test[i][j+1][0];
                    }else{
                        lastvalues[index++] = 2*test[i][j+1][0]+1;
                    }

                    if (test[i+1][j][0] < 0){
                        lastvalues[index++] = -2*test[i+1][j][0];
                    }else{
                        lastvalues[index++] = 2*test[i+1][j][0]+1;
                    }
                                        
                    if (test[i+1][j+1][0] < 0){
                        lastvalues[index++] = -2*test[i+1][j+1][0];
                    }else{
                        lastvalues[index++] = 2*test[i+1][j+1][0]+1;
                    }

                    if (test[i][j][1] < 0){
                        lastvalues[index++] = -2*test[i][j][1];
                    }else{
                        lastvalues[index++] = 2*test[i][j][1]+1;
                    }

                    if (test[i][j][2] < 0){
                        lastvalues[index++] = -2*test[i][j][2];
                    }else{
                        lastvalues[index++] = 2*test[i][j][2]+1;
                    }

                    // cout << "index " << index << endl;
                    if(index2 % period == 0){
                        double avg = 0;
                        for(uint32_t j = index2 - period; j < index2; j++){
                            avg += lastvalues[j];
                        }
                        if (avg < 0){
                            avg = -avg;
                        }
                        codec.change_m_encode(calc_m(avg/period));
                        // cout << "m: " << codec.get_m_encode() << endl;
                    }
                }
            }
            // save frame1 to file
            // test to mat
            // Mat test2(height, width, CV_8UC3, test);
            // for (int i = 0; i < height; i++){
            //     for (int j = 0; j < width; j++){
            //         test2.at<Vec3b>(i,j)[0] = test[i][j][0];
            //         test2.at<Vec3b>(i,j)[1] = test[i][j][1];
            //         test2.at<Vec3b>(i,j)[2] = test[i][j][2];
            //     }
            // }
            // if (i_frames == 1){
            //     imwrite("frame1.jpg", test2);
            // }

            // cout << "newencoded0: " << newencoded0.size() << endl;
            // cout << "newencoded1: " << newencoded1.size() << endl;

            codec.change_m_encode(2);
            if (newencoded0.size() < newencoded1.size()){
                encoded += codec.encode_number(0,1);
                encoded += newencoded0;
                numberofinter++;
            }else{
                encoded += codec.encode_number(1,1);
                encoded += newencoded1;
                numberofintra++;
            }
            // return 0;
        }
        
        // cout << "Frame " << i_frames << " already computed" << endl;
        // save frame15 to file
    }

    // write


    write_bin_to_file(fileOut, encoded);




    // ------------------ finish ------------------
    time_req = clock() - time_req;              //end time measurement
    cout << endl;
    cout << "Time taken: " << (float)time_req/CLOCKS_PER_SEC << " seconds" << endl;
    
    //compare size of original and encoded file
    ifstream file1(fileIn, ios::binary | ios::ate);
    ifstream file2(fileOut, ios::binary | ios::ate);
    cout << "Original file size: " << file1.tellg() << " bytes" << endl;
    cout << "Encoded file size: " << file2.tellg() << " bytes" << endl;
    cout << "Number of intra frames: " << numberofintra << endl;
    cout << "Number of inter frames: " << numberofinter << endl;
    //compression ratio
    cout << "Compression ratio: " << (float)file1.tellg()/(float)file2.tellg() << endl;
    cout << "Percentage of original size: " << (float)file2.tellg()/(float)file1.tellg()*100 << "%" << endl;
    file1.close();
    file2.close();
}