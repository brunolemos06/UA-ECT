#include  "codec_video.h"

using namespace std;

int main(int argc, char *argv[]){
    //  Check if the number of arguments is correct
    if (argc < 4){
        cout << "Usage: " << argv[0] << " encode <YUV420 || YUV422> <input_video> <encoded_out> [-mode [1,8] (def: 8)]" << endl;
        cout << "                                                                               [-p [4,  32768] (def: 100)]" << endl;
        cout << "                                                                               [-lossy [1, 7]]" << endl;
        cout << "Usage: " << argv[0] << " decode <encoded_in>  <output_video>" << endl;
        return 1;
    }

    //  Check if the user wants to encode or decode
    if (string(argv[1]) == "encode"){
        //  Check if the user wants to use a different order
        int mode = 8;
        for (int n = 1; n < argc; n++){
            if (string(argv[n]) == "-mode"){
                mode = atoi(argv[n+1]);
                if (mode < 1 || mode > 8){
                    cerr << "Error: invalid order" << endl;
                    return 1;
                }
                break;
            }
        }

        //  Check if the user wants to use a different x
        int p = 100;
        for (int n = 1; n < argc; n++){
            if (string(argv[n]) == "-p"){
                p = atoi(argv[n+1]);
                if (p < 3 && p > 32768){
                    cerr << "Error: invalid x" << endl;
                    return 1;
                }
                break;
            }
        }

        // Check if the user chosen YUV format is valid
        string yuv_format = argv[2];
        if (string(argv[2]) != "YUV420" && string(argv[2]) != "YUV422"){
            cerr << "Error: invalid YUV format" << endl;
            return 1;
        }

        // Check if the user wants to use lossy compression
        int lossy = 0;
        for (int n = 1; n < argc; n++){
            if (string(argv[n]) == "-lossy"){
                lossy = atoi(argv[n+1]);
                if (lossy < 1 || lossy > 7){
                    cerr << "Error: invalid lossy compression" << endl;
                    return 1;
                }
                break;
            }
        }

        codec_video encoder(mode, p, lossy);
        cout << "Encoding file " << argv[3] << " to file "<< argv[4] << endl;
        encoder.encode_video(argv[3], argv[4], yuv_format);
    }
    else if (string(argv[1]) == "decode"){
        codec_video decoder;
        cout << "Decoding file " << argv[2] << " to file "<< argv[3] << endl;
        decoder.decode_video(argv[2], argv[3]);
    }
    else{
        cerr << "Error: invalid option" << endl;
        return 1;
    }
    return 0;
}