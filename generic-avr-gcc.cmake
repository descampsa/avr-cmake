#toolchain cmake file for avr-gcc/avrdude toolchain

# needs the following variables:
# AVR_MCU : mcu type (eg atmega328p)
# MCU_FREQ : clock frequency (defines F_CPU)
# AVR_PROGRAMMER : programmer type for avrdude
# AVR_PROGRAMMER_PORT : programmer port for avrdude (OS specific)
# PROGRAM_EEPROM : enable eeprom programming (doesn't work on arduino)

#generic avr flags
set(AVR_CFLAGS "-ffunction-sections -fdata-sections" CACHE STRING "AVR compilation flags")
set(AVR_LFLAGS "-Wl,--relax,--gc-sections" CACHE STRING "AVR link flags")

#find toolchain programs
find_program(AVR-GCC avr-gcc)
find_program(AVR-GXX avr-g++)
find_program(AVR-OBJCOPY avr-objcopy)
find_program(AVR-SIZE avr-size)
find_program(AVRDUDE avrdude)

#define toolchain
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER ${AVR-GCC})
set(CMAKE_CXX_COMPILER ${AVR-GXX})

#Release by default, because optimization 
#is needed for delay functions to work properly
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
endif(NOT CMAKE_BUILD_TYPE)


function(avr_add_executable_compilation EXECUTABLE)
	
	set(EXECUTABLE_ELF "${EXECUTABLE}.elf")
	set(EXECUTABLE_HEX "${EXECUTABLE}.hex")
	if(PROGRAM_EEPROM)
		set(EXECUTABLE_EEPROM "${EXECUTABLE}_eeprom.hex")
	endif(PROGRAM_EEPROM)

	# main target for the executable depends of hex and eeprom files
	if(PROGRAM_EEPROM)
		add_custom_target(${EXECUTABLE} ALL 
			DEPENDS ${EXECUTABLE_HEX} ${EXECUTABLE_EEPROM})
	else(PROGRAM_EEPROM)
		add_custom_target(${EXECUTABLE} ALL 
			DEPENDS ${EXECUTABLE_HEX} ${EXECUTABLE_EEPROM})
	endif(PROGRAM_EEPROM)

	# compile and link elf file
	add_executable(${EXECUTABLE_ELF} ${ARGN})
	set_target_properties(${EXECUTABLE_ELF} PROPERTIES 
		COMPILE_FLAGS "-mmcu=${AVR_MCU} -DF_CPU=${MCU_FREQ} ${AVR_CFLAGS}"
		LINK_FLAGS "-mmcu=${AVR_MCU} ${AVR_LFLAGS}")

	# rule for program hex file
	add_custom_command(OUTPUT ${EXECUTABLE_HEX} 
		COMMAND ${AVR-OBJCOPY} -j .text -j .data -O ihex ${EXECUTABLE_ELF} ${EXECUTABLE_HEX}
		DEPENDS ${EXECUTABLE_ELF})

	# rule for eeprom hex file
	if(PROGRAM_EEPROM)
		add_custom_command(OUTPUT ${EXECUTABLE_EEPROM}
			COMMAND ${AVR-OBJCOPY} -j .eeprom --change-section-lma .eeprom=0 -O ihex ${EXECUTABLE_ELF} ${EXECUTABLE_EEPROM}
			DEPENDS ${EXECUTABLE_ELF})
	endif(PROGRAM_EEPROM)

	# display size info after compilation
	add_custom_command(TARGET ${EXECUTABLE} POST_BUILD
		COMMAND ${AVR-SIZE} -C --mcu=${AVR_MCU} ${EXECUTABLE_ELF})
endfunction(avr_add_executable_compilation)

function(avr_add_executable_upload ${EXECUTABLE})
	if(AVR_PROGRAMMER_BAUDRATE)
		set(AVR_PROGRAMMER_OPTIONS "-b ${AVR_PROGRAMMER_BAUDRATE}")
	endif(AVR_PROGRAMMER_BAUDRATE)
	
	# upload target
	if(PROGRAM_EEPROM)
		add_custom_target(upload_${EXECUTABLE} 
			COMMAND ${AVRDUDE} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_PROGRAMMER_PORT} ${AVR_PROGRAMMER_OPTIONS} -U flash:w:${EXECUTABLE}.hex -U eeprom:w:${EXECUTABLE}_eeprom.hex
			DEPENDS ${EXECUTABLE})
	else(PROGRAM_EEPROM)
		add_custom_target(upload_${EXECUTABLE} 
			COMMAND ${AVRDUDE} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_PROGRAMMER_PORT} ${AVR_PROGRAMMER_OPTIONS} -U flash:w:${EXECUTABLE}.hex
			DEPENDS ${EXECUTABLE})
	endif(PROGRAM_EEPROM)
endfunction(avr_add_executable_upload)

function(avr_add_executable EXECUTABLE)
	if(NOT AVR_MCU)
		message(FATAL_ERROR "AVR_MCU not defined")
	endif(NOT AVR_MCU)
	avr_add_executable_compilation(${EXECUTABLE} ${ARGN})
	if(AVR_PROGRAMMER AND AVR_PROGRAMMER_PORT)
		avr_add_executable_upload(${EXECUTABLE})
	else(AVR_PROGRAMMER AND AVR_PROGRAMMER_PORT)
		message(WARNING "Programmer not defined, upload target is not created")
	endif(AVR_PROGRAMMER AND AVR_PROGRAMMER_PORT)
endfunction(avr_add_executable)

function(avr_add_library LIBRARY)
	if(NOT AVR_MCU)
		message(FATAL_ERROR "AVR_MCU not defined")
	endif(NOT AVR_MCU)
	if(ARGV1 EQUAL SHARED)
		message(FATAL_ERROR "shared libraries are not supported")
	endif(ARGV1 EQUAL SHARED)
	add_library(${LIBRARY} ${ARGN})
	set_target_properties(${LIBRARY} PROPERTIES 
		COMPILE_FLAGS "-mmcu=${AVR_MCU} -DF_CPU=${MCU_FREQ} ${AVR_CFLAGS}"
		LINK_FLAGS "-mmcu=${AVR_MCU} ${AVR_LFLAGS}")
endfunction(avr_add_library LIBRARY)

function(avr_target_link_libraries TARGET)
	target_link_libraries(${TARGET}.elf ${ARGN})
endfunction(avr_target_link_libraries TARGET)


