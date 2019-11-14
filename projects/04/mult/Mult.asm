// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
// R3 will be used to keep track of negative values.

(START)
@R2         // Initialize result to 0.
M=0
@R0         // If R0 is zero, jump to ZERO routine.
D=M
@ZERO
D;JEQ
@R1         // Else if R1 is zero, jump to ZERO routine.
D=M
@ZERO
D;JEQ
@NONZERO    // Else neither value is zero. Jump to NONZERO.
0;JMP

(ZERO)      // Handle case when multiplying by zero.
@R2         // Set result to 0.
M=0
@END        // Jump to end.
0;JMP

(NONZERO)   // R0 and R1 are nonzero. Now check negativity.
@R0         // If R0 isn't negative, skip to next check.
D=M
@CHECKNEXT
D;JGE
@R0         // R0 is negative. Negate it (two's complement).
M=!M
M=M+1
@R3         // Increment R3 (counts negative values).
M=M+1

(CHECKNEXT) // Checked R0, now check negativity of R1.
@R1         // If R1 isn't negative, skip to main loop.
D=M
@LOOP
D;JGE
@R1         // R1 is negative. Negate it.
M=!M
M=M+1
@R3         // Increment R3 (counts negative values).
M=M+1

(LOOP)      // Main multiplication loop.
@R1         // Add R1 to R2, store in R2.
D=M
@R2
M=D+M
@R0         // Decrement R0.
M=M-1
D=M         // Loop while R0 is greater than zero.
@LOOP
D;JGT
@R3         // If R3 is 0, there were no negative values. Jump to end.
D=M
@END
D;JEQ

(FIXSIGN)   // Handle case with one or more negative values.
@R2         // Negate R2 (two's complement).
M=!M
M=M+1
@R3         // Decrement R3. Loop while greater than 0.
M=M-1
D=M
@FIXSIGN
D;JGT

(END)       // End of program. Loop forever.
@END
0;JMP
