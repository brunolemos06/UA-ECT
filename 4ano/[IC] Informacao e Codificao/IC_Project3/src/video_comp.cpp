#include <fstream>
#include <string>
#include <bitset>
#include <bits/stdc++.h>
#include <opencv2/opencv.hpp>

#include "codec_image.h"

using namespace std;
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

int main(int argc, char** argv)
{
//  we need at least one argument
    if(argc < 5 ){
        cout << "USAGE ERROR : " << "../bin/video_comp <input.y4m> <input.y4m> <max value of the signal> <YUV420/YUV422>" << endl;
        return -1;
    }
    const char* fileIn1 = argv[1];
    clock_t time_req;                           //for time measurement
    time_req = clock();                         //start time measurement
    string video_type = argv[4];
    cout << "Video type : " << video_type << endl;

    int mode = 8;
    int p = 100;
    int is_intra = 1;
    Mat frame;                  //frame to store video frame

    VideoCapture cap(fileIn1);   //read video

    //check if video is opened
    if(!cap.isOpened()){
        cout << "Error opening video stream or file" << endl;
        return -1;
    }

    VideoCapture cap2(fileIn1);
    cap2 >> frame;

    //get video info
    uint32_t width = cap.get(CAP_PROP_FRAME_WIDTH);
    uint32_t height = cap.get(CAP_PROP_FRAME_HEIGHT);
    uint32_t fps = cap.get(CAP_PROP_FPS);
    uint32_t frames = cap.get(CAP_PROP_FRAME_COUNT);
    uint32_t frame_type = frame.type();
    int fourcc = cap.get(CAP_PROP_FOURCC);
    
    //close cap2   
    cap2.release();

    //create image codec
    image_codec encoder(mode, p); // change 

    string encoded=""; //string to store encoded data

    //print header info
    cout << "--------------------------------------" << endl;
    cout << "|            Video 1 info:           |" << endl;
    cout << "--------------------------------------" << endl;
    cout << "\tWidth: " << width << endl;
    cout << "\tHeight: " << height << endl;
    cout << "\tFPS: " << fps << endl;
    cout << "\tFrames: " << frames << endl;
    cout << "\tFrame type: " << frame_type << endl;
    cout << "\tFourCC: " << fourcc << endl;
    cout << "\tMode: " << mode << endl;
    cout << "\tIntra(1)/Inter(0): " << is_intra << endl;
    cout << "\tPeriod: " << p << endl;

    //alloc space for frames
    Mat* to_store = new Mat[frames];
    string header = "";
    if(video_type=="YUV420")
        header = read_YUV420_to_frames(fileIn1, frames, height, width, frame_type, to_store);
    else if(video_type=="YUV422")
        header = YUV422_read(fileIn1, frames, height, width, to_store);
    else
        cout << "ERROR: Video not supported" << endl;

    //read video
    

    //print header and size
    cout << "\tHeader: " << header << endl;
    cout << "\tHeader size: " << header.size() << endl;  

    // do the same thing for the second video
    const char* fileIn2 = argv[2];
    VideoCapture cap3(fileIn2);
    cap3 >> frame;

    //get video info
    uint32_t width2 = cap3.get(CAP_PROP_FRAME_WIDTH);
    uint32_t height2 = cap3.get(CAP_PROP_FRAME_HEIGHT);
    uint32_t fps2 = cap3.get(CAP_PROP_FPS);
    uint32_t frames2 = cap3.get(CAP_PROP_FRAME_COUNT);
    uint32_t frame_type2 = frame.type();
    int fourcc2 = cap3.get(CAP_PROP_FOURCC);
    cout << "\n--------------------------------------" << endl;
    cout << "|            Video 2 info:           |" << endl;
    cout << "--------------------------------------" << endl;
    cout << "\tWidth: " << width2 << endl;
    cout << "\tHeight: " << height2 << endl;
    cout << "\tFPS: " << fps2 << endl;
    cout << "\tFrames: " << frames2 << endl;
    cout << "\tFrame type: " << frame_type2 << endl;
    cout << "\tFourCC: " << fourcc2 << endl;
    cout << "\tMode: " << mode << endl;
    cout << "\tIntra(1)/Inter(0): " << is_intra << endl;
    cout << "\tPeriod: " << p << endl;

    //alloc space for frames
    Mat* to_store2 = new Mat[frames2];
    string header2 = "";
    if(video_type=="YUV420")
        header2 = read_YUV420_to_frames(fileIn2, frames2, height2, width2, frame_type2, to_store2);
    else if(video_type=="YUV422")
        header2 = YUV422_read(fileIn2, frames2, height2, width2, to_store2);
    else
        cout << "ERROR: Video not supported" << endl;

    //print header and size
    cout << "\tHeader: " << header2 << endl;
    cout << "\tHeader size: " << header2.size() << endl;

    
    // verify that the two videos have the same number of frames, width and height
    if(frames != frames2 || width != width2 || height != height2){
        cout<< "-------------------------------------------------------------------" << endl;
        cout << "The two videos are not comparible" << endl;
        return -1;
    }else{
        cout << "\n---------->Starting comparision<------------\n" << endl;
    }
    // arg[3] to double
    double arg = atof(argv[3]);
    double errorY = 0;
    double errorU = 0;
    double errorV = 0;
    double A2=arg*arg;
    double var = ((height*width));
    var=1/var;
    double sumY = 0;
    double sumU = 0;
    double sumV = 0;
    double eY=0;
    double eU=0;
    double eV=0;
    double PSNRY = 0;
    double PSNRU = 0;
    double PSNRV = 0;

    for(uint32_t i = 0; i < frames; i++){
        for(uint32_t j = 0; j < height; j++){
            for(uint32_t k = 0; k < width; k++){
                errorY = to_store[i].at<Vec3b>(j,k)[0] - to_store2[i].at<Vec3b>(j,k)[0];
                errorU = to_store[i].at<Vec3b>(j,k)[1] - to_store2[i].at<Vec3b>(j,k)[1];
                errorV = to_store[i].at<Vec3b>(j,k)[2] - to_store2[i].at<Vec3b>(j,k)[2];
                sumY += errorY * errorY;
                sumU += errorU * errorU;
                sumV += errorV * errorV;
            }
        }
    }
    
    eY = var*sumY;
    PSNRY=10*log10(A2/eY);
    eU = var*sumU;
    PSNRU=10*log10(A2/eU);
    eV = var*sumV;
    PSNRV=10*log10(A2/eV);

    cout << "Calculating PSNR...\n" << endl;
    
    cout << "Peak signal noise ratio for Y: " << PSNRY<< "\n"<<endl;
    cout << "Peak signal noise ratio for U: " << PSNRU <<"\n" <<endl;
    cout << "Peak signal noise ratio for V: " << PSNRV <<  "\n"<<endl;
}