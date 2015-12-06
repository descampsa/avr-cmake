This is a minimal cmake project to compile an avr program using avr-gcc/avrdude toolchain.
It is composed of a cmake toolchain file (generic-avr-gcc.cmake), and a example CMakeLists.txt that demonstrate how to use it to compile and upload a simple arduino application.

Basic usage:

mkdir build
cd build
cmake ..
make example #compile
make upload_example #upload to arduino

You may need to edit CMakeLists.txt if you use another arduino than Uno or if it use another port than /dev/ttyACM0.
The arduino LED should blink once per second if everything went right.

Warning : for now, it has not been used much outside of this simple example context, and always on linux.
Remaining bugs and portability problems are probable.

