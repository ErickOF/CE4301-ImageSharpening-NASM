nasm -f elf input.asm -o input.o
ld -m elf_i386 input.o -o input
rm input.o
./input