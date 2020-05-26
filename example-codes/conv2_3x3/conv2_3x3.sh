nasm -f elf64 conv2_3x3.asm -o conv2_3x3.o
ld -m elf_x86_64 conv2_3x3.o -o conv2_3x3
rm conv2_3x3.o
./conv2_3x3