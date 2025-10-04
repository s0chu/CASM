                section .text 
                
                extern printf 
                extern strcpy 
                extern strcmp 
                extern strlen 

                extern format_decimal
                extern format_node 
                extern format_string 
                extern format_pointer 
                extern format_key

                global left 
                global right
                global height
                global key
                global value 

                global print_node 
                global new_node 
                global insert 
                global root 
                global print_avl 

%macro create_memory_pool 2 
                [section .bss]
    %1: resb _SIZE * %2
                [section .text]
    mov dword [REMAINING_MEMORY] , %2
    mov qword [ARB_PTR] , %1
%endmacro 

%assign chunk_counter 0
%assign if_counter 10
%assign power_counter 1

%macro allocate_chunk 0
    %assign chunk_counter chunk_counter + 1
    %assign if_counter if_counter + 1
    %assign power_counter power_counter * 2

    if_ %+ %[if_counter]:   cmp byte [ALLOCATED_POWER] , %[chunk_counter]
                            jne if_ %+ %[if_counter].fi 
            
            create_memory_pool memory_pool_chunk %+ %[chunk_counter] , %[power_counter]

    if_ %+ %[if_counter].fi:
%endmacro


create_new_node:
    push rbp 
    mov rbp , rsp 


    if_10:  cmp dword [REMAINING_MEMORY] , 0
            jne if_10.fi
        
        add byte [ALLOCATED_POWER] , 1

        
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk
        allocate_chunk

    if_10.fi:

    
    mov rax , [ARB_PTR]
    push rax 
    add qword [ARB_PTR] , _SIZE
    sub dword [REMAINING_MEMORY] , 1

    ; mov rdi , txt 
    ; xor rax , rax
    ; call printf 

    mov rax , [rbp - 8]

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

new_node:
    push rbp 
    mov rbp , rsp
    
    call create_new_node

    push rax 

    mov rdx , rsi
    mov rsi , rdi 
    mov rdi , rax 
    call init_node 

    ; mov rax , [rbp - 8]
    ; mov rdi , format_pointer 
    ; mov rsi , rax 
    ; xor rax , rax
    ; call printf

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
    push rax
    xor rax , rax 

    call printf

    mov rsp , rbp
    pop rbp
    ret

print_node_key:
    push rbp 
    mov rbp , rsp 

    mov rax , rdi 
    mov rdi , format_key
    mov rsi , rax 
    add rsi , key
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

    mov rcx , [rbp + ptr]
    mov rcx , [rcx + left]

    cmp rcx , 0
    jz .notnull
        add rax , 1
    .notnull:

    push rax 
    %define hl -16

    mov rdi , [rbp + ptr]
    mov rdi , [rdi + right]
    call get_height 

    mov rcx , [rbp + ptr]
    mov rcx , [rcx + right]

    cmp rcx , 0
    jz .notnulll
        add rax , 1
    .notnulll:

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

get_height_2:
    push rbp 
    mov rbp , rsp

    call get_height

    cmp rdi , 0
    
    je .skip
        add rax , 1
    .skip:

    mov rsp , rbp 
    pop rbp 
    ret
insert: ; ptr , ptr -> ptr
    push rbp 
    mov rbp , rsp 

    push rdi 
    push rsi 

    %define node -8
    %define x -16
    %define chld -24
    %define hl -32
    %define hr -40
    %define node_r -48
    %define node_r_l -56
    %define node_r_r -64
    %define hrl -72
    %define hrr -80
    %define node_l -88
    %define node_l_l -96
    %define node_l_r -104
    %define hll -112
    %define hlr -120

    if_8:   cmp rdi , 0
            jnz if_8.else 
        mov rbx , [root]
        cmp rbx , 0
        
        jnz .notfirst 
            mov [root] , rsi
        .notfirst:

        mov rax , [rbp + x] 
        jmp if_8.fi
    if_8.else:
        mov rdi , [rbp + x]
        add rdi , key

        mov rsi , [rbp + node]
        add rsi , key

        call strcmp

        if_1: cmp rax , -1
              jne if_1.else 
            
            mov rdi , [rbp + node]
            add rdi , left
            mov rax , rdi

            jmp if_1.fi
        if_1.else:

            mov rdi , [rbp + node]
            add rdi , right 
            mov rax , rdi

        if_1.fi:

        push rax

        mov rdi , [rax]
        mov rsi , [rbp + x]
        call insert

        mov rbx , [rbp + chld]
        mov [rbx] , rax

        mov rdi , [rbp + node]
        call recalculate

        mov rax , [rbp + node]
        mov rdi , [rax + left]
        call get_height

        mov rcx , [rbp + node]
        add rcx , left 

        if_4: cmp qword [rcx] , 0
              jz if_4.fi

            add rax , 1
        if_4.fi:

        push rax

        mov rax , [rbp + node]
        mov rdi , [rax + right]
        call get_height
        
        mov rcx , [rbp + node]
        add rcx , right 

        if_5: cmp qword [rcx] , 0
              jz if_5.fi 
        
            add rax , 1
        if_5.fi:

        push rax

        mov rbx , [rbp + hl]
        sub rbx , [rbp + hr]
        
        mov rax , [rbp + node]

        if_2: cmp rbx , -2 
              jne if_3

            mov rcx , [rbp + node]
            add rcx , right
            push qword [rcx]
            mov rcx , [rcx]

            push qword [rcx + left]
            push qword [rcx + right]

            mov rdi , [rbp + node_r_l]
            call get_height_2
            push rax 

            mov rdi , [rbp + node_r_r]
            call get_height_2
            push rax

            mov rcx , [rbp + hrl]
            sub rcx , [rbp + hrr]


            if_6:   cmp rcx , 1
                    jne if_6.fi
                
               

                mov rdi , [rbp + node_r]
                call right_rotate

                mov rcx , [rbp + node]
                mov [rcx + right] , rax

                mov rcx , [rbp + node]
                call recalculate

            if_6.fi:

            mov rdi , [rbp + node]
            call left_rotate

            jmp done_23
        if_3: cmp rbx , 2
              jne done_23
            
            sub rsp , 0xFF0
        

            mov rcx , [rbp + node]
            add rcx , left
            mov rcx , [rcx]
            mov [rbp + node_l] , rcx

            mov rdx , [rcx + left]
            mov [rbp + node_l_l] , rdx

            mov rdx , [rcx + right]
            mov [rbp + node_l_r] ,rdx

            mov rdi , [rbp + node_l_l]
            call get_height_2
            mov [rbp + hll] , rax 

            mov rdi , [rbp + node_l_r]
            call get_height_2
            mov [rbp + hlr] , rax

            mov rcx , [rbp + hll]
            sub rcx , [rbp + hlr]

            if_7:   cmp rcx , -1
                    jne if_7.fi

                    mov rdi , [rbp + node_l]
                    call left_rotate

                    mov rdx , [rbp + node]
                    mov [rdx + left] , rax

                    mov rdi , [rbp + node]
                    call recalculate
            if_7.fi: 

            mov rdi , [rbp + node]
            call right_rotate

            ; mov rdx , rax 
            ; mov rdi , rax 
            ; call print_node
        done_23:

        
        mov rdx , [rbp + node]
        if_31:  cmp [root] , rdx 
                jne if_31.fi

            mov [root] , rax
        if_31.fi:

    if_8.fi:

    mov rsp , rbp 
    pop rbp 
    ret

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

    mov rax , [rbp + y]

    mov rsp , rbp 
    pop rbp 
    ret 

print_avl:
    push rbp 
    mov rbp , rsp 
    sub rsp , 0xff

    %define node -8

    if_9:   cmp rdi , 0
            je ret_print
    
    mov [rbp + node] , rdi

    mov rdi , [rbp + node]
    mov rdi , [rdi + left]

    call print_avl 

    mov rdi , [rbp + node]
    call print_node 

    mov rdi , [rbp + node]
    mov rdi , [rdi + right]
    call print_avl 

    ret_print:
    mov rsp , rbp 
    pop rbp
    ret
                section .data
            ALLOCATED_POWER: db 0
            REMAINING_MEMORY: dd  0
            ARB_PTR: dq 0 
            _SIZE: equ 48
            txt: db "hello" ,  10 , 0
            root: dq 0
            left:   equ  0
            right:  equ  8
            height: equ 16
            key:    equ 20
            value:  equ 40