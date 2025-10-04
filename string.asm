                    
                    section .text
                    
                    global format_decimal
                    global format_node
                    global format_string 
                    global format_pointer 
                    global format_key 

                    global strcpy
                    global strlen
                    global strcmp

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

                section .data 


            format_decimal: db "%d" , 10 , 0
            format_string:  db "%s" , 10 , 0
            format_node:    db "left:%p right:%p height:%d key: %s value: %d curr: %p" , 10 , 0
            format_key:     db "%s" , 10 , 0
            format_pointer: db "%p" , 10 , 0

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