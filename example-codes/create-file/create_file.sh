nasm -f elf64 create_file.asm -o create_file.o
ld -m elf_x86_64 create_file.o -o create_file
rm create_file.o
./create_file