                section .text 
                
                extern printf 
                extern strcpy 
                extern strcmp 
                extern strlen 

                extern format_decimal
                extern format_node 
                extern format_string 

                global left 
                global right
                global height
                global key
                global value 

                global print_node 
                global new_node 

%macro create_new_node 0
                [section .bss]
            %%start_adr: resq 2  ; left right child
                         resd 1  ; max height
                         resb 20 ; label 
                         resq 1  ; value 

                [section .text]
            mov rax , %%start_adr
%endmacro

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

new_node:
    push rbp 
    mov rbp , rsp
    
    create_new_node

    push rax 

    mov rdx , rsi
    mov rsi , rdi 
    mov rdi , rax 
    call init_node 
    
    mov rax , [rbp - 8]

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


get_height: ; ptr -> int
    push rbp 
    mov rbp , rsp

    cmp rdi , 0
    jz .null
        mov eax , dword [rdi + height]
        jmp .fi
    .null:
        mov eax , 0
    .fi:

    mov rsp , rbp 
    pop rbp 
    ret

recalculate: ; ptr -> void
    push rbp 
    mov rbp , rsp 

    %define ptr -8
    push rdi 

    mov rdi , [rdi + left]
    call get_height 

    push rax 
    %define hl -16

    mov rdi , [rbp + ptr]
    mov rdi , [rdi + right]
    call get_height 

    push rax 
    %define hr -24

    mov rdi , [rbp + ptr]
    
    mov rax , [rbp + hl]
    cmp rax , [rbp + hr]

    ja .done 
    mov rax , [rbp + hr]

    .done:

    mov dword [rdi + height] , eax
    mov rsp , rbp 
    pop rbp 
    ret

insert: 

left_rotate: ; ptr -> ptr
    push rbp 
    mov rbp , rsp 

    push rdi 
    mov rdi , [rdi + right]
    push rdi 
    mov rdi , [rdi + left]
    push rdi 

    %define x -8
    %define y -16
    %define z -24

    mov rdi , [rbp + x]
    mov rsi , [rbp + z]
    mov [rdi + right] , rsi

    mov rdi , [rbp + y]
    mov rsi , [rbp + x]
    mov [rdi + left] , rsi

    mov rdi , [rbp + x]
    call recalculate

    mov rdi , [rbp + y]
    call recalculate

    mov rax , [rbp + y]

    mov rsp , rbp
    pop rbp
    ret

right_rotate: ; ptr -> ptr
    push rbp 
    mov rbp , rsp 

    push rdi
    mov rdi , [rdi + left]
    push rdi 
    mov rdi , [rdi + right]
    push rdi 

    %define x -8
    %define y -16
    %define z -24

    mov rdi , [rbp + y]
    mov rsi , [rbp + x]
    mov [rdi + right] , rsi 

    mov rdi , [rbp + x]
    mov rsi , [rbp + z]
    mov [rdi + left] , rsi 

    mov rdi , [rbp + x]
    call recalculate

    mov rdi , [rbp + y]
    call recalculate 

    mov rsp , rbp 
    pop rbp 
    ret 


                section .data
            root: dq 0
            left:   equ  0
            right:  equ  8
            height: equ 16
            key:    equ 20
            value:  equ 40