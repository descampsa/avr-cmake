# Template for a AVR project

cmake_minimum_required(VERSION 2.8)

set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/generic-avr-gcc.cmake")

# Name your project
project(EXAMPLE)

#device dependent config, here for arduino uno on linux
set(AVR_MCU atmega328p)
set(MCU_FREQ 16000000UL)
set(AVR_PROGRAMMER arduino)
set(AVR_PROGRAMMER_PORT /dev/ttyACM0)

avr_add_executable(example example.cpp)

