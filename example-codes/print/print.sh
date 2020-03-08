nasm -f elf64 print.asm -o print.o
ld -m elf_x86_64 print.o -o print
rm print.o
./print