# PIC16F627A Asynchronous Counter Using Assembly.

## Get it running 
1. Install MPLAB (IDE and Builder) and Proteus 7 (Microcontroller Visual Simulator).
2. (Optional) Build a new .HEX file in MPLAB using the source code. (Or use already built file by me.)
3. Open the Proteus file in the Proteus directory.
4. Double click the Microcontroller and load the previously mentioned .hex file.
5. Click the small run button 

## How it Works
The program checks for pulses on the respective pins, and then either increments or decrements the value on the 7 seg display.
The goal is for the display to be able to count from 0 to 9, and 9 to 0, while overlapping back to 0 if incremented from 9, and back down to 0 if decremented from 9.
==NOTE:== A small delay is added to wait about a quarter of a second before pressing the buttons.

#### Setup 
Inputs: RA0 and RA1 are pulsed for inputs from two individual buttons.
Outputs: RB0 - RB6 are used as outputs for a 7-Seg-Display.
