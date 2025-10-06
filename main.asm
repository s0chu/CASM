                global _start
               
                extern printf
                extern new_node 
                extern print_node 
                extern insert 
                extern root 
                extern print_avl 
                extern pointer 
                extern format_pointer 
                extern format_decimal
                extern stress_test
                extern format_string 

                section .text

_start:
            
            push rbp
            mov rbp , rsp
            
            push rdi 

            ; mov rdi , format_decimal
            ; mov rsi , [rbp + 8]
            ; xor rax , rax
            ; call printf     

            ; mov rax , 2
            ; mov rdi , path
            ; mov rsi , 0
            ; syscall 

            ; mov dword [fd] , eax

            ; mov rdi , format_decimal
            ; mov rsi , rax 
            ; xor rax , rax
            ; call printf

            ; mov rax , 0
            ; mov edi , dword [fd]
            ; mov rsi , reading  
            ; mov rdx , 30
            ; syscall 

            ; mov byte [reading + 50] , 0
            ; mov rdi , format_string 
            ; mov rsi , reading 
            ; xor rax , rax
            ; call printf

            call stress_test

                mov rdi , [root]
                call print_avl

            mov rsp , rbp
            pop rbp 

            mov rax , 60
            mov rdi , 0
            syscall


                section .bss 
            fd: resd 1
            reading: resb 4096

                section .data
            

            path: db "./file.txt" , 0
            
            node1: db "a" , 0
            node2: db "b" , 0
            node3: db "c" , 0
            node4: db "d" , 0
            node5: db "e" , 0
            node6: db "f" , 0
            node7: db "g" , 0

            value: dq 30

           

           
