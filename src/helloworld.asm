global _start

section .data
    msg: db "Hello world!", 0x0A, 0x0
    msglen equ $ - msg

section .text
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msglen
    call system

    mov eax, 1
    mov ebx, 0
    call system

system:
    int 0x80
    ret
