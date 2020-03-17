nasm -f elf64 asm/filter.asm
ld -m elf_x86_64 asm/filter.o -o asm/filter
rm asm/filter.o
python3 main.py
rm asm/filter