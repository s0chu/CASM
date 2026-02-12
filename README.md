# CASM

This app is a basic interactive AVL data structure in ASM x64 with minimal C function calling (`scanf`, `printf`, `malloc` and `free`).

## Supported Commands

* `new(<variable_name>)` -> creates a new variable named `<variable_name>` with the default value of 0. The name must be a 19 character string max.
* `delete(<variable_name>)` -> deletes the variable named `<variable_name>` from the tree.
* `print(<variable_name>)` -> prints the value of the variable `<variable_name>`.
* `update(<variable_name> , <num>)` -> updates the value of `<variable_name>` to `<num>`;
    * **Note:** num is a 64 bit signed integer.
* `print_avl()` -> prints the nodes of the tree in-order;
    * **Format:** the format of a node is: `left_child_address , right_child_address , height , key , value , address`.
    * **Note:** Addresses are 64/32 bit integers representing a memory address.
* `stress_test()` -> inserts 26^5 = 11 million nodes in the tree, with 5 characters length each.

## Getting Started

To begin the interaction you have to compile the program:

```bash
sh compile.sh
```

The interaction protocol is: `command-response`
To end the interaction insert `EOF` (ctrl + d)

## C++ Comparison

* C++ version runs in **14 seconds**, using a map.
<details open>
<summary> Implementation</summary>

   ```cpp
        #include <bits/stdc++.h>
        #include <stdio.h>

        using namespace std;

        map < string , long long > avl;

        int main()
        {
            string s; 

            for(int i = 'a' ; i <= 'z' ; i++)
                for(int j = 'a' ; j <= 'z' ; j++)
                    for(int t = 'a' ; t <= 'z' ; t++)
                        for(int r = 'a' ; r <= 'z' ; r++)
                            for(int u = 'a' ; u <= 'z' ; u++)
                            {
                                s = "";
                                s += i;
                                s += j;
                                s += t;
                                s += r; 
                                s += u; 
                                
                                avl[s] = 0;
                            }

            
            return 0;
        }
    ```
    
</details>
* My version runs in **8 seconds**.

## Implementation Details

**Simple dynamic AVL implementation.**
It doesn't follow a standard implementation, but the same logic applies.

* On each insert, you check if it triggers a balancing mechanism (height levels between sons is > 1).
* The balancing mechanism consists of left/right rotations, maintaing inductively the difference between sons' levels <= 1.
* On deletion, same thing happens, but the deleted nodes, gets swapped with the immediate node with a bigger key, so you delete the leaf node and replace the current node with that one.
* Check again if it triggers the balancing mechanism.
* On each return of a function you return the new root of the tree/subtree.
* The memory is allocated dynamically using `malloc` (from C) and deleted it with `free` (from C).
* String handling is done via strings that terminates in a null character.
* String manipulation functions are implemented with this logic in mind and are implemented in a bruteforce way like in C.

## Code Tricks

Because ASM doesn't scream "natural coding", I have come up with the following strategy for easy looking code:

### 1. Indentation in functions and statements

So a tab means that you are coding inside a function / scope (like `{}` in C/C++)

**Example:**
```assembly
mov byte [rbp + i] , 97
for1:   cmp byte [rbp + i] , 122
        ja for1.fi 

        mov byte [rbp + j] , 97
        for2:   cmp byte [rbp + j] , 122 
                ja for2.fi         
                        mov al , [rbp + i]
                     
                        mov bl , [rbp + j]
                        mov cl , [rbp + t]
                        mov dl , [rbp + r]

                        ...
```

### 2. Labeling mechanism

NASM offers an interesting mechanism for labeling: **sublabels**.
So declaring a label `.name:` will belong to the nearest non sublabel (without a `.` at the beginning).
So `if`'s and `for`'s can be simple coded like this:

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

Pretty clean, right?