# Template for a AVR project

cmake_minimum_required(VERSION 2.8)

set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/generic-avr-gcc.cmake")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}")

# Name your project
project(EXAMPLE)

#device dependent config, here for arduino uno on linux
set(AVR_MCU atmega328p)
set(MCU_FREQ 16000000UL)
set(AVR_PROGRAMMER arduino)
set(AVR_PROGRAMMER_PORT /dev/ttyACM0)
set(PROGRAM_EEPROM False)

set(${Arduino_VARIANT} standard)
find_package(Arduino REQUIRED)

#message(WARNING "TEST ${Arduino_INCLUDE_DIRS}")
include_directories(${Arduino_INCLUDE_DIRS})

avr_add_executable(example example.cpp)

avr_add_executable(example_arduino example_arduino.cpp)
target_link_libraries(example_arduino.elf core_arduino)

