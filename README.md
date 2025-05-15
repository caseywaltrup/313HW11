# 313HW11
To compile and execute:
  nasm -f elf32 -g -F dwarf -o hw11translate2Ascii.o hw11translate2Ascii.asm
  ld -m elf_i386 -o hw11translate2Ascii hw11translate2Ascii.o
  ./hw11translate2Ascii
Expected output:
  83 6A 88 DE 9A C3 54 9A

This program reads a sequence of 8 bytes, converts each byte into its 2-digit hexadecimal representation, and prints the resulting ASCII string onto the screen
