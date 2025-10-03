nasm -f elf64 main.asm -o main.o  
nasm -f elf64 string.asm -o string.o
nasm -f elf64 avl.asm -o avl.o 
ld main.o string.o avl.o -o main -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 
./main 
rm main.o string.o avl.o main