nasm -f elf filter.asm
ld -m elf_i386 filter.o -o filter
rm filter.o
./filter