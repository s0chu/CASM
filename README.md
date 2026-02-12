# CASM

[cite_start]This app is a basic interactive AVL data structure in ASM x64 with minimal C function calling (`scanf`, `printf`, `malloc` and `free`)[cite: 1].

## Supported Commands

* [cite_start]`new(<variable_name>)`: Creates a new variable named `<variable_name>` with the default value of 0. The name must be a 19 character string max[cite: 1].
* [cite_start]`delete(<variable_name>)`: Deletes the variable named `<variable_name>` from the tree[cite: 1].
* [cite_start]`print(<variable_name>)`: Prints the value of the variable `<variable_name>`[cite: 1].
* [cite_start]`update(<variable_name> , <num>)`: Updates the value of `<variable_name>` to `<num>`[cite: 1].
    * [cite_start]**Note:** `num` is a 64 bit signed integer[cite: 2].
* [cite_start]`print_avl()`: Prints the nodes of the tree in-order[cite: 2].
    * [cite_start]**Format:** `left_child_address , right_child_address , height , key , value , address`[cite: 3].
    * [cite_start]**Note:** Addresses are 64/32 bit integers representing a memory address[cite: 4].
* [cite_start]`stress_test()`: Inserts 26^5 = 11 million nodes in the tree, with 5 characters length each[cite: 4].

## Getting Started

[cite_start]To begin the interaction you have to compile the program[cite: 4]:

```bash
sh compile.sh
```

* [cite_start]**Interaction protocol:** `command-response`[cite: 4].
* [cite_start]**To end the interaction:** Insert `EOF` (`ctrl + d`)[cite: 4].

## Performance Comparison (vs C++)

* [cite_start]**C++ version:** Runs in 14 seconds, using a map[cite: 4].
* [cite_start]**My version:** Runs in 8 seconds[cite: 4].

## Implementation Details

[cite_start]**Simple dynamic AVL implementation**[cite: 4].
[cite_start]It doesn't follow a standard implementation, but the same logic applies[cite: 5].

* [cite_start]**Logic:** On each return of a function you return the new root of the tree/subtree[cite: 8].
* [cite_start]**Memory Management:** The memory is allocated dynamically using `malloc` (from C) and deleted it with `free` (from C)[cite: 8].
* [cite_start]**Strings:** String handling is done via strings that terminates in a null character[cite: 9]. [cite_start]String manipulation functions are implemented with this logic in mind and are implemented in a bruteforce way like in C[cite: 10].

### Balancing Mechanism

1.  [cite_start]**Insertion:** On each insert, you check if it triggers a balancing mechanism (height levels between sons is > 1)[cite: 6].
2.  [cite_start]**Rotation:** The balancing mechanism consists of left/right rotations, maintaing inductively the difference between sons' levels <= 1[cite: 7].
3.  [cite_start]**Deletion:** Same thing happens, but the deleted nodes, gets swapped with the immediate node with a bigger key, so you delete the leaf node and replace the current node with that one[cite: 7]. [cite_start]Check again if it triggers the balancing mechanism[cite: 8].

## Code Tricks

[cite_start]Because ASM doesn't scream "natural coding", I have come up with the following strategy for easy looking code[cite: 10]:

### 1. Indentation in functions and statements

[cite_start]So a tab means that you are coding inside a function / scope (like `{}` in C/C++)[cite: 10].

**Example:**

```assembly
mov byte [rbp + i] , 97
for1:   cmp byte [rbp + i] , 122
        ja for1.fi 

        mov byte [rbp + j] , 97
        for2:   cmp byte [rbp + j] , 122 
                ja for2.fi         
                        [cite_start]mov al , [rbp + i] [cite: 11]
                     
                        mov bl , [rbp + j]
                        mov cl , [rbp + t]
                        [cite_start]mov dl , [rbp + r] [cite: 12]

                        ...
```

### 2. Labeling mechanism

[cite_start]NASM offers an interesting mechanism for labeling: **sublabels**[cite: 12]. [cite_start]So declaring a label `.name:` will belong to the nearest non sublabel (without a `.` at the beginning)[cite: 13].

[cite_start]So `if`'s and `for`'s can be simple coded like this[cite: 14]:

**If Statement:**

```assembly
if_num: (condition)
    (code)
    jmp if_num.fi
if_num.else:
    (code)
if_num.fi:
```

**For Loop:**

```assembly
for_num: condition
    (code)
    (increment step)
    jmp for_num
for_num.done
```

[cite_start]Pretty clean, right? [cite: 14]