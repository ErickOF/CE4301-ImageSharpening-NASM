global _start

section .data
  newline: db 0ah,0
  buffer: times 100 db 0

section .rodata
  msg: db "Write a number: ", 0


; len(string)
slen:
  	mov     rdx, 0

.next_c:
  	cmp     byte[rsi + rdx], 0
  	jz      .slen_end
  	inc     rdx
  	jmp     .next_c
.slen_end:
  	ret

; print(string)
print:
	push    rax
	push    rdi
	push    rdx
	call    slen
	mov     rax,1
	mov     rdi,1
	syscall
	pop     rdx
	pop     rdi
	pop     rax
	ret


println:
	call    print
	push    rsi
	mov     rsi, newline
	call    print
	pop     rsi
	ret

; iprint(rax)
iprint:
	push    rbx
	push    rsi
	mov     rbx, 21
	call    num2buffer
	mov     rsi, buffer
.pnfl03:
	cmp     byte[rsi], 32
	jnz     .pnfl04
	inc     rsi
	jmp     .pnfl03
.pnfl04:
	call    println
	pop     rsi
	pop     rbx
	ret

; mov rbx, length   length to print filled with spaces in the left
; iprintf(rax)
iprintf:
	push    rsi
	call    num2buffer
	mov     rsi, buffer
	call    println
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


; str2int(buffer)
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

exit:
	mov     rax, 60
	mov     rdi, 0
	syscall

; cin >> buffer
scanf:
	push    rax
	push    rdi
	push    rdx
	mov     rax, 0
	mov     rdi, 1
	mov     rsi, buffer
    ;  max 100 characters string
	mov     rdx, 100
	syscall
	pop     rdx
	pop     rdi
	pop     rax
	ret

_start:
    mov     rsi, msg
    call    print
    call    scanf
    call    str2int
    call    iprint
    call    exit
