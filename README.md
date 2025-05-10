# FPGA projects

This repository holds all the VHDL project codes tailored for the Cyclone IV Altera board, Device-EP4CE30F29C8
PS - Performing it on the Intel Quartus Prime 20.1 edition (cause the 24 edition downloads on Ubuntu was painful)

BTW I downloaded the Intel Quartus Prime software for FPGA dev 20.1 and here are the commands,

1) Download it off the official website
2) cd Downloads
3) sudo apt install libncurses5 libtinfo5 libxft2 libxext6 libXtst6 libnss3 libx11-6
4) DONT FORGET TO sudo apt update and sudo apt upgrade
5) chmod +x QuartusLiteSetup-20.1.0.711-linux.run
6) ./QuartusLiteSetup-20.1.0.711-linux.run
7) and you're good to go! (after like 100 more steps tho)


How did a project flow look like?
Well, you start off by creating a new file, write some vhdl code for whatever you're trying to do, then you hit compile, once done, you go for the pin planner where you match the GPIO pins, their driving voltages, bank numbers, and a lot more parameters then close it (it autosaves don't worry!). To top it off, you recompile, then go to programmer, since we adapt to the volatile method of programming the board, the blaster device has to be connected which will hold the binary file (assembler makes that for you) and we will flash that image onto the board, which will only run as long as you do not power cycle the board (cause then it would restart it to default), but what about a non volatile code you may ask? well, I am not that proficient to answer that completely, but I believe it would require an external configurable flash memeory to hold the image for post power cycled runs, but FPGAs generally do not contain these flash memory blocks, so If I find a better justification/method to non-volatile programming the board, I shall update here :D
Project List

NOTE : Some of the drivers will omit the consideration of debouncing 

1) Switch Driver code for a LED
2) State Machine driver code for multiple LEDs
3) PLL generation via the Quartus IP wizards
4) PWM LED
5) LED shift registers
6) Debouning Asynchronous inputs
7) 4 digit counter using 7-segment display
8) UART Transmitter/Reciever
9) Baud Clock Generator
10) RS232
11) Shift register
12) Serializer


Additional projects will be updated whenever I'm sane and not sleepy ;) 

PS using ../intelFPGA_lite/20.1/quartus/bin/quartus
PS using ../intelFPGA_lite/20.1/modelsim_ase/bin/vsim
