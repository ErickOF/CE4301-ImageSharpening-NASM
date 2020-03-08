extern	system

SECTION .DATA
    msg: db 'python3 imshow.py -o lechuza_gray.bmp -s lechuza_gray.bmp -os lechuza_gray.bmp -c gray', 0x0

SECTION .TEXT
    global main

main:
    push rbp ; Push stack

    mov	rdi, msg
    mov	rax, 0
    call system

    pop	rbp		; Pop stack

    mov	rax, 0	; Exit code 0
    ret			; Return