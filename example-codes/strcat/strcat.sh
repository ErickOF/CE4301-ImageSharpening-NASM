nasm -f elf64 strcat.asm
ld -m elf_x86_64 strcat.o -o strcat
rm strcat.o
./strcat