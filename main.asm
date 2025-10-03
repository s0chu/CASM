                global _start
               
                extern printf
                extern new_node 
                extern print_node 

                section .text
_start:
            push rbp
            mov rbp , rsp

            mov rsp , rbp
            pop rbp 

            mov rax , 60
            mov rdi , 0
            syscall

                section .data
                
            txt: db "Abcd" , 0
            TXT: db "abcd" , 0
            value: dq 30

           

           
