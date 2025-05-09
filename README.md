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

Project List

1) Switch Driver code for a LED
2) PLL generation via the Quartus IP wizards
3) PWM LED
4) LED shift registers
5) Debouning Asynchronous inputs
6) 4 digit counter using 7-segment display
7) UART Transmitter/Reciever
8) Baud Clock Generator
9) RS232
10) Shift register
11) Serializer


Additional projects will be updated whenever I'm sane and not sleepy ;) 
