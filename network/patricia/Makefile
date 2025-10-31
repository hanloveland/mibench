# sudo apt install libtirpc-dev 
patricia: patricia.c patricia_test.c
	gcc -static patricia.c patricia_test.c -O3 -o patricia -I/usr/include/tirpc

clean:
	rm -rf patricia output*
