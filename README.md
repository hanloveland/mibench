MiBench
=======

This is the original MiBench code as downloaded from http://www.eecs.umich.edu/mibench/index.html.

The version modified for embedded targets and running automtically is in the
embedded branch

Automotive 
- basicmath: ./basicmath_large
- bitcount: ./bitcnts 1125000
- qsort: ./qsort_large input_large.dat
- susan: ./susan input_large.pgm output_large.smoothing.pgm -s (or output_large.edges.pgm -e or  output_large.corners.pgm -c)

consumer
- jpeg: ./jpeg-6a/cjpeg -dct int -progressive -opt -outfile output_large_encode.jpeg input_large.ppm
- typeset: ./lout-3.24/lout -I lout-3.24/include -D lout-3.24/data -F lout-3.24/font -C lout-3.24/maps -H lout-3.24/hyph large.lout > output_large.ps

Security 
- blowfish: ./bf e input_large.asc output_large.enc 1234567890abcdeffedcba0987654321
- rijndael: ./rijndael input_large.asc output_large.enc e 1234567890abcdeffedcba09876543211234567890abcdeffedcba0987654321
- sha: ./sha input_large.asc > output_large.txt

Network
- dijkstra: ./dijkstra_large input.dat
- patricia: ./patricia large.udp

Telecomm
- adpcm: ./bin/rawcaudio < data/large.pcm > output_large.adpc
- CRC32: ./crc ../adpcm/data/large.pc
- FFT: ./fft 8 32768
- gsm: ./bin/toast -fps -c data/large.au > output_large.encode.gsm

