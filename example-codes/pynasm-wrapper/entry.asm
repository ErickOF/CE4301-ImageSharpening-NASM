global _function

section .data
   ; the filename to create
   filename db 'test.txt'

section .text
_function:
   mov     rcx, 0777           ; set all permissions to read, write, execute
   mov     rbx, filename       ; filename we will create
   mov     rax, 8              ; invoke SYS_CREAT (kernel opcode 8)
   int     0x80                ; call the kernel

   ret
