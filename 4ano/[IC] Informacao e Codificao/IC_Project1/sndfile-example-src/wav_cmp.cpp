#include <iostream>
#include <sndfile.hh>
#include <vector>
#include <cmath>
using namespace std;

constexpr size_t FRAMES_BUFFER_SIZE = 65536; // Buffer for reading/writing frames

int main(int argc, char *argv[]) {

    if(argc < 3) {
		cerr << "Usage: wav_cp <orignal filename> <compressed filename>" << endl;
		return 1;
	}

    SndfileHandle sfhInOG { argv[argc-2] };
    SndfileHandle sfhInCO { argv[argc-1] };
	if(sfhInOG.error() || sfhInCO.error()) {
		cerr << "Error: invalid input file\n";
		return 1;
    }

	if((sfhInOG.format() & SF_FORMAT_TYPEMASK) != SF_FORMAT_WAV || (sfhInCO.format() & SF_FORMAT_TYPEMASK) != SF_FORMAT_WAV) {
		cerr << "Error: file is not in WAV format\n";
		return 1;
	}

	if((sfhInOG.format() & SF_FORMAT_SUBMASK) != SF_FORMAT_PCM_16 || (sfhInCO.format() & SF_FORMAT_SUBMASK) != SF_FORMAT_PCM_16) {
		cerr << "Error: file is not in PCM_16 format\n";
		return 1;
	}

    //files must have same number of samples
    if((sfhInOG.samplerate() * sfhInOG.channels()) != (sfhInCO.samplerate() * sfhInCO.channels())){
        cerr << "files do not have the same number of samples" << endl;
        return 1;
    }




    double D = 0, S=0;
    double maxError = 0, tmpError;
    double N = sfhInOG.frames()*sfhInOG.channels();

    size_t nFramesOG;
    vector<short> OGsamples(FRAMES_BUFFER_SIZE * sfhInOG.channels());

    size_t nFramesCO;
    vector<short> COsamples(FRAMES_BUFFER_SIZE * sfhInCO.channels());

    while((nFramesOG = sfhInOG.readf(OGsamples.data(), FRAMES_BUFFER_SIZE)), (nFramesCO = sfhInCO.readf(COsamples.data(), FRAMES_BUFFER_SIZE))){
        OGsamples.resize(nFramesOG * sfhInOG.channels());
        COsamples.resize(nFramesOG * sfhInCO.channels());
        //iterate samples
        for(size_t i = 0; i< OGsamples.size(); ++i){
            D += pow(OGsamples[i]-COsamples[i], 2);
            S += pow(OGsamples[i], 2);
            tmpError = abs(OGsamples[i] - COsamples[i]);
            if(tmpError > maxError)
                maxError = tmpError;
        }
    }

    D = (1/N) * D;
    S = (1/N) * S;

    //Calculating SNR (expressed in dB)
    double SNR = 10*log10(S/D);
    cout << "SNR: " << SNR << " dB\nMaximum per sample absolute error: " << maxError << endl;

}
