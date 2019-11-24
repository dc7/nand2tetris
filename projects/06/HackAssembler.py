#!/usr/bin/env python

import re
import sys

symbol_table = {
    "SP":       0,
    "LCL":      1,
    "ARG":      2,
    "THIS":     3,
    "THAT":     4,
    "R0":       0,
    "R1":       1,
    "R2":       2,
    "R3":       3,
    "R4":       4,
    "R5":       5,
    "R6":       6,
    "R7":       7,
    "R8":       8,
    "R9":       9,
    "R10":      10,
    "R11":      11,
    "R12":      12,
    "R13":      13,
    "R14":      14,
    "R15":      15,
    "SCREEN":   16384,
    "KBD":      24576
}
dests = {
    None:   "000",
    "M":    "001",
    "D":    "010",
    "MD":   "011",
    "A":    "100",
    "AM":   "101",
    "AD":   "110",
    "AMD":  "111"
}
jumps = {
    None:   "000",
    "JGT":  "001",
    "JEQ":  "010",
    "JGE":  "011",
    "JLT":  "100",
    "JNE":  "101",
    "JLE":  "110",
    "JMP":  "111"
}
comps = {
    "0":    "0101010",
    "1":    "0111111",
    "-1":   "0111010",
    "D":    "0001100",
    "A":    "0110000",
    "!D":   "0001101",
    "!A":   "0110001",
    "-D":   "0001111",
    "-A":   "0110011",
    "D+1":  "0011111",
    "A+1":  "0110111",
    "D-1":  "0001110",
    "A-1":  "0110010",
    "D+A":  "0000010",
    "D-A":  "0010011",
    "A-D":  "0000111",
    "D&A":  "0000000",
    "D|A":  "0010101",
    "M":    "1110000",
    "!M":   "1110001",
    "-M":   "1110011",
    "M+1":  "1110111",
    "M-1":  "1110010",
    "D+M":  "1000010",
    "D-M":  "1010011",
    "M-D":  "1000111",
    "D&M":  "1000000",
    "D|M":  "1010101"
}

class Address(object):
    next_symbol = 16
    def __init__(self, value):
        self.value = value
    def __repr__(self):
        return "0" + format(self.get_value(), "015b")[0:15]
    def get_value(self):
        if self.value.isdigit():
            return int(self.value)
        if self.value not in symbol_table:
            symbol_table[self.value] = Address.next_symbol
            Address.next_symbol += 1
        return int(symbol_table[self.value])

class Computation(object):
    def __init__(self, dest, comp, jump):
        self.dest = dest
        self.comp = comp
        self.jump = jump
    def __repr__(self):
        return "111" + comps[self.comp] + dests[self.dest] + jumps[self.jump]

instructions = []
line_number = 0
for line in sys.stdin:
    line = re.sub("\s+|//.*", "", line)
    if not line:
        continue
    if "@" == line[0]:
        instructions.append(Address(line[1:]))
        line_number += 1
    elif "(" == line[0]:
        symbol_table[line[1:-1]] = line_number
    else:
        match = re.match(
            "(?:(?P<dest>\w+)=)?(?P<comp>[-!&+|\w]+)(?:;(?P<jump>\w+))?", line)
        instructions.append(Computation(match.group("dest"),
            match.group("comp"), match.group("jump")))
        line_number += 1
for instruction in instructions:
    print(instruction)
