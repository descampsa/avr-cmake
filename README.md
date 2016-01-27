This is a minimal cmake project to compile an arduino program using avr-gcc/avrdude toolchain.
It is composed of a cmake toolchain file (generic-avr-gcc.cmake), and a cmake module to find and compile arduino libraries.
An example CMakeLists.txt demonstrates how to use it to compile and upload a simple arduino application (led blink), with or without arduino libraries.

Basic usage:

```sh
$ mkdir build
$ cd build
$ cmake ..
$ #example without arduino libraries
$ make example #compile example
$ make upload_example #upload to arduino
$ #example with arduino libraries
$ make example_arduino #compile example
$ make upload_example_arduino #upload to arduino
```

You may need to edit CMakeLists.txt if you use another arduino than Uno or if it use another port than /dev/ttyACM0.
The arduino LED should blink once per second if everything went right.

