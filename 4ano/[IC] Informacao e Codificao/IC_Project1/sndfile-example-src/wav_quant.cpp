#include <iostream>
#include <vector>
#include <sndfile.hh>
#include "wav_quant.h"

using namespace std;

constexpr size_t FRAMES_BUFFER_SIZE = 65536; // Buffer for reading frames

int main(int argc, char *argv[]) {

	if(argc < 4) {
		cerr << "Usage: " << argv[0] << " <input file> <output_file> <bit_cut>\n";
		return 1;
	}

	SndfileHandle sfhIn { argv[argc-3] };
	if(sfhIn.error()) {
		cerr << "Error: invalid input file\n";
		return 1;
    }

	if((sfhIn.format() & SF_FORMAT_TYPEMASK) != SF_FORMAT_WAV) {
		cerr << "Error: file is not in WAV format\n";
		return 1;
	}

	if((sfhIn.format() & SF_FORMAT_SUBMASK) != SF_FORMAT_PCM_16) {
		cerr << "Error: file is not in PCM_16 format\n";
		return 1;
	}

    SndfileHandle sfhOut { argv[argc-2], SFM_WRITE, sfhIn.format(),
    sfhIn.channels(), sfhIn.samplerate() };
	if(sfhOut.error()) {
		cerr << "Error: invalid output file\n";
		return 1;
    }


    int bit_cut { stoi(argv[argc-1]) };

    if(bit_cut < 1 || bit_cut > 15) {
        cerr << "Error: invalid number of bits to cut\n";
        return 1;
    }

    size_t nFrames;
    vector<short> samples(FRAMES_BUFFER_SIZE * sfhIn.channels());

    while((nFrames = sfhIn.readf(samples.data(), FRAMES_BUFFER_SIZE))) {
        samples.resize(nFrames * sfhIn.channels());
        WAVQuant quant { samples.size(), short(bit_cut) };
        quant.uniform_scalar(samples);
        sfhOut.writef(quant.get_quant().data(), nFrames);
    }

}