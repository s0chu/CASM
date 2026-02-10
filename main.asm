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
                
                
                extern strcmp 
                extern strstr 

                section .text


new_handler: 



    ret 

update_handler:


    ret 

print_handler:

    ret 

delete_handler:


    ret 

init_commands: 
    push rbp 
    mov rbp , rsi 

    mov rax , new_comm
    mov [commands + 0 * 8] , rax
    mov qword [action + 0 * 8] , new_handler 

    mov rax , update_comm 
    mov [commands + 1 * 8] , rax 
    mov qword [action + 1 * 8] , update_handler 

    mov rax , print_comm
    mov [commands + 2 * 8] , rax 
    mov qword [action + 2 * 8] , print_handler

    mov rax , delete_comm
    mov [commands + 3 * 8] , rax 
    mov qword [action + 3 * 8] , delete_handler

    mov rsi , rbp
    pop rbp 
    ret 

parse_command: 
    push rbp 
    mov rbp , rsi 

    sub rsi , 200
    
    %define i -1
    %define result -9 
    %define comm -17 

    mov qword [rbp + result] , 0 
    mov byte [rbp + i] , 0
    mov qword [rbp + comm] , rdi 

    .for: 
        mov bl , [rbp + i]
        cmp bl , [commands_count]
        je .done 

        mov rdi , [rbp + comm]
        mov rsi , [commands + rbx * 8]
        call strstr 

        mov rdi , [rbp + comm]
        cmp rax , rdi  
        
        mov bl , [rbp + i]

        jne .not_right_command 
            mov rcx , [action + rbx * 8]
            mov [rbp + result] , rcx 
        .not_right_command:

        inc byte [rbp + i]
        jmp .for
    .done:


    mov rax , [rbp + result]

    mov rsi , rbp 
    pop rbp 
    ret

_start:
            ; create(value)
            ; update(num , value)
            ; print(num)
            ; delete(value)

            push rbp
            mov rbp , rsp
            
            ; push rdi 

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

            ; call stress_test

            ; mov rdi , [root]
            ; call print_avl

            ; mov rsp , rbp
            ; pop rbp 


            call init_commands

           mov rdi , comm1
           call parse_command


            ; mov rdi , comm1 
            ; mov rsi , [commands]
            ; call strstr 

            mov rdi , format_pointer 
            mov rsi , rax 
            xor rax , rax
            call printf

            mov rax , 60
            mov rdi , 0
            syscall


                section .bss 
            fd: resd 1
            reading: resb 4096
            commands: resq 4
            action: resq 4 

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

            commands_count: db 4  
            delete_comm: db "delete" , 0
            new_comm: db "new" , 0
            update_comm : db "update" , 0
            print_comm : db "print" , 0 



            ; testing purposes
            comm1: db "delete()" , 0
            comm2: db "da" , 0
            