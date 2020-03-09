; int slen(str: rsi)
slen:
  	mov     rdx, 0                  ; Clear

.next_c:
  	cmp     byte[rsi + rdx], 0      ; if (str[i] == '\0')
  	jz      .slen_end               ; Finish
  	inc     rdx                     ; counter++
  	jmp     .next_c                 ; i++

.slen_end:
    ret                             ; return counter


;-----------------------------------OUTPUT------------------------------------

; void sprint(str: rsi)
sprint:
	push    rax                     ; New context into the context stack
	push    rdi                     ; New context into the context stack
	push    rdx                     ; New context into the context stack

	call    slen                    ; slen(str: rsi)

	mov     rax, 1                  ; System call (sys_write)
	mov     rdi, 1                  ; File descriptor (stdout)
	syscall                         ; Call kernel

	pop     rdx                     ; Pop stack context value
	pop     rdi                     ; Pop stack context value
	pop     rax                     ; Pop stack context value

    ret                             ; return


; sprintln(str: rsi)
sprintln:
	call    sprint                  ; sprint(str: rsi)

    push    rsi                     ; New context into the context stack

	mov     rsi, newline            ; str: rsi = '\n'
	call    sprint                  ; sprint(str: rsi)

	pop     rsi                     ; Pop stack context value

	ret                             ; return


; iprint(num: rax)
iprint:
	push    rbx                     ; New context into the context stack
	push    rsi                     ; New context into the context stack

	mov     rbx, 21
	call    num2buffer

	mov     rsi, buffer

.pnfl03:
	cmp     byte[rsi], 32
	jnz     .pnfl04

	inc     rsi

	jmp     .pnfl03

.pnfl04:
	call    sprintln

	pop     rsi
	pop     rbx

	ret


; mov rbx, length   length to print filled with spaces in the left
; iprintf(rax)
iprintf:
	push    rsi
	call    num2buffer
	mov     rsi, buffer
	call    sprintln
	pop     rsi
	ret


num2buffer:
	push    rcx
	push    rdx
    mov     rcx, 0ah
	mov     byte[buffer + rbx + 1], 0

.pnfl01:
	dec     rbx
    mov     rdx, 0
    ; RDX:RAX / RCX  -->  Q=RAX  R=RDX
    div     rcx
    add     rdx, 48
    cmp     rax, 0
    jnz     .pnfl02
    cmp     rdx, 48
    jnz     .pnfl02
    mov     rdx, 32

.pnfl02:
	mov     byte[buffer + rbx], dl
    cmp     rbx, 0
    jnz     .pnfl01

	pop     rdx
	pop     rcx

	ret


;-----------------------------------STRINGS-----------------------------------

; int str2int(buffer)
str2int:
	push    rcx
	push    rbx
	push    rdx
	push    rdi

    ; looking for the end
	mov     rbx, 0

.buffx1:
	mov     cl, byte[buffer + rbx]
	cmp     cl, 0ah
	jz      .buffx2
	inc     rbx
	jmp     .buffx1

.buffx2:
	mov     rdi, 0
	mov     rcx, 1

.buffx3:
	mov     rax, 0
	mov     al, byte[buffer + rbx - 1]
    ; subtract ASCII of 0
	sub     al, 48
	mov     rdx, 0
	mul     rcx
	add     rdi, rax
	mov     rdx, 0
	mov     rax, 10
	mul     rcx
	mov     rcx, rax
	dec     rbx
	jnz     .buffx3

	mov     rax, rdi

	pop     rdi
	pop     rdx
	pop     rbx
	pop     rcx

	ret


;-----------------------------------INTPUT-----------------------------------

; cin >> buffer
scanf:
	push    rax
	push    rdi
	push    rdx

	mov     rax, 0
	mov     rdi, 1
	mov     rsi, buffer
    ;  max 256 characters string
	mov     rdx, 256
	syscall

	pop     rdx
	pop     rdi
	pop     rax

	ret


;-----------------------------------SYSTEM-----------------------------------

; Exit program and restore resources
; void exit()
exit:
	mov     rax, 60
	mov     rdi, 0
	syscall
