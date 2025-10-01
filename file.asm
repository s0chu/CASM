                global _start
                extern printf

                section .text


_start:
                [section .data]
format:     db "it works %d hello" , 10
                [section .text]

            mov rax , 100
            mov rdi , format
            mov rsi , [value]

            call printf

            mov rax , 60
            mov rdi , 0
            syscall 

                section .data
value:      db 0

