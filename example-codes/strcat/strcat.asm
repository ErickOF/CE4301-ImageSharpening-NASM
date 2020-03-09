section	.text
   global _start


section	.data
    buffer times 20 db 0x0
    fizz  db '1234567890', 0x0
    buzz  db 'abcdefghijklmnopqrstuv', 0xa
    ; len()
    len1  equ $ - fizz
    len2  equ $ - buffer


_start:
    mov     eax, [fizz]
    mov     [buffer], eax
    mov     eax, [buzz]
    mov     [buffer + len1], eax

    mov     rdx, len1
    mov     rcx, fizz           ; Msg to write
    mov     rbx, 1              ; File descriptor (stdout)
    mov     rax, 4              ; Syscall number (sys_write)
    int     0x80                ; Call kernel

    mov     rax, 1              ; System call number (sys_exit)
    int     0x80                ; Call kernel
