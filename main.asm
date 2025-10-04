                global _start
               
                extern printf
                extern new_node 
                extern print_node 
                extern insert 
                extern root 
                extern print_avl 
                extern pointer 
                extern format_pointer 
                extern stress_test

                section .text

_start:
            push rbp
            mov rbp , rsp


            call stress_test

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

           

           
