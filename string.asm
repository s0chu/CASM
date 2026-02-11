                    
                    section .text
                    
                    global format_decimal
                    global format_node
                    global format_string 
                    global format_pointer 
                    global format_key 
                    global format_string_scanf 
                    
                    global unknown_command
                    global inside_func 

                    global strcpy
                    global strlen
                    global strcmp
                    global strstr 
                    global strchr 

strlen:
    push rbp
    mov rbp , rsp

    sub rsp , 8

    %define i -8
    mov dword [rbp + i] , 0

    .for:
        mov eax , [rbp + i]
        cmp byte [rdi + rax] , 0
        jz .done
        inc dword [rbp + i]
        jmp .for
    .done:

    %undef i
    mov rsp , rbp
    pop rbp
    ret

strcpy: 
    push rbp
    mov rbp , rsp

    sub rsp , 8
    %define i -8

    mov dword [rbp + i] , 0

    .for:
        mov eax , dword [rbp + i]
        mov bl , [rsi + rax]
        mov byte [rdi + rax] , bl
        cmp byte [rsi + rax] , 0
        jz .done
        inc dword [rbp + i]
        jmp .for
    .done:

    mov rsp , rbp
    pop rbp

    ; %undef i
    ret



strcmp:
    push rbp
    mov rbp , rsp

    .for:
        cmp byte [rdi] , 0
        jnz .else
        
        cmp byte [rsi] , 0
        jnz .else 

            jmp .ret0

        .else:

            mov al , byte [rdi]
            cmp al , byte [rsi]

            jb .ret2
            ja .ret1

        inc rdi
        inc rsi
        jmp .for
    .done:

    .ret0:
        mov rax , 0
        jmp strcmp.finish
    .ret1:
        mov rax , 1
        jmp strcmp.finish
    .ret2:
        mov rax , -1
        jmp strcmp.finish
    .finish:

    mov rsp , rbp
    pop rbp
    ret

strstr: 
    push rbp 
    mov rbp , rsp 

    .for1:
            mov rbx , 0 
            mov rax , rdi 

            .for2: 
                cmp byte [rsi + rbx] , 0 
                je .return  
                           
                cmp byte [rdi + rbx] , 0
                je .done1

                mov cl , [rsi + rbx]
                cmp [rdi + rbx] , cl 

                jne .skip

                inc rbx 
                jmp .for2
            .done2:

        .skip:
        inc rdi
        jmp .for1
    .done1:

    mov rax , 0 
    .return:

    mov rsp , rbp 
    pop rbp 
    ret

strchr: 
    push rbp 
    mov rbp , rsp 

    .for:    
        cmp byte [rdi] , 0 
        je .done

        mov rax , rdi 
        cmp byte [rdi] , sil 
        
        je .return

        inc rdi 
        jmp .for
    .done:

    mov rax , 0 

    .return:

    mov rsp , rbp 
    pop rbp 
    ret 
                section .data 

            format_string_scanf: db "%s" , 0
            format_decimal: db "%d" , 10 , 0
            format_string:  db "%s" , 10 , 0
            format_node:    db "left:%10p right:%10p height:%5d key: %6s value: %5d curr: %10p" , 10 , 0
            format_key:     db "%s" , 10 , 0
            format_pointer: db "%p" , 10 , 0

            unknown_command: db "Unknown command!" , 0
            inside_func: db "inside" , 0
    ; 1 0 -> 0
    ; 1011 ->     10110
    ; 1011        01010 -> -10

                ; 101
                ; 011

                ; 101
                ; 001

                ; 111
                ; 001

                ; 111
                ; 011