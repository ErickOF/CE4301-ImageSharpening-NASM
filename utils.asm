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


; string sinput();
sinput:
    push    edx             ; New context into the context stack
    push    ecx             ; New context into the context stack
    push    ebx             ; New context into the context stack
    push    eax             ; New context into the context stack

    mov     edx, 32         ; Bytes to read
    mov     ecx, strinput   ; cin >> strinput
    mov     ebx, 0          ; File descriptor (stdin)
    mov     eax, 3          ; System call (sys_read)
    int     0x80            ; Call kernel

    pop     eax             ; Pop stack context value into ebx
    pop     ebx             ; Pop stack context value into ebx
    pop     ecx             ; Pop stack context value into ecx
    pop     edx             ; Pop stack context value into edx

    ret


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


; void sprintln(String message)
sprintln:
    call    sprint
 
    push    eax         ; push eax onto the stack to preserve it while we use the eax register in this function
    mov     eax, 0Ah    ; move 0Ah into eax - 0Ah is the ascii character for a linefeed
    push    eax         ; push the linefeed onto the stack so we can get the address
    mov     eax, esp    ; move the address of the current stack pointer into eax for sprint
    call    sprint      ; call our sprint function
    pop     eax         ; remove our linefeed character from the stack
    pop     eax         ; restore the original value of eax before our function was called
    ret                 ; return to our program


; Exit program and restore resources
; void exit()
exit:
    mov     ebx, 0      ; Return 0 status - 'No errors'
    mov     eax, 1      ; System call (SYS_EXIST)
    int     0x80        ; Call kernell