global function

section	.data
   ; String to be printed
   msg  db 'Hello Python from NASM!', 0x0, 0xA
   ; len(msg)
   len  equ $ - msg

section .text
function: 
    ;push  rbp 
    ;mov   rbp, rsp 
    ;sub   rsp, 0x40            ; 64 bytes of local stack space 
    ;mov   rbx, [rbp + 8]       ; first parameter to function 

    mov   rdx, len             ; Msg length
    mov   rcx, msg             ; Msg to write
    mov   rbx, 1               ; File descriptor (stdout)
    mov   rax, 4               ; Syscall number (sys_write)
    int   0x80                 ; Call kernel

    mov   rax, 1               ; System call number (sys_exit)
    int   0x80                 ; Call kernel
