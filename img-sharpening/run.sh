nasm -f elf64 filter.asm
ld -m elf_x86_64 filter.o -o filter
rm filter.o
./filter