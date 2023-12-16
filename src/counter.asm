global _start

section .data
    counter dq 0
    rendered_counter_index dd 0 ; CleanRender

    message db 'counted = ', 0
    message_length equ $ - message

    endl db 10, 0
    endl_length equ $ - endl

    sleep_seconds db 1

section .bss
    rendered_counter resb 1000

section .text
_start:
    inc counter

    push counter
    call _render
    call _show
    call _wait

    jmp _start

; CleanRender -> int -> RenderedCounter
; changes eax, ebx, ecx, edx, rendered_counter, rendered_counter_index
_render:
    pop eax

    cmp eax, 10
    jl _add_rendered

    mov ecx, eax

    mov edx, 0
    mov ebx, 10

    div ebx
    mov edx, eax

    mov ebx, eax
    times 9 add

    mov ebx, eax
    mov eax, ecx

    sub ecx, eax
    mov eax, ecx

    _add_rendered:
        mov ebx, 48
        add
        mov [rendered_counter + rendered_counter_index], eax
        inc rendered_counter_index

    push ebx
    call _render

    ret

; RenderedCounter -> CleanRender
; changes eax, ebx, ecx, edx, rendered_counter_index
_show:
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
        mov eax, 4
        mov ebx, 1
        mov ecx, db [rendered_counter + rendered_counter_index], 0
        mov edx, 2
        int 128

        dec rendered_counter_index

        cmp rendered_counter_index, 0
        jg _show_counter

        ret

; * -> *
; changes eax, ebx
_wait:
    mov eax, 101
    mov ebx, [sleep_seconds]
    int 128

    ret
