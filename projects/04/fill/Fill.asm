// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

(INIT)  // Initialize variables for loop. R0 = position, R1 = end of range.
@SCREEN
D=A
@R0
M=D-1   // Initialize R0 to SCREEN[0]-1. (First iteration will increment by 1.)
@8191
D=D+A   // Compute SCREEN[0] - 1 + 8192 (size of screen) - 1.
@R1
M=D     // Initialize R1 to that value (end of range).

(LOOP)  // Begin main program loop. Start by reading keyboard.
@KBD
D=M
@BLACK  // If a key is pressed, jump to BLACK.
D;JNE

(WHITE) // Else no key is pressed, handle WHITE.
@0
D=A     // Select white (0b0000000000000000).
@WRITE
0;JMP

(BLACK)
@0
D=!A    // Select black (0b1111111111111111).

(WRITE)
@R0
M=M+1   // Increment R0 before using it (saves a few steps).
A=M     // Load screen position from R0.
M=D     // Write word (white or black) to that position.
D=A     // Save current address for comparison.
@R1     // Load R1 (end of range).
D=D-M   // Compare current address and end of range.
@LOOP
D;JNE   // If not at end of range, loop again.

(RESET) // Else we are at end of range, reset R0.
@SCREEN
D=A
@R0
M=D-1   // Reset R0 to SCREEN[0]-1. (Next iteration will increment by 1.)

@LOOP
0;JMP   // Loop forever
