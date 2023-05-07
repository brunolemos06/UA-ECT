#include <iostream>
#include <vector>
#include <cmath>
#include <fftw3.h>
#include <sndfile.hh>

#include <stdio.h>
#include <stdlib.h>
#include <bitset>

#include "BitStream.h"

using namespace std;

string findTwoscomplement(string str); //translates a binary string to its two's complement

int main(int argc, char *argv[]) {

	bool verbose { false };
	size_t bs { 1024 };
	double dctFrac { 0.2 };

	if(argc < 3) {
		cerr << "Usage: wav_dct [ -v (verbose) ]\n";
		cerr << "               [ -bs blockSize (def 1024) ]\n";
		cerr << "               [ -frac dctFraction (def 0.2) ]\n";
		cerr << "               wavFileIn wavFileOut\n";
		return 1;
	}

	for(int n = 1 ; n < argc ; n++)
		if(string(argv[n]) == "-v") {
			verbose = true;
			break;
		}

	for(int n = 1 ; n < argc ; n++)
		if(string(argv[n]) == "-bs") {
			bs = atoi(argv[n+1]);
			break;
		}

	for(int n = 1 ; n < argc ; n++)
		if(string(argv[n]) == "-frac") {
			dctFrac = atof(argv[n+1]);
			break;
		}

	SndfileHandle sfhIn { argv[argc-2] };
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

	SndfileHandle sfhOut { argv[argc-1], SFM_WRITE, sfhIn.format(),
	  sfhIn.channels(), sfhIn.samplerate() };
	if(sfhOut.error()) {
		cerr << "Error: invalid output file\n";
		return 1;
    }

	if(verbose) {
		cout << "Input file has:\n";
		cout << '\t' << sfhIn.frames() << " frames\n";
		cout << '\t' << sfhIn.samplerate() << " samples per second\n";
		cout << '\t' << sfhIn.channels() << " channels\n";
	}

	size_t nChannels { static_cast<size_t>(sfhIn.channels()) };
	size_t nFrames { static_cast<size_t>(sfhIn.frames()) };

	// Read all samples: c1 c2 ... cn c1 c2 ... cn ...
	// Note: A frame is a group c1 c2 ... cn
	vector<short> samples(nChannels * nFrames);
	sfhIn.readf(samples.data(), nFrames);

	size_t nBlocks { static_cast<size_t>(ceil(static_cast<double>(nFrames) / bs)) };

	// Do zero padding, if necessary
	samples.resize(nBlocks * bs * nChannels);

	// Vector for holding all DCT coefficients, channel by channel
	vector<vector<double>> x_dct(nChannels, vector<double>(nBlocks * bs));

	// Vector for holding DCT computations
	vector<double> x(bs);

	// Direct DCT
	fftw_plan plan_d = fftw_plan_r2r_1d(bs, x.data(), x.data(), FFTW_REDFT10, FFTW_ESTIMATE);
	for(size_t n = 0 ; n < nBlocks ; n++)
		for(size_t c = 0 ; c < nChannels ; c++) {
			for(size_t k = 0 ; k < bs ; k++)
				x[k] = samples[(n * bs + k) * nChannels + c];

			fftw_execute(plan_d);
			// Keep only "dctFrac" of the "low frequency" coefficients
			for(size_t k = 0 ; k < bs * dctFrac ; k++)
				x_dct[c][n * bs + k] = x[k] / (bs << 1);

		}

	//convert vector<vector<double>> to vector<int>
	//x_dct_int[0] is the left channel
	//x_dct_int[1] is the right channel
	//need vector<int> with [x_dct_int[0][0], x_dct_int[1][0], x_dct_int[0][1], x_dct_int[1][1], ...]
	vector<int> x_dct_int;
	int min_value = 0, max_value = 0;
	for(size_t n = 0 ; n < nBlocks ; n++)
		for(size_t c = 0 ; c < nChannels ; c++) {
			x_dct_int.push_back(x_dct[c][n]);
			//cout << "DOUBLE:"<< x_dct[c][n] << "			INT:" << (int)x_dct[c][n]<<"				SHORT:"<<(short)x_dct[c][n]<< endl;
			if((int)x_dct[c][n] < min_value){
				min_value = x_dct[c][n];
			}
			if((int)x_dct[c][n] > max_value){
				max_value = x_dct[c][n];
			}
		}

	//print min and max value and bits needed to represent them
	cout << "min_value: " << min_value << endl;
	cout << "bits needed to represent min_value: " << ceil(log2(abs(min_value))) << endl;
	cout << "max_value: " << max_value << endl;
	cout << "bits needed to represent max_value: " << ceil(log2(max_value)) << endl;
	cout << "bits needded to represent [min_value, max_value]: " << ((ceil(log2(abs(min_value)))>ceil(log2(max_value))) ? ceil(log2(abs(min_value)))+1 : ceil(log2(max_value))+1) << endl;
	cout << "max bin: " << bitset<13>(max_value) << "\n";
	cout << "min bin: " << bitset<13>(min_value) << "\n";
	//needed 13 bits so represent the max and min values
	const ulong n_bits = 13;

	//use BitStream encoder to write to file, need to convert vector<int> to vector<char>
	vector<char> x_dct_char;
	for(size_t i = 0; i < x_dct_int.size(); i++){
		bitset<n_bits> tmp(x_dct_int[i]);
		string tmp_str = tmp.to_string();
		//cout << "ORIGINAL INT:	" << x_dct_int[i] << endl;
		//cout << "ORIGINAL BIN:	" << tmp_str << endl;
		//iterate through the bitset and add each char to the vector
		//cout << "ADDED:	";
		for(size_t j = 0; j < tmp_str.size(); j++){
			x_dct_char.push_back(tmp_str[j]);
			//cout << tmp_str[j];
		}
		//cout << endl;
	}

	//write x_dc_char to file
	ofstream outfile;
	outfile.open("directDCT.txt", ios::out | ios::binary);
	for(size_t i = 0; i < x_dct_char.size(); i++){
		outfile << x_dct_char[i];
	}
	outfile.close();

	//read DCT values and encode them
	cout << "Reading DCT values from file..." << endl;
	BitStream bsOut("directDCT.txt", 'r');	//read from file
	bsOut.encoder("encodedDCT.txt", 8);		//encode bin to chars
	
	//read encoded DCT values and decode it
	cout << "Reading encoded DCT values from file..." << endl;
	BitStream bsIn("encodedDCT.txt", 'r');	//read encoded data from file
	bsIn.decoder("decodedDCT.txt");			//decode chars to bin

	//read decoded DCT values and convert it to vector<int>
	cout << "Reading decoded DCT values from file..." << endl;
	ifstream infile;
	infile.open("decodedDCT.txt", ios::in | ios::binary);
	vector<int> x_dct_int_decoded;
	while(!infile.eof()){
		//read 13 bits at a time and convert to int
		string tmp_str;
		for(size_t i = 0; i < n_bits; i++){
			char tmp_char;
			infile >> tmp_char;
			tmp_str += tmp_char;
		}
		//cout << "TMP STR: "<< tmp_str << endl;
		int tmp_int;
		//if string starts with 1, then it is negative
		if(tmp_str[0] == '1'){
			tmp_str = findTwoscomplement(tmp_str);
			//string to int and negate
			tmp_int = -(stoi(tmp_str, nullptr, 2));
		}
		else{
			//string to int
			tmp_int = stoi(tmp_str, nullptr, 2);
		}
		//cout << "VALUE:	"<< tmp_int << endl;
		//cout << "----------------------------------------" << endl;
		x_dct_int_decoded.push_back(tmp_int);
	}

	//compare x_dct_int and x_dct_int_decoded
	cout << "Comparing original and decoded DCT values..." << endl;
	for(size_t i = 0; i < x_dct_int.size(); i++){
		if(x_dct_int[i] != x_dct_int_decoded[i]){
			cout << "ERROR: original and decoded DCT values do not match" << endl;
			return 0;
		}
	}
	cout << "SUCCESS: original and decoded DCT values match" << endl;

	//convert x_dct_int_decoded to vector<vector<double>>
	//vector<vector<double>> has the same structure as x_dct
	vector<vector<double>> x_dct_decoded(nChannels, vector<double>(nBlocks * bs));
	for(size_t b = 0; b < nBlocks; b++){
		for(size_t c = 0; c < nChannels; c++){
			x_dct_decoded[c][b] = x_dct_int_decoded[c + b*nChannels];
		}
	}

	//compare x_dct and x_dct_decoded
	cout << "Checking structure transformation" << endl;
	for(size_t c = 0; c < nChannels; c++){
		for(size_t n = 0; n < bs; n++){
			if((int)x_dct[c][n] != x_dct_decoded[c][n]){
				cout << "ERROR: x_dct and x_dct_decoded do not match" << endl;
			}
		}
	}
	cout << "SUCCESS: vector<int> to vector<vector<double>>" << endl;

	// Inverse DCT
	cout << "Inverse DCT..." << endl;
	vector<double> x_idct(bs);
	fftw_plan plan_i = fftw_plan_r2r_1d(bs, x.data(), x.data(), FFTW_REDFT01, FFTW_ESTIMATE);
	for(size_t n = 0 ; n < nBlocks ; n++)
		for(size_t c = 0 ; c < nChannels ; c++) {
			for(size_t k = 0 ; k < bs ; k++)
				x[k] = x_dct[c][n * bs + k];

			fftw_execute(plan_i);
			for(size_t k = 0 ; k < bs ; k++)
				samples[(n * bs + k) * nChannels + c] = static_cast<short>(round(x[k]));

		}

	sfhOut.writef(samples.data(), sfhIn.frames());
	return 0;
}

string findTwoscomplement(string str)
{
    int n = str.length();
 
    // Traverse the string to get first '1' from
    // the last of string
    int i;
    for (i = n-1 ; i >= 0 ; i--)
        if (str[i] == '1')
            break;
 
    // If there exists no '1' concatenate 1 at the
    // starting of string
    if (i == -1)
        return '1' + str;
 
    // Continue traversal after the position of
    // first '1'
    for (int k = i-1 ; k >= 0; k--)
    {
        //Just flip the values
        if (str[k] == '1')
            str[k] = '0';
        else
            str[k] = '1';
    }
 
    // return the modified string
    return str;
}

