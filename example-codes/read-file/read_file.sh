nasm -f elf64 read_file.asm -o read_file.o
ld -m elf_x86_64 read_file.o -o read_file
rm read_file.o
./read_file