                global _start
               
                extern printf
                extern new_node 
                extern print_node 
                extern insert 
                extern root 
                extern print_avl 
                extern pointer 
                extern format_pointer 

                section .text

_start:
            push rbp
            mov rbp , rsp


            mov rdi , node1 
            mov rsi , 15
            call new_node
            push rax 

            mov rdi , node2 
            mov rsi , 200
            call new_node
            push rax 
            
            mov rdi , node3
            mov rsi , 200
            call new_node
            push rax 

            mov rdi , node4
            mov rsi , 200
            call new_node
            push rax 

            mov rdi , node5
            mov rsi , 200
            call new_node
            push rax 

            mov rdi , node6
            mov rsi , 200
            call new_node
            push rax 

            ; mov rdi , [rbp - 8]
            ; call print_node

            ; mov rdi , [rbp -16]
            ; call print_node 

            ; mov rdi , [rbp -24]
            ; call print_node 
            




            mov rdi , [root]
            mov rsi , [rbp - 24]
            call insert 

            mov rdi , [root]
            mov rsi , [rbp - 8]
            call insert 

            mov rdi , [root]
            mov rsi , [rbp - 16]
            call insert 


            mov rdi , [root]
            call print_avl

            mov rsp , rbp
            pop rbp 

            mov rax , 60
            mov rdi , 0
            syscall

                section .data
                
            node1: db "a" , 0
            node2: db "b" , 0
            node3: db "c" , 0
            node4: db "d" , 0
            node5: db "e" , 0
            node6: db "f" , 0

            value: dq 30

           

           
