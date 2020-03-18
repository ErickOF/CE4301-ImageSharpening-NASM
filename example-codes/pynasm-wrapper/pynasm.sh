nasm -f elf64 main.asm -o main.o
#ld -m elf_x86_64 main.o -o main
python call.py build_ext --inplace
python -c "import pynasm;pynasm.function()"