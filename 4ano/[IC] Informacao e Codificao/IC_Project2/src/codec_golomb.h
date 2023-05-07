#ifndef CODEC_GOLOMB_H
#define CODEC_GOLOMB_H

#include <bitset>
#include <stdio.h>
#include <stdlib.h>
#include <bits/stdc++.h>
#include <fstream>
#include <sndfile.hh>

#include "golomb.h"

using namespace std;

constexpr size_t FRAMES_BUFFER_SIZE = 65536; // Buffer for reading/writing frames

class golomb_codec{
    private:
        golomb codec_alg;
        char buffer = 0;
        int count=0, order, lossless, cut_n_bits;
        uint32_t x, y;

        int write_wav_file(const char* fileOut, vector<short> &samples, int format, int samplerate, int num_channels){
            //create output file
            SndfileHandle sfhOut(fileOut, SFM_WRITE, format, num_channels, samplerate);
            
            if(sfhOut.error()){
                cerr << "Error: invalid output file\n";
                return 1;
            }
            uint32_t tmp = sfhOut.write(samples.data(), samples.size());
            cout << "Samples written: " << tmp << endl;
            return 0;
        }
        
        int write_bin_to_file(const char* fileOut, string encoded){
            ofstream filew(fileOut,ios::out | ios::binary);
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
            if (avg == 0) return 1;
            double alfa = avg / (avg + 1);
            return ceil(-1/log2(alfa));
        }

    public:
        golomb_codec(int n_order, int x_in, int y_in, int lossless_on, int cut_bits): codec_alg() { order = n_order; x = x_in; y = y_in; lossless = lossless_on; cut_n_bits = cut_bits; };
        golomb_codec(){
            this->codec_alg = golomb();
            this->order = 3;
            this->x = 2000;
            this->y = 1750;
            this->lossless=1;
            this->cut_n_bits=0;
        }

        int encode_wav_file(const char* fileIn, const char* fileOut){
            clock_t time_req;                           //for time measurement
            time_req = clock();                         //start time measurement

            vector<short> all_samples;  //vector to store all samples
            uint32_t samples_size = 0;  //number of samples

            SndfileHandle sfhIn { fileIn };
            if(sfhIn.error()) {
		        cerr << "Error: invalid input file\n";
		        return {};
            }

            if((sfhIn.format() & SF_FORMAT_TYPEMASK) != SF_FORMAT_WAV) {
		        cerr << "Error: file is not in WAV format\n";
		        return {};
            }

	        if((sfhIn.format() & SF_FORMAT_SUBMASK) != SF_FORMAT_PCM_16) {
		        cerr << "Error: file is not in PCM_16 format\n";
		        return {};
	        }

            size_t nFrames;
            vector<short> tmp_samples(FRAMES_BUFFER_SIZE * sfhIn.channels());

            int num_channels = sfhIn.channels();

            while((nFrames = sfhIn.readf(tmp_samples.data(), FRAMES_BUFFER_SIZE))) {
                tmp_samples.resize(nFrames * sfhIn.channels());
                samples_size += tmp_samples.size();

                //add samples to all_samples
                for( auto &sample : tmp_samples){
                    if(lossless){
                        all_samples.push_back(sample);
                    }
                    else{
                        //cut n bits
                        all_samples.push_back( (sample >> cut_n_bits) );
                    }
                }
                
                //clear tmp_samples
                vector<short>().swap(tmp_samples);
                //resize samples
                tmp_samples.resize(FRAMES_BUFFER_SIZE * sfhIn.channels());

            }

            //cout << "SIZE: " << samples_size << endl;

            vector<uint32_t> mapped_samples;            //mapp predicted values
            mapped_samples.resize(samples_size);        //resize vector to fit all mapped error values

            //FRIST ORDER*NUM_CHANNELS SAMPLES
            uint32_t med = 0;
            for(uint32_t i=0; i<order*num_channels; i++){
                //calculate errors  aka error_values[i] = all_samples[i] - 0              
                //map errors
                if(all_samples[i] < 0){
                    mapped_samples[i] = (all_samples[i] * -2);
                } else {
                    mapped_samples[i] = (all_samples[i] * 2) + 1;
                }
                med += mapped_samples[i];
            }
            //calculate initial m
            codec_alg.change_m_encode(med/(order*num_channels));

            //create header: initial m (32 bits), order (2 bits), x (32 bits), y (32 bits), lossless (1 bit), cut_n_bits (4 bits), samplerate (32 bits), format (32 bits), num_channels (3 bits), num_samples (32 bits)
            
            //print header values
            cout << "\nHEADER DATA:" << endl;
            cout << "M: " << codec_alg.get_m_encode() << endl;
            cout << "Order: " << order << endl;
            cout << "X: " << x << endl;
            cout << "Y: " << y << endl;
            cout << "Lossless: " << lossless << endl;
            cout << "Cut n bits: " << cut_n_bits << endl;
            cout << "Samplerate: " << sfhIn.samplerate() << endl;
            cout << "Format: " << sfhIn.format() << endl;
            cout << "Num channels: " << num_channels << endl;
            cout << "Num samples: " << samples_size << endl;

            string header = "";
            //initial m to bin string of 32 bits
            header += bitset<32>(codec_alg.get_m_encode()).to_string();
            //order to bin string of 2 bits
            header += bitset<2>(order).to_string();
            //x to bin string of 32 bits
            header += bitset<32>(x).to_string();
            //y to bin string of 32 bits
            header += bitset<32>(y).to_string();
            //lossless to bin string of 1 bit
            header += bitset<1>(lossless).to_string();
            //cut_n_bits to bin string of 4 bits
            header += bitset<4>(cut_n_bits).to_string();
            //samplerate to bin string of 32 bits
            header += bitset<32>((sfhIn.samplerate())).to_string();
            //format to bin string of 32 bits
            header += bitset<32>((sfhIn.format())).to_string();
            //num_channels to bin string of 3 bits
            header += bitset<3>(num_channels).to_string();
            //num_samples to bin string of 32 bits
            header += bitset<32>(samples_size).to_string();

            //string to store encoded data
            string encoded = header;

            //encode first order*channels samples
            for(uint32_t i=0; i<order*num_channels; i++){
                encoded += codec_alg.encode_number(mapped_samples[i], 0);
            }

            //FOR THE REST OF THE SAMPLES       
            long tmp_error = 0;  
            for(uint32_t i=order*num_channels; i<all_samples.size(); i++){
                //0 2 4 6 ... left channel and 1 3 5 7 ... right channel in case DUAL CHANNEL
                if(order == 3){
                    //xˆ(3)n = 3xn−1 − 3xn−2 + xn−3
                    tmp_error = all_samples[i] - ( (3*all_samples[i-num_channels]) - ( 3*all_samples[i-(2*num_channels)]) + (all_samples[i-(3*num_channels)]) );
                }else if(order == 2){
                    //xˆ(2)n = 2xn−1 − xn−2
                    tmp_error = all_samples[i] - ( (2*all_samples[i-num_channels]) - all_samples[i-(2*num_channels)] ); 
                }

                //map tmp_error
                if(tmp_error < 0){
                    mapped_samples[i] = (tmp_error * -2);
                } else {
                    mapped_samples[i] = (tmp_error * 2) + 1;
                }
                //encode mapped error
                encoded += codec_alg.encode_number(mapped_samples[i], 0);

                //update m to encode
                if(i % x == 0){ //every x samples  
                    med = 0;
                    for(uint32_t j=i - y; j<i; j++){ //calculate average of last y samples
                        med += mapped_samples[j];
                    }
                    codec_alg.change_m_encode(calc_m(med/y));
                }

            }

            //ERRORS CHECK
            //int error = 0;
            //print samples , error values and mapped error values
            // for(uint32_t i=0; i<mapped_samples.size(); i++){
            //     if(mapped_samples[i] == 1){
            //         //cout << "\033[1;31m( "<< i <<" ) SAMPLE: " << samples[i] << "\tERROR: " << calculate_prediction(order, samples[i-num_channels], samples[i-(2*num_channels)], samples[i-(3*num_channels)])<< "\tPREDICTED: " << predicted_values[i] << "\tMAPPED: \033[0m" << mapped_samples[i] << endl;
            //     }else if(mapped_samples[i] < 0){
            //         cout << "\033[1;31m( "<< i <<" ) SAMPLE: " << samples[i] << "\tPRED: " << calculate_prediction(order, samples[i-num_channels], samples[i-(2*num_channels)], samples[i-(3*num_channels)])<< "\tERROR: " << error_values[i] << "\tMAPPED: " << mapped_samples[i]<< "\033[0m" << endl;
            //         //print calculated error
            //         cout << "MATH.: "<< samples[i] << " - ((3*"<<samples[i-num_channels]<<") - (3*"<< samples[i-(2*num_channels)]<< ") + "<< samples[i-(3*num_channels)] << ")" << endl;
            //         error++;
            //     }else{
            //         //cout << "( "<< i <<" ) SAMPLE: " << samples[i] << "      \tPREDICTED: " << predicted_values[i] << "      \tMAPPED: " << mapped_samples[i] << endl;
            //     }
            // }
            // cout << "\033[1;31mERRORS: " << error << "\033[0m"<<endl;

            cout << "\nEncoded size in bytes: " << (double)encoded.size()/8 << endl;
            cout << "Encoded size in Mbytes: " << (double)encoded.size()/8/1024/1024 << endl;


            //write encoded string to file
            cout << "Writing to file: " << fileOut << endl;
            write_bin_to_file(fileOut, encoded);
            //print execution time
            time_req = clock() - time_req;
            cout << "Execution time: " << (float)time_req/CLOCKS_PER_SEC << " seconds\n" << endl;
            return 0;
        }

        int decode_to_wav(const char* fileIn, const char* fileOut){
            //start clock
            clock_t time_req;
            time_req = clock();

            //read encoded file
            string encoded = read_bin_from_file(fileIn);

            //print encoded size in bytes
            cout << "\nEncoded size in bytes: " << (double)encoded.size()/8 << endl;
            cout << "Encoded size in Mbytes: " << (double)encoded.size()/8/1024/1024 << endl;

            //read header to variables: initial m (32 bits), order (2 bits), x (32 bits), y (32 bits), lossless (1 bit), cut_n_bits (4 bits), samplerate (32 bits), format (32 bits), num_channels (3 bits), num_samples (32 bits)
            string header = encoded.substr(0, 32+2+32+32+1+4+32+32+3+32);
            //remove header from encoded string
            encoded = encoded.substr(32+2+32+32+1+4+32+32+3+32);

            //read initial m (32 bits) and convert to uint32_t
            uint32_t initial_m = bitset<32>(header.substr(0, 32)).to_ulong();
            this->codec_alg.change_m_decode(initial_m);
            //read order (2 bits) and convert to int 
            this->order = (int) bitset<2>(header.substr(32, 2)).to_ulong();
            //read x (32 bits) and convert to uint32_t
            this->x = (uint32_t) bitset<32>(header.substr(32+2, 32)).to_ulong();
            //read y (32 bits) and convert to uint32_t
            this-> y = (uint32_t) bitset<32>(header.substr(32+2+32, 32)).to_ulong();
            //read lossless (1 bit) and convert to int
            this->lossless = (int) bitset<1>(header.substr(32+2+32+32, 1)).to_ulong();
            //read cut_n_bits (4 bits) and convert to int
            this->cut_n_bits = (int) bitset<4>(header.substr(32+2+32+32+1, 4)).to_ulong();
            //read samplerate (32 bits) and convert to static_cast<int>
            int samplerate = { static_cast<int>(bitset<32>(header.substr(32+2+32+32+1+4, 32)).to_ulong())};
            //read format (32 bits) and convert to static_cast<int>
            int format = { static_cast<int>(bitset<32>(header.substr(32+2+32+32+1+4+32, 32)).to_ulong())};
            //read num_channels (3 bits) and convert to static_cast<int>
            int num_channels = { static_cast<int>(bitset<3>(header.substr(32+2+32+32+1+4+32+32, 3)).to_ulong())};
            //read num_samples (32 bits) and convert to uint32_t
            uint32_t num_samples = (uint32_t) bitset<32>(header.substr(32+2+32+32+1+4+32+32+3, 32)).to_ulong();

            //print header info
            cout << "\nHEADER DATA:" << endl;
            cout << "M: " << codec_alg.get_m_decode() << endl;
            cout << "Order: " << this->order << endl;
            cout << "X: " << this->x << endl;
            cout << "Y: " << this->y << endl;
            cout << "Lossless: " << this->lossless << endl;
            cout << "Cut n bits: " << this->cut_n_bits << endl;
            cout << "Samplerate: " << samplerate << endl;
            cout << "Format: " << format << endl;
            cout << "Num channels: " << num_channels << endl;
            cout << "Num samples: " << num_samples << endl;

            //pointer to encoded string
            char *p = &encoded[0];
            //pointer to encoded string end
            char *end = p + encoded.size();

            long * tmp_val = (long*)malloc(sizeof(long));    //pointer to store decoded number

            vector<uint32_t> mapped_samples;                //vector to store mapped samples
            vector<short> decoded_samples;                  //vector to store decoded samples

            uint32_t i=0;
            //FIRST ORDER*CHANNELS SAMPLES
            for(; i<order*num_channels; i++){
                //decode first order*channels samples
                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_samples.push_back(*tmp_val);
                //unmap decoded value
                if(*tmp_val % 2 == 0){
                    *tmp_val = ( (*tmp_val) / (-2));
                } else {
                    *tmp_val = ((*tmp_val - 1) / 2);
                }
                //add unmapped value to decoded_samples
                decoded_samples.push_back(*tmp_val);
            }

            //decode rest of samples
            uint32_t med=0;
            //check if pointer is not at the end of encoded string aka char '\0'
            while( *p != '\0' && p < end){
                //string decode_string(string bits, uint32_t *result_n, int mapping_on)
                p = codec_alg.decode_string(p, tmp_val, 0);
                mapped_samples.push_back(*tmp_val);
                //update m to decode
                if(i % x == 0){
                    med = 0;
                    for(uint32_t j=i - y; j<i; j++){
                        med += mapped_samples[j];
                    }
                    codec_alg.change_m_decode(calc_m(med/y));
                }

                //unmap decoded value
                if(*tmp_val % 2 == 0){
                    *tmp_val = ( (*tmp_val) / (-2));
                } else {
                    *tmp_val = ((*tmp_val - 1) / 2);
                }
                //add unmapped value to decoded_samples
                if(lossless){
                    if(order == 3){
                        //xˆ(3)n = 3xn−1 − 3xn−2 + xn−3
                        decoded_samples.push_back( ((short)(*tmp_val)) + ( (3*decoded_samples[i-num_channels]) - ( 3*decoded_samples[i-(2*num_channels)]) + (decoded_samples[i-(3*num_channels)]) ) );
                    }else if(order == 2){
                        //xˆ(2)n = 2xn−1 − xn−2
                        decoded_samples.push_back( ((short)(*tmp_val)) + ( (2*decoded_samples[i-num_channels]) - (decoded_samples[i-(2*num_channels)]) ) );
                    }
                }else{
                    if(order == 3){
                        //xˆ(3)n = 3xn−1 − 3xn−2 + xn−3
                        decoded_samples.push_back( ( ((short)(*tmp_val)) + ( (3*decoded_samples[i-num_channels]) - ( 3*decoded_samples[i-(2*num_channels)]) + (decoded_samples[i-(3*num_channels)])) ) );
                    }else if(order == 2){
                        //xˆ(2)n = 2xn−1 − xn−2
                        decoded_samples.push_back( ( ((short)(*tmp_val)) + ( (2*decoded_samples[i-num_channels]) - (decoded_samples[i-(2*num_channels)])) ) );
                    }
                }
                i++;
            }

            //uncut decoded samples
            if(!lossless){
                for(uint32_t i=0; i<decoded_samples.size(); i++){
                    decoded_samples[i] = decoded_samples[i] << cut_n_bits;
                }
            }

            //make decoded_samples size equal to num_samples
            decoded_samples.resize(num_samples);

            //write decoded samples to wav file
            cout << "Writing to file: " << fileOut << endl;
            write_wav_file(fileOut, decoded_samples, format, samplerate, num_channels);

            //print execution time
            time_req = clock() - time_req;
            cout << "Execution time: " << (float)time_req/CLOCKS_PER_SEC << " seconds" << endl;
            return 0;
        }

};

#endif