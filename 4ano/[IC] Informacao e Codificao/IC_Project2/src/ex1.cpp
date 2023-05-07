
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <iostream>

using namespace cv;
using namespace std;

//Using the OpenCV library, implement a program to copy an image, pixel by pixel, from one file
//to another file. Both file names should be passed as command line arguments to the program.

int main(int argc, char** argv )
{
    if ( argc != 3 )
    {
        printf("usage: DisplayImage.out <Image_Path> <Image_Path>");
        return -1;
    }

    Mat image;
    image = imread( argv[1], 1 );

    if ( !image.data )
    {
        printf("No image data ");
        return -1;
    }

    Mat image3(image.rows, image.cols, CV_8UC3, Scalar(0,0,0));

    //make a copy of the image by copying each pixel

    for(int i = 0; i < image.rows; i++)
    {
        for(int j = 0; j < image.cols; j++)
        {
            image3.at<Vec3b>(i,j)[0] = image.at<Vec3b>(i,j)[0];
            image3.at<Vec3b>(i,j)[1] = image.at<Vec3b>(i,j)[1];
            image3.at<Vec3b>(i,j)[2] = image.at<Vec3b>(i,j)[2];
        }
    }

    //create a new image file and write the image to it
    imwrite(argv[2], image3);

    waitKey(0);

    return 0;
}