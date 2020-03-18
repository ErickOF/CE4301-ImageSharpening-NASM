global _start

section .data
   filename db 'sharpening.txt'

section .text
_start:
    mov     rcx, 0777           ; set all permissions to read, write, execute
    mov     rbx, filename       ; filename we will create
    mov     rax, 8              ; invoke SYS_CREAT (kernel opcode 8)
    int     0x80                ; call the kernel

    mov     rax, 1              ; system call number (sys_exit)
    int     0x80                ; call kernel
