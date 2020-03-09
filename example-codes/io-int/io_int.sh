nasm -f elf64 io_int.asm -o io_int.o
ld -m elf_x86_64 io_int.o -o io_int
rm io_int.o
./io_int