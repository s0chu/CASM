                global _start
                extern printf

                section .text

%macro create_new_node 0
                [section .bss]
            %%start_adr: resq 2  ; left right child
                         resd 1  ; max height
                         resb 20 ; label 
                         resq 1  ; value 

                [section .text]
            mov rax , %%start_adr
%endmacro

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

init_node: ; ptr , name , value
    push rbp
    mov rbp , rsp

    mov qword [rdi + left] , 0
    mov qword [rdi + right] , 0
    mov dword [rdi + height] , 0
    mov qword [rdi + value] , rdx
    mov byte [rdi + key] , 0

    add rdi , key
    push rdi
    mov rsi , rsi
    call strcpy

    mov rsp , rbp
    pop rbp
    ret

print_node:
    push rbp 
    mov rbp , rsp

    mov rax , rdi

    mov rdi , format_node 
    mov rsi , [rax + left]
    mov rdx , [rax + right]
    mov ecx , [rax + height]
    mov r8 , rax 
    add r8 , key
    mov r9 , [rax + value]
    xor rax , rax 

    call printf

    mov rsp , rbp
    pop rbp
    ret

_start:
            push rbp
            mov rbp , rsp

            create_new_node 
            push rax 

            mov rdi , rax
            mov rsi , txt 
            mov rdx , 123

            call init_node 

            mov rdi , [rbp - 8]
            call print_node

            mov rsp , rbp
            pop rbp 

            mov rax , 60
            mov rdi , 0
            syscall

                section .bss
            
            string: resb 20

                section .data
            ; "left:%p right:%p height:%d key: %s value: %d"
            txt: db "abcd" , 0
            format: db "%d" , 10 , 0
            format_string: db "%s" , 10 , 0
            format_node: db "left:%p right:%p height:%d key: %s value: %d" , 10
            left:   equ  0
            right:  equ  8
            height: equ 16
            key:    equ 20
            value:  equ 40
