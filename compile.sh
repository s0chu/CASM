nasm -f elf64 main.asm -o main.o  
nasm -f elf64 string.asm -o string.o
nasm -f elf64 avl.asm -o avl.o 
nasm -f elf64 stress.asm -o stress.o
ld main.o string.o avl.o stress.o -o main -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 
./main abcd afasd fsad fas fas f
rm main.o string.o avl.o stress.o main