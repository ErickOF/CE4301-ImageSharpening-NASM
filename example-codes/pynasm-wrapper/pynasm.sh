nasm -f elf64 entry.asm -o entry.o
python3 setup.py build_ext --inplace
python3 main.py