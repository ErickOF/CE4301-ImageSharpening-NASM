nasm plt.asm -f elf64 -o plt.o
gcc plt.o -no-pie -o plt
rm plt.o
./plt