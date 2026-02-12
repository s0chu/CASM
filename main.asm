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
                extern check 
                extern get 
                extern delete
                extern update 
                
                extern unknown_command
                extern inside_func 

                extern format_string 
                extern format_string_scanf
                extern format_empty_command
                extern format_max_size_allowed
                extern format_key_nonexistent
                extern format_long 
                extern format_invalid_update_syntax 

                extern strcmp 
                extern strstr 
                extern strlen 
                extern strchr 

                section .text

transform: 
    push rbp 
    mov rbp , rsp 
    sub rsp , 512

    %define sgn -8 
    %define result -16
    %define s -24
   
    mov qword [rbp + sgn] , 1
    mov qword [rbp + result] , 0 
    mov [rbp + s] , rdi 

    mov rcx , [rbp + s]

    if_57:  cmp byte [rcx] , '-'
            jne if_57.fi  
        mov qword [rbp + sgn] , -1
        inc rcx
    if_57.fi:

    for11:  cmp byte [rcx] , 0
            je for11.done 

        xor rbx , rbx
        mov bl , [rcx]
        sub rbx , 48 

        mov rdi , [rbp + result]
        mov rax , 10
        mul rdi
        add rax , rbx  
        mov [rbp + result] , rax 

        inc rcx
        jmp for11
    for11.done:

    mov rax , [rbp + sgn]
    imul qword [rbp + result]

    mov rsp , rbp 
    pop rbp 
    ret 
new_handler: 
    push rbp 
    mov rbp , rsp
    sub rsp , 512 

    %define n -4 
    %define s -12 
    %define comm_size -16

    mov [rbp + s] , rdi 
    call strlen 
    mov [rbp + n] , eax 

    mov rbx , [rbp + s]
    mov byte [rbx + rax - 1] , 0
    add rbx , 4

    mov rdi , rbx
    call strlen 
    mov [rbp + comm_size] , eax 

    if_53:  cmp dword [rbp + comm_size] , 0  
            jne if_53.else 

        mov rdi , format_empty_command
        xor rax , rax
        call printf 

        jmp if_53.fi
    if_53.else:
        if_54:  cmp dword [rbp + comm_size] , 19
                jle if_54.else

            mov rdi , format_max_size_allowed 
            xor rax , rax 
            call printf 

            jmp if_54.fi
        if_54.else:

            mov rdi , rbx 
            mov rsi , 0
            call new_node 

            mov rdi , [root]
            mov rsi , rax 
            call insert 

        if_54.fi:
    if_53.fi:

    mov rsp , rbp 
    pop rbp 
    ret 

update_handler:
    push rbp 
    mov rbp , rsp
    sub rsp , 512 

    %define s -8
    %define comma -16
    %define key_ptr -24
    %define value_ptr -32 
    %define value_dec -40

    mov [rbp + s] , rdi 
    
    mov rdi , [rbp + s]
    call strlen 

    mov rdi , [rbp + s]
    mov byte [rdi + rax - 1] , 0

    mov rdi , [rbp + s]
    mov sil , ','
    call strchr

    mov [rbp + comma] , rax 

    if_58:  cmp rax , 0 
            jne if_58.else 

        mov rdi , format_invalid_update_syntax 
        xor rax , rax 
        call printf 

        jmp if_58.fi
    if_58.else:
        mov rbx , [rbp + comma]
        mov byte [rbx] , 0 

        add rbx , 1
        mov [rbp + value_ptr] , rbx 

        mov rbx , [rbp + s]
        add rbx , 7
        mov [rbp + key_ptr] , rbx 

        ; mov rdi , format_string
        ; mov rsi , [rbp + value_ptr]
        ; xor rax , rax 
        ; call printf 

        mov rdi , [rbp + value_ptr]
        call transform 

        mov [rbp + value_dec] , rax 
        
        if_59:  mov rdi , [root]
                mov rsi , [rbp + key_ptr]
                call check 
                cmp al , 0
                jne if_59.else

            mov rdi , format_key_nonexistent
            xor rax , rax 
            call printf 

            jmp if_59.fi
        if_59.else:
            mov rdi , [root]
            mov rsi , [rbp + key_ptr]
            mov rdx , [rbp + value_dec]
            call update 
        if_59.fi:

    if_58.fi:

    mov rsp , rbp 
    pop rbp
    ret 

print_handler:
    push rbp 
    mov rbp , rsp 
    sub rsp , 512 

    %define s -8

    mov [rbp + s] , rdi 


    mov rdi , [rbp + s]
    call strlen 
    
    mov rdx , [rbp + s]
    mov byte [rdx + rax - 1] , 0

    mov rdi , [root]
    mov rsi , [rbp + s]
    add rsi , 6

    call check

    if_55:  cmp al , 0
            jne if_55.else 
        
        mov rdi , format_key_nonexistent
        xor rax , rax
        call printf 

        jmp if_55.fi
    if_55.else:
         mov rdi , [root]
         mov rsi , [rbp + s]
         add rsi , 6

         call get 

         mov rdi , format_long 
         mov rsi , rax 
         xor rax , rax
         call printf 
    if_55.fi:

    mov rsp , rbp 
    pop rbp 
    ret 

delete_handler:
    push rbp 
    mov rbp , rsp 
    sub rsp , 512 

    %define s -8

    mov [rbp + s] , rdi 


    mov rdi , [rbp + s]
    call strlen 
    
    mov rdx , [rbp + s]
    mov byte [rdx + rax - 1] , 0

    mov rdi , [root]
    mov rsi , [rbp + s]
    add rsi , 7

    call check

    if_56:  cmp al , 0
            jne if_56.else 
        
        mov rdi , format_key_nonexistent
        xor rax , rax
        call printf 

        jmp if_56.fi
    if_56.else:
         mov rdi , [root]
         mov rsi , [rbp + s]
         add rsi , 7

         call delete 
    if_56.fi:

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
    
    mov qword [commands + 4 * 8] , print_avl_comm 
    mov qword [action + 4 * 8] , print_avl_handler
    
    mov qword [commands + 5 * 8] , stress_test_comm 
    mov qword [action + 5 * 8] , stress_test_handler

    mov rsi , rbp
    pop rbp 
    ret 

print_avl_handler:
    push rbp 
    mov rbp , rsp 

    mov rdi , [root]
    call print_avl 

    mov rsp , rbp 
    pop rbp 
    ret

stress_test_handler:
    push rbp 
    mov rbp , rsp 

    call stress_test

    mov rsp , rbp 
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

        xor rbx , rbx
        mov bl , [rbp + i]
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


    ;call stress_test    

    call main_loop

    mov rax , 60
    mov rdi , 0
    syscall

                section .bss 
            fd: resd 1
            reading: resb 4096
            commands: resq 6    
            action: resq 6 
            String: resb 256
                section .data
            

            path: db "./file.txt" , 0
            
            value: dq 30

            commands_count: db 6  
            delete_comm: db "delete(" , 0
            new_comm: db "new(" , 0
            update_comm : db "update(" , 0
            print_comm : db "print(" , 0 
            print_avl_comm: db "print_avl(" , 0
            stress_test_comm: db "stress_test(" , 0
            