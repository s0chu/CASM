                global _start
               
                extern printf
                extern scanf 

                extern new_node 
                extern print_node 
                extern insert 
                extern root 
                extern print_avl 
                extern pointer 
                extern format_pointer 
                extern format_decimal
                extern stress_test

                extern unknown_command
                extern inside_func 

                extern format_string 
                extern format_string_scanf
                
                extern strcmp 
                extern strstr 

                section .text


new_handler: 
    push rbp 
    mov rbp , rsp



    mov rsp , rbp 
    pop rbp 
    ret 

update_handler:
    push rbp 
    mov rbp , rsp

    mov rsp , rbp 
    pop rbp
    ret 

print_handler:
    push rbp 
    mov rbp , rsp 


    mov rsp , rbp 
    pop rbp 
    ret 

delete_handler:
    push rbp 
    mov rbp , rsp 


    mov rsp , rbp 
    pop rbp
    ret 

init_commands: 
    push rbp 
    mov rbp , rsi 

    mov qword [commands + 0 * 8] , new_comm
    mov qword [action + 0 * 8] , new_handler 

    mov qword [commands + 1 * 8] , update_comm 
    mov qword [action + 1 * 8] , update_handler 

    mov qword [commands + 2 * 8] , print_comm 
    mov qword [action + 2 * 8] , print_handler

    mov qword [commands + 3 * 8] , delete_comm 
    mov qword [action + 3 * 8] , delete_handler

    mov rsi , rbp
    pop rbp 
    ret 

parse_command: 
    push rbp 
    mov rbp , rsp 

    sub rsp , 200
    
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

    mov rsp , rbp 
    pop rbp 
    ret

main_loop:
    push rbp 
    mov rbp , rsp 

    call init_commands

    sub rsp , 496 

    %define s -256

    while:
        mov rdi , format_string_scanf
        mov rsi , rbp 
        add rsi , s 
        xor rax , rax
        call scanf

        cmp eax , -1
        je done 

        ; mov rdi , format_string 
        ; mov rsi , rbp 
        ; add rsi , s
        ; xor rax , rax 
        ; call printf

        xor rax , rax 

        mov rdi , rbp 
        add rdi , s 
        call parse_command

        cmp rax , 0
        jne valid_command     
            mov rdi , format_string 
            mov rsi , unknown_command
            xor rax , rax
            call printf 

        jmp end_if
        valid_command:
            call rax 
        end_if:

        jmp while
    done:

    mov rsp , rbp 
    pop rbp 
    ret

_start:
            ; new(value)
            ; update(num , value)
            ; print(num)
            ; delete(value)


    call stress_test    

    mov rax , 60
    mov rdi , 0
    syscall

                section .bss 
            fd: resd 1
            reading: resb 4096
            commands: resq 4
            action: resq 4 
            String: resb 256
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
            delete_comm: db "delete(" , 0
            new_comm: db "new(" , 0
            update_comm : db "update(" , 0
            print_comm : db "print(" , 0 



            ; testing purposes
            comm1: db "update()" , 0
            comm2: db "da" , 0
            