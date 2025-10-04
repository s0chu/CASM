                section .text 
                global stress_test
                extern new_node
                extern root
                extern insert 

stress_test:
    push rbp 
    mov rbp , rsp 

    sub rsp , 40
    %define i -8
    %define j -16
    %define t -24
    %define r -32
    %define adr -40
    
    mov qword [rbp + adr] , strings 

    mov byte [rbp + i] , 97
    for1:   cmp byte [rbp + i] , 122
            ja for1.fi 

        mov byte [rbp + j] , 97
        for2:   cmp byte [rbp + j] , 122 
                ja for2.fi 
            
            mov byte [rbp + t] , 97
            for3:   cmp byte [rbp + t] , 122 
                    ja for3.fi 

                mov byte [rbp + r] , 97
                for4:   cmp byte [rbp + r] , 122
                        ja for4.fi 

                    mov al , [rbp + i]
                    mov bl , [rbp + j]
                    mov cl , [rbp + t]
                    mov dl , [rbp + r]
                    
                    mov rdi , [rbp + adr]

                    mov [rdi + 0] , al 
                    mov [rdi + 1] , bl 
                    mov [rdi + 2] , cl 
                    mov [rdi + 3] , dl
                    mov byte [rdi + 4] , 0

                    mov rdi , [rbp + adr]
                    mov rsi , 0
                    call new_node

                    mov rdi , [root]
                    mov rsi , rax
                    call insert

                    add qword [rbp + adr] , 5
                    inc byte [rbp + r]
                    jmp for4
                for4.fi:

                inc byte [rbp + t]
                jmp for3
            for3.fi:

            inc byte [rbp + j] 
            jmp for2
        for2.fi:
        inc byte [rbp + i]
        jmp for1
    for1.fi:


    mov rsp , rbp 
    pop rbp 
    ret


                section .bss
            strings: resb 5 * 26 * 26 * 26 * 26