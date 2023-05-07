#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <string>

using namespace std;
int main(int argc, char const *argv[])
{
    // read the first only the first frame of the video "akiyo_cif.y4m"
    // A0:0 means unknown
    // A1:1 means square pixels
    // A4:3 means NTSC-SVCD (480x480 stretched to 4:3 screen)
    // A4:5 means NTSC-DVD narrow-screen (720x480 compressed to a 4:3 display)
    // 'A32:27' = NTSC-DVD wide-screen (720x480 stretched to a 16:9 display)
    // open the video file without opencv   
    FILE *fp = fopen("akiyo_cif.y4m", "r");
    if (fp == NULL)
    {
        cout << "Error opening file" << endl;
        return -1;
    }
    // read the header that contains the video information and ends with a \n character
    char header[100];
    fgets(header, 100, fp);
    cout << "header: " << header << endl;
    // from the header, get the width and height of the video after the 'W' and 'H' characters
    int width = atoi(strchr(header, 'W') + 1);
    int height = atoi(strchr(header, 'H') + 1);
    cout << "width: " << width << endl;
    cout << "height: " << height << endl;
    // from the header, get the frame rate of the video after the 'F' character and before the ':' character
    double frame_rate1 = atoi(strchr(header, 'F') + 1);
    double frame_rate2 = atoi(strchr(header, ':') + 1);
    double frame_rate = frame_rate1 / frame_rate2;
    cout << "frame rate: " << frame_rate << endl;
    // from the header, get the interlacing type of the video after the 'I' character
    char interlacing_type = *(strchr(header, 'I') + 1);
    if (interlacing_type == 'p')
    {
        cout << "interlacing type: progressive" << endl;
    }
    else if (interlacing_type == 't')
    {
        cout << "interlacing type: top-field-first" << endl;
    }
    else if (interlacing_type == 'b')
    {
        cout << "interlacing type: bottom-field-first" << endl;
    }
    else
    {
        cout << "interlacing type: unknown" << endl;
    }
    // from the header, get the aspect ratio of the video after the 'A' character
    int aspect_ratio1 = atoi(strchr(header, 'A') + 1);
    int aspect_ratio2 = atoi(strchr(strchr(header, 'A') + 1, ':') + 1);
    cout << "aspect ratio: " << aspect_ratio1 << ":" << aspect_ratio2 << endl;
    
    // exclude the header from the video file and calculate the number of frames with the formula: width * height * 3/2
    fseek(fp, 0, SEEK_END);
    int file_size = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    int frame_size = width * height * 3 / 2;
    int num_frames = (file_size - 100) / frame_size;
    cout << "number of frames: " << num_frames << endl;

    // read and print every frame of the video
    for(int i = 0; i < num_frames; i++)
    {
        // read the frame and print it
        // the frame starts with a 'FRAME' character and ends with a \n character
        // print the value of each pixel
        char frame[100];
        fgets(frame, 100, fp);
        // cout << "frame: " << frame << endl;
        int frame_size = width * height * 3 / 2;
        unsigned char *frame_data = new unsigned char[frame_size];
        fread(frame_data, 1, frame_size, fp);
        // print the value of each pixel by block of 8x8 where the first block starts at the top left corner in pixel (0,0) and ends at pixel (7,7)
        // the second block starts at pixel (8,0) and ends at pixel (15,7)
        // the third block starts at pixel (16,0) and ends at pixel (23,7)
        // dont forget of the last block that may not be 8x8 and can be smaller or bigger
        // in the case of the last block, the pixels that are not part of the block should be set to 0
        for (int i = 0; i < height; i += 8)
        {
            for (int j = 0; j < width; j += 8)
            {
                cout << "block (" << j << "," << i << "):" << endl;
                for (int k = 0; k < 8; k++)
                {
                    for (int l = 0; l < 8; l++)
                    {
                        if (i + k < height && j + l < width)
                        {
                            cout << (int)frame_data[(i + k) * width + j + l] << " ";
                        }
                        else
                        {
                            cout << 0 << " ";
                        }
                    }
                    cout << endl;
                }
                cout << endl;
            }
        }
    }


    // read only the first frame of the video and print it
    // the first frame starts with a 'FRAME' character and ends with a \n character
    // print the value of each pixel
    // char frame[100];
    // fgets(frame, 100, fp);
    // // cout << "frame: " << frame << endl;
    // int frame_size = width * height;
    // unsigned char *frame_data = new unsigned char[frame_size];
    // fread(frame_data, 1, frame_size, fp);
    // // print the value of each pixel by block of 8x8 where the first block starts at the top left corner in pixel (0,0) and ends at pixel (7,7)
    // // the second block starts at pixel (8,0) and ends at pixel (15,7)
    // // the third block starts at pixel (16,0) and ends at pixel (23,7)
    // for (int i = 0; i < height; i += 8)
    // {
    //     for (int j = 0; j < width; j += 8)
    //     {
    //         cout << "block (" << j << "," << i << "):" << endl;
    //         for (int k = 0; k < 8; k++)
    //         {
    //             for (int l = 0; l < 8; l++)
    //             {
    //                 cout << (int)frame_data[(i + k) * width + j + l] << " ";
    //             }
    //             cout << endl;
    //         }
    //         cout << endl;
    //     }
    // }
}
