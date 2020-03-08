section  .text
   global _start

section  .bss
   ; Input variable
   str_input resb 1024

section  .data
   max_input dw 1024


; int slen(String message)
slen:
    push    ebx             ; New context into the context stack
    mov     ebx, eax        ; Both point to the same memory segment
 
next_c:
    cmp     byte [eax], 0   ; Comparing char with '\0'
    jz      slen_end        ; if *char == '\0' finish
    inc     eax             ; char++;
    jmp     next_c          ; Repeat
 
slen_end:
    sub     eax, ebx        ; End - initial => length
    pop     ebx             ; Pop stack context value into ebx
    ret                     ; return length


; void sprint(String message)
sprint:
    push    edx             ; New context into the context stack
    push    ecx             ; New context into the context stack
    push    ebx             ; New context into the context stack
    push    eax             ; New context into the context stack

    call    slen            ; slen(string)
 
    mov     edx, eax        ; Save string into data register
    pop     eax             ; Pop stack context value into eax
 
    mov     ecx, eax        ; Save lenght into the counter register
    mov     ebx, 1          ; File descriptor (stdout)
    mov     eax, 4          ; System call (sys_write)
    int     0x80            ; Call kernel
 
    pop     ebx             ; Pop stack context value into ebx
    pop     ecx             ; Pop stack context value into ecx
    pop     edx             ; Pop stack context value into edx
    ret                     ; return ;


; string sinput();
sinput:
    push    edx             ; New context into the context stack
    push    ecx             ; New context into the context stack
    push    ebx             ; New context into the context stack
    push    eax             ; New context into the context stack

    mov     edx, 32         ; Bytes to read
    mov     ecx, str_input  ; cin >> strinput
    mov     ebx, 0          ; File descriptor (stdin)
    mov     eax, 3          ; System call (sys_read)
    int     0x80            ; Call kernel

    pop     eax             ; Pop stack context value into ebx
    pop     ebx             ; Pop stack context value into ebx
    pop     ecx             ; Pop stack context value into ecx
    pop     edx             ; Pop stack context value into edx

    ret


; Exit program and restore resources
; void exit()
exit:
    mov     ebx, 0           ; Return 0 status - 'No errors'
    mov     eax, 1           ; System call (SYS_EXIST)
    int     0x80             ; Call kernell


_start:
   call     sinput           ; input()
   mov      eax, str_input   ; cin >> str_input
   call     sprint           ; sprint(str_input)
   call     exit             ; exit()
