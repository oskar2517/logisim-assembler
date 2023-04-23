# Logisim Assembler
Assembler I wrote to work in conjunction with my [microcode compiler](https://github.com/oskar2517/microcode-compiler). It emits a hex dump in the `v3.0 hex words plain` format used by [Logisim Evolution](https://github.com/logisim-evolution/logisim-evolution).

For the assembler to work properly, the microcode source file used must contain an assembler config section with the following values:
```
assemblerConfig {
    instructionWidth: 8;
    opCodeWidth: 4;
}
```
`instructionWidth` determines the width of an instruction in bits. `opCodeWidth` specifies how many bits of `instructionWidth` are used to store the opcode. Note that it is currently not possible to create instructions which accept more than one immediate value. Using the configuration above, an instruction would look like this:
```
oooo iiii
^^^^ ^^^^
op   immediate
```

Hex dumps generated by my microcode compiler contain the mnemonics of all specified instructions in addition to the assembler configuration described above.
```
v3.0 hex words plain
# Generated by MCC (https://github.com/oskar2517/microcode-compiler)
# {"config":{"opCodeWidth":4,"instructionWidth":16,"opCodes":[{"address":0,"mnemonic":"lda"},{"address":1,"mnemonic":"add"},{"address":2,"mnemonic":"sub"},{"address":3,"mnemonic":"mul"},{"address":4,"mnemonic":"div"},{"address":5,"mnemonic":"mao"},{"address":6,"mnemonic":"cmp"},{"address":7,"mnemonic":"jmp"},{"address":8,"mnemonic":"brz"},{"address":9,"mnemonic":"brc"},{"address":10,"mnemonic":"hlt"}]}}
000000c0 00000010 00000410 00000004 00000240 00000010 00008010 00000008 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
...
``` 

## Example
A simple program that counts in alternation from 0 to 5 and 5 to 0. All instructions have to be present in the specified microcode hex dump.
```
// Programs start executing at the top
lda one
mao

inc: // Labels are an abstraction over addresses
    add one
    mao
    cmp five
    brz dec
    jmp inc

dec:
    sub one
    mao
    cmp zero
    brz inc
    jmp dec

zero:
    0

one:
    1

five:
    5
```

Generated binary code:
```
v3.0 hex words plain
000d
5000
100d
5000
600e
8007
7002
200d
5000
600c
8002
7007
0000
0001
0005
```

## Download
The latest release can be downloaded fom the [releases tab](https://github.com/oskar2517/logisim-assembler/releases). Alternatively, binaries compiled from the most reason commit can be downloaded from the [actions tab](https://github.com/oskar2517/logisim-assembler/actions). 

## Usage
In addition to an input and output path for the program, the path to the microcode hex dump used must be specified. The command used to run this program may look like this `asm -i my_program.txt -o my_program.hex -mc microcode.hex`.
```
Usage: asm [-options]

Options:
[--help | -h]              : Print this message
[--input | -i] <path>      : Specify an input file
[--output | -o] <path>     : Specify an output file
[--microcode | -mc] <path> : Specify a microcode hex file
```
