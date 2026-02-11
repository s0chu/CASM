nasm -f elf64 main.asm -o main.o  -gdwarf
nasm -f elf64 string.asm -o string.o -gdwarf
nasm -f elf64 avl.asm -o avl.o -gdwarf 
nasm -f elf64 stress.asm -o stress.o -gdwarf
ld -no-pie main.o string.o avl.o stress.o -o main -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 
./main 
rm main.o string.o avl.o stress.o 