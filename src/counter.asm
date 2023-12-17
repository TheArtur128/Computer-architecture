global _start

section .data
    counter dq 0

    symbol_overflow dq 10

    rendered_counter_index dd 0 ; CleanRender
    message db 'counted = ', 0
    message_length equ $ - message

    endl db 10, 0
    endl_length equ $ - endl

    sleep_seconds db 1

    output db 0, 0

section .bss
    rendered_counter resb 1000

section .text
_start:
    call _count

    mov eax, counter
    push eax
    call render
    call show
    call wait_

    jmp _start

; * -> *
; changes eax, counter
count:
    mov eax, [counter]
    inc eax
    mov [counter], eax

    ret

; CleanRender -> int counter -> RenderedCounter
; changes eax, ebx, ecx, edx, rendered_counter, rendered_counter_index
render:
    pop eax ; counter

    mov ebx, [symbol_overflow] ; 10
    cmp eax, ebx
    jl _add_rendered

    mov ecx, eax ; counter

    mov edx, 0
    div ebx

    mov ebx, eax ; counter // 10
    times 9 add eax, ebx ; counter // 10 * 10

    mov ebx, eax ; counter // 10 * 10

    sub ecx, eax ; counter - counter // 10 * 10
    mov eax, ecx

    _add_rendered:
        mov ebx, 48
        add eax, ebx

        mov ecx, rendered_counter
        mov edx, rendered_counter_index
        add ecx, edx

        mov [ecx], eax

        mov eax, [rendered_counter_index]
        inc eax
        mov [rendered_counter_index], eax

    push ebx
    call render

    ret

; numebr int -> number_system int -> int
get_last_number:
    pop ebx ; number_system
    pop eax ; number

    cmp eax, ebx
    jl _return_last_number

    mov ecx, eax ; number

    mov edx, 0
    div ebx

    mov ebx, eax ; number // 10
    times 9 add eax, ebx ; number // 10 * 10

    mov ebx, eax ; number // 10 * 10

    sub ecx, eax ; number - number // 10 * 10
    mov eax, ecx

    jmp _return_last_number

_return_last_number:
    push eax
    ret

; RenderedCounter -> CleanRender
; changes eax, ebx, ecx, edx, rendered_counter_index
show:
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, message_length
    int 128

    call _show_counter

    mov eax, 4
    mov ebx, 1
    mov ecx, endl
    mov edx, endl_length
    int 128

    ret

_show_counter:
    mov eax, rendered_counter
    mov ebx, rendered_counter_index
    add eax, ebx

    mov [output], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, output
    mov edx, 2
    int 128

    mov al, [rendered_counter_index]
    dec al
    mov [rendered_counter_index], al

    mov bl, 0
    cmp al, bl
    jg _show_counter

    ret

; * -> *
; changes eax, ebx
wait_:
    mov eax, 101
    mov ebx, [sleep_seconds]
    int 128

    ret
