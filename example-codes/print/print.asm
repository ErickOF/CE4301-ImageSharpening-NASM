section	.text
   global _start    ; Must be declared for linker (ld)

section	.data
   ; String to be printed
   msg  db 'Hello, world!', 0xa
   ; len(msg)
   len  equ $ - msg

_start:              ; Linker entry point
   mov   rdx, len    ; Msg length
   mov   rcx, msg    ; Msg to write
   mov   rbx, 1      ; File descriptor (stdout)
   mov   rax, 4      ; Syscall number (sys_write)
   int   0x80        ; Call kernel

   mov   rax, 1      ; System call number (sys_exit)
   int   0x80        ; Call kernel
