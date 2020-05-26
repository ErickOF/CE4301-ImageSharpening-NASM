global _start

%include 'functions.asm'

section .text

to_zero:
    mov     rax, 0
    jmp     show

to_255:
    mov     rax, 255
    jmp     show

conv2_3x3:
    ; {{-2, -1, 0}, {-1, 1, 1}, {0, 1, 2}}
    mov     rbx, 0x0 ; result = 0

    ; mask[0][0]
    mov     rax, -2
    mov     rdx, 2
    imul    rdx
    movsx   rax, eax
    add     rbx, rax

    ; mask[0][1]
    mov     rax, -1
    mov     rdx,  2
    imul    rdx
    movsx   rax, eax
    add     rbx, rax

    ; mask[0][2]
    mov     rax, 0
    mov     rdx, 2
    imul    rdx
    movsx   rax, eax
    add     rbx, rax

    ; mask[1][0]
    mov     rax, -1
    mov     rdx,  2
    imul    rdx
    movsx   rax, eax
    add     rbx, rax

    ; mask[1][1]
    mov     rax, 1
    mov     rdx, 2
    imul    rdx
    movsx   rax, eax
    add     rbx, rax

    ; mask[1][2]
    mov     rax, 1
    mov     rdx, 2
    imul    rdx
    movsx   rax, eax
    add     rbx, rax

    ; mask[2][0]
    mov     rax, 0
    mov     rdx, 2
    imul    rdx
    movsx   rax, eax
    add     rbx, rax

    ; mask[2][1]
    mov     rax, 1
    mov     rdx, 200
    imul    rdx
    movsx   rax, eax
    add     rbx, rax

    ; mask[2][2]
    mov     rax, 2
    mov     rdx, 200
    imul    rdx
    movsx   rax, eax
    add     rbx, rax
    
    ; if (result < 0)
    cmp     rbx, 0
    jl      to_zero

    ; if (result > 255)
    cmp     rbx, 255
    jg      to_255

    mov     rax, rbx

show:
    call    printnumber
    call    printnewline

    jmp     finish

_start:
    jmp     conv2_3x3

finish:
    jmp     exit
