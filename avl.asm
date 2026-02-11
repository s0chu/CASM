                section .text 
                
                extern printf 
                extern strcpy 
                extern strcmp 
                extern strlen 
                extern strchr 

                extern format_decimal
                extern format_node 
                extern format_string 
                extern format_pointer 
                extern format_key

                extern malloc

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
                global check 
                global update 
                global get 

create_new_node:
    push rbp 
    mov rbp , rsp 

    mov rdi , _SIZE 
    call malloc 

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
    push rsi 
    mov rsi , rsi
    call strcpy

    ; mov rdi , format_string 
    ; mov rsi , [rbp - 8]
    ; xor rax , rax 
    ; call printf 

    mov rsp , rbp
    pop rbp
    ret

new_node:
    push rbp 
    mov rbp , rsp
    
    push rdi 
    push rsi 

    call create_new_node

    push rax 

    mov rdi , [rbp - 8]
    mov rsi , [rbp - 16]

    mov rdx , rsi
    mov rsi , rdi 
    mov rdi , rax 
    call init_node 

    ; mov rax , [rbp - 8]
    ; mov rdi , format_pointer 
    ; mov rsi , rax 
    ; xor rax , rax
    ; call printf

    mov rax , [rbp - 24]

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

check: ; node , key -> bool 
    push rbp 
    mov rbp , rsp 
    sub rsp , 64

    %define curr -8
    %define search_key -16
    
    mov [rbp + curr] , rdi 
    mov [rbp + search_key] , rsi 
    
    if_34:  cmp rdi , 0 
            jne .fi 
        mov al , 0
        jmp check.return 
    .fi:

    mov rdi , [rbp + curr]
    add rdi , key 
    mov rsi , [rbp + search_key]
    call strcmp 

    if_32:  cmp rax , 0
            jne if_32.else 

        mov al , 1
        jmp if_32.fi
    if_32.else:  
            if_33:  cmp rax , 1 
                    jne if_33.else 

                mov rdi , [rbp + curr]
                add rdi , left 
                mov rdi , [rdi]
                mov rsi , [rbp + search_key]
                call check 
        
                jmp if_33.fi            
            .else: 
                mov rdi , [rbp + curr]
                add rdi , right 
                mov rdi , [rdi]
                mov rsi , [rbp + search_key]
                call check 

                jmp if_33.fi
            .fi: 
    if_32.fi:

    check.return:
    mov rsp , rbp 
    pop rbp 
    ret 

update: ; ptr key value -> void
    push rbp 
    mov rbp , rsp 

    sub rsp , 60

    %define curr -8 
    %define search_key -16
    %define updated_value -24

    mov [rbp + curr] , rdi 
    mov [rbp + search_key] , rsi 
    mov [rbp + updated_value] , rdx 

    if_35:  mov rdi , [rbp + curr]
            add rdi , key
            mov rsi , [rbp + search_key]
            call strcmp 
            cmp rax , 0 
            jne if_35.else 
                mov rbx , [rbp + updated_value]
                mov rax , [rbp + curr]
                add rax , value
                mov [rax] , rbx
            jmp if_35.fi
    if_35.else:
            if_36:  cmp rax , -1
                    jne if_36.else 

                mov rdi , [rbp + curr]
                add rdi , right 
                mov rdi , [rdi]
                mov rsi , [rbp + search_key]
                mov rdx , [rbp + updated_value]
                call update

                jmp if_36.fi
            if_36.else:
                mov rdi , [rbp + curr]
                add rdi , left 
                mov rdi , [rdi]
                mov rsi , [rbp + search_key]
                mov rdx , [rbp + updated_value]
                call update

            if_36.fi:

    if_35.fi:

    update.return:

    mov rsp , rbp 
    pop rbp 
    ret 
get: ; key -> long long 
    push rbp 
    mov rbp , rsp 

    sub rsp , 60

    %define curr -8 
    %define search_key -16

    mov [rbp + curr] , rdi 
    mov [rbp + search_key] , rsi 

    if_37:  mov rdi , [rbp + curr]
            add rdi , key
            mov rsi , [rbp + search_key]
            call strcmp 
            cmp rax , 0 
            jne if_37.else 
                mov rax , [rbp + curr]
                add rax , value 
                mov rax , [rax]
            jmp if_37.fi
    if_37.else:
            if_38:  cmp rax , -1
                    jne if_38.else 

                mov rdi , [rbp + curr]
                add rdi , right 
                mov rdi , [rdi]
                mov rsi , [rbp + search_key]
                call get

                jmp if_38.fi
            if_38.else:
                mov rdi , [rbp + curr]
                add rdi , left 
                mov rdi , [rdi]
                mov rsi , [rbp + search_key]
                call get

            if_38.fi:

    if_37.fi:

    get.return:

    mov rsp , rbp 
    pop rbp 
    ret 


                section .data
            ARB_PTR: dq 0 
            _SIZE: equ 48 
            txt: db "hello" ,  10 , 0
            root: dq 0

            ; avl node
            left:   equ  0
            right:  equ  8
            height: equ 16
            key:    equ 20
            value:  equ 40