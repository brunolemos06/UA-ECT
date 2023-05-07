#include <opencv2/opencv.hpp>
#include <iostream>
#include <stdio.h>


using namespace std; // std dont need
using namespace cv; // cv dont need

void print(){
    cerr << "../bin/ex2 [ -a ] <ImageIn> <ImageOut>" << endl;
    cerr << "../bin/ex2 [ -b ] <ImageIn> <ImageOut> [ -h | -v ]" << endl;
    cerr << "../bin/ex2 [ -c ] <ImageIn> <ImageOut> <degree>" << endl;
    cerr << "../bin/ex2 [ -d ] <ImageIn> <ImageOut> <<inc/decr>>" << endl;
}

int ex2_b(string InputFileName, string OutputFileName,string option){
    Mat image;
    image = imread( InputFileName, 1 );

    if ( !image.data )
    {
        printf("No image data \n");
        return -1;
    }

    Mat image2;
    image2 = imread( OutputFileName, 1 );

    if ( !image2.data )
    {
        printf("No image data2 \n");
        return -1;
    }

    Mat image3(image.rows, image.cols, CV_8UC3, Scalar(0,0,0));
    if (option == "-h"){
        for(int i = 0; i < image.rows; i++)
        {
            for(int j = 0; j < image.cols; j++)
            {
                //mirror the image horizontally
                image3.at<Vec3b>(i,j)[0] = image.at<Vec3b>(i,image.cols-j-1)[0];
                image3.at<Vec3b>(i,j)[1] = image.at<Vec3b>(i,image.cols-j-1)[1];
                image3.at<Vec3b>(i,j)[2] = image.at<Vec3b>(i,image.cols-j-1)[2];
            }
        }
    }else if (option == "-v"){
        for(int i = 0; i < image.rows; i++)
        {
            for(int j = 0; j < image.cols; j++)
            {
                //mirror the image vertically
                image3.at<Vec3b>(i,j)[0] = image.at<Vec3b>(image.rows-i-1,j)[0];
                image3.at<Vec3b>(i,j)[1] = image.at<Vec3b>(image.rows-i-1,j)[1];
                image3.at<Vec3b>(i,j)[2] = image.at<Vec3b>(image.rows-i-1,j)[2];
            }
        }
    }
    else{
        print();
        return -1;
    }

    //write the image to the second file
    imwrite(OutputFileName, image3);

    

    return 0;
}

int ex2_a(string InputFileName, string OutputFileName){
    Mat image;
    image = imread( InputFileName, 1 );
    if ( !image.data )
    {
        printf("No image data \n");
        return -1;
    }

    Mat image2;
    image2 = imread( OutputFileName, 1 );

    if ( !image2.data )
    {
        printf("No image data2 \n");
        return -1;
    }

    Mat image3(image.rows, image.cols, CV_8UC3, Scalar(0,0,0));

    for(int i = 0; i < image.rows; i++)
    {
        for(int j = 0; j < image.cols; j++)
        {
            //  black and white
            image3.at<Vec3b>(i,j)[0] = (image.at<Vec3b>(i,j)[0] + image.at<Vec3b>(i,j)[1] + image.at<Vec3b>(i,j)[2])/3;
            image3.at<Vec3b>(i,j)[1] = (image.at<Vec3b>(i,j)[0] + image.at<Vec3b>(i,j)[1] + image.at<Vec3b>(i,j)[2])/3;
            image3.at<Vec3b>(i,j)[2] = (image.at<Vec3b>(i,j)[0] + image.at<Vec3b>(i,j)[1] + image.at<Vec3b>(i,j)[2])/3;
        }
    }
    //write the image to the second file
    imwrite(OutputFileName, image3);

    return 0;

}

int ex2_c(string InputFile, string OutputFileName,int degrees){
    Mat image;
    image = imread(InputFile, 1 );

    if ( !image.data )
    {
        printf("No image data \n");
        return -1;
    }

    Mat image3(image.cols, image.rows, CV_8UC3, Scalar(0,0,0));
    //rotate by the number of degrees passed in
    
    if(degrees == 90)
    {

        for(int i = 0; i < image.cols; i++)
        {
            for(int j = 0; j < image.rows; j++)
            {
                //rotate the image 90 degrees
                image3.at<Vec3b>(i,j)[0] = image.at<Vec3b>(j,image.cols - i - 1)[0];
                image3.at<Vec3b>(i,j)[1] = image.at<Vec3b>(j,image.cols - i - 1)[1];
                image3.at<Vec3b>(i,j)[2] = image.at<Vec3b>(j,image.cols - i - 1)[2];            
            }
        }
    }
    else if(degrees == 180)
    {
        image3 = Mat(image.rows, image.cols, CV_8UC3, Scalar(0,0,0));
        for(int i = 0; i < image.rows; i++)
        {
            for(int j = 0; j < image.cols; j++)
            {
                //rotate the image 180 degrees
                image3.at<Vec3b>(i,j)[0] = image.at<Vec3b>(image.rows - i - 1,image.cols - j - 1)[0];
                image3.at<Vec3b>(i,j)[1] = image.at<Vec3b>(image.rows - i - 1,image.cols - j - 1)[1];
                image3.at<Vec3b>(i,j)[2] = image.at<Vec3b>(image.rows - i - 1,image.cols - j - 1)[2];            
            }
        }
    }
    else if(degrees == 270)
    {
        for(int i = 0; i < image.cols; i++)
        {
            for(int j = 0; j < image.rows; j++)
            {
                //rotate the image 270 degrees
                image3.at<Vec3b>(i,j)[0] = image.at<Vec3b>(image.rows - j - 1,i)[0];
                image3.at<Vec3b>(i,j)[1] = image.at<Vec3b>(image.rows - j - 1,i)[1];
                image3.at<Vec3b>(i,j)[2] = image.at<Vec3b>(image.rows - j - 1,i)[2];            
            }
        }
    }
    else
    {
        printf("Invalid number of degrees. Must be 90, 180, or 270.\n");
        return -1;
    }

    //write image into a new file with the name of the second file passed in
    imwrite(OutputFileName, image3);

    return 0;
}

int ex2_d(string InputFile, string OutputFileName, const char* type){

    Mat image;
    image = imread( InputFile, 1 );

    if ( !image.data )
    {
        printf("No image data \n");
        return -1;
    }

    Mat image3(image.rows, image.cols, CV_8UC3, Scalar(0,0,0));

    //if the third argument is "inc", then increase the brightness of the image by 50
    if(strcmp(type, "inc") == 0)
    {
        for(int i = 0; i < image.rows; i++)
        {
            for(int j = 0; j < image.cols; j++)
            {
                //increase the brightness of the image by 50
                image3.at<Vec3b>(i,j)[0] = image.at<Vec3b>(i,j)[0] + 50;
                image3.at<Vec3b>(i,j)[1] = image.at<Vec3b>(i,j)[1] + 50;
                image3.at<Vec3b>(i,j)[2] = image.at<Vec3b>(i,j)[2] + 50;
            }
        }
    }
    //if the third argument is "decr", then decrease the brightness of the image by 50
    else if(strcmp(type, "decr") == 0)
    {
        for(int i = 0; i < image.rows; i++)
        {
            for(int j = 0; j < image.cols; j++)
            {
                //decrease the brightness of the image by 50
                image3.at<Vec3b>(i,j)[0] = image.at<Vec3b>(i,j)[0] - 50;
                image3.at<Vec3b>(i,j)[1] = image.at<Vec3b>(i,j)[1] - 50;
                image3.at<Vec3b>(i,j)[2] = image.at<Vec3b>(i,j)[2] - 50;
            }
        }
    }
    else
    {   print();
        return -1;
    }

    //write the image to the second file
    imwrite(OutputFileName, image3);
 
    return 0;
}

int main(int argc, char** argv){
    // arguments -a -b -c -d

    // You just can have one argument of each type (a, b, c, d)
    // Check if there is 4 arguments
    if (argc >= 0 && argc<=3){
        print();
        return 0;
    }
    else if(argc != 4 && (strcmp(argv[1], "-a") == 0)) {
        print();
        return 0;
    }else if (argc !=5 && (strcmp(argv[1], "-c") == 0 || strcmp(argv[1], "-d") == 0 || strcmp(argv[1], "-b") == 0)){
        print();
        return 0;
    }
    // input file name and output file name
    string InputFileName = argv[2];
    string OutputFileName = argv[3];
    // cout << argv[1] << endl;
    // -a  EX2_A
    if (strcmp(argv[1], "-a") == 0){
        cout << "Processing ex2 a)\nInputFile: " + InputFileName + "\nOutputFile: " + OutputFileName << endl;
        ex2_a(InputFileName,OutputFileName); //"../Images/airplane.ppm"
        cout << "Done !! "<< endl;
    } // -b EX2_B
    else if (strcmp(argv[1], "-b") == 0){
        cout << "Processing ex2 b)\nInputFile: " + InputFileName + "\nOutputFile: " + OutputFileName << endl;
        ex2_b(InputFileName,OutputFileName,argv[4]); //"../Images/airplane.ppm"
        cout << "Done !! "<< endl;
    } // -c EX2_C
    else if (strcmp(argv[1], "-c") == 0){
        cout << "Processing ex2 c)\nInputFile: " + InputFileName + "\nOutputFile: " + OutputFileName << endl;
        int degrees;
        try{
            degrees = atoi(argv[4]);
        }catch(exception const & e){
            print();
            return -1;
        }
        
        ex2_c(InputFileName,OutputFileName,degrees);
        cout << "Done !! "<< endl;
    }
    else if (strcmp(argv[1], "-d") == 0){
        cout << "Processing ex2 d)\nInputFile: " + InputFileName + "\nOutputFile: " + OutputFileName << endl;
        const char* type;
        try{
            type = argv[4];
        }catch(exception const & e){
            print();
            return -1;
        }
    
        if (-1 == ex2_d(InputFileName,OutputFileName,type)){
            cout << "Erro !! "<< endl;
            return -1;
        }
        cout << "Done !!" << endl;
    }
    else{
        print();
        return 0;
    }
}