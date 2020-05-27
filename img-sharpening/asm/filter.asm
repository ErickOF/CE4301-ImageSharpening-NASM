; Maybe delete later
; %include './asm/utils/stdio.asm' ; #include <stdio.h>
%include './asm/utils/functions.asm'

global _start

section .data
    ; Image file names
    originalFileName:       db      "./../temp/original.txt", 0x0
    sharpeningFileName:     db      "./../temp/sharpening.txt", 0x0
    ; Open file in rw mode
    fileFlags:              dq      002o
    ; To store file descriptor, used to open and close operation
    fileDescriptor:         dq      0x0

section .bss
    ; Max resolution: 2048x2048 in 8-bits mode = 4194304 bytes
    ; Max rows and cols: 2048
    ;   - Number of bits to represent 2048: 2^12 -> 12 bits
    ;   - Number of bytes to represent 12 bits: 2 bytes
    ;
    ; Total bytes = rows_bytes + cols_bytes + img_bytes
    ;             = 2 + 2 + 4194304 = 4194308
    ;
    ; Bytes organization:
    ;   - rows -> file[0:1]
    ;   - cols -> file[2:3]
    ;   - img  -> file[4:4194307]
    ; Reserve memory to read the file
    file_buffer:            resq    4194308
    ; Amount of reserved memory
    buffer_size:            equ     4194308
    ; Reserved memory to rows and cols
    rows                    resq    2
    cols                    resq    2
    ; Offset 'cause the first four bytes are to store the number of
    ; rows and columns in the image
    mem_offset              equ     0x4

section .rodata
    msg1:                   db      "Bytes readed=", 0x0
    msg2:                   db      "File Descriptor=", 0x0

section .text
; 1668 x 1195
; for (int j: r9 = 0; j < cols; j++)
for_cols:
    ; j++
    inc     r9
    mov     rax, r9

    ; i < cols
    cmp     r9, [cols]
    jl      for_cols

    ; j == cols -> loop ends
    jmp     for_rows

; for (int i: r10 = 0; i < row; i++)
for_rows:
    ; i++
    inc     r10

    ; j = 0
    mov     r9, 0x0
    mov     rax, r10

    ; i < rows
    cmp     r10, [rows]
    jl      for_cols

    ; i == row -> loop ends
    jmp     finish

; conv(file_buffer, rows: r10, cols: r9)
conv2:
    push    rax
    push    rsi

    ; Rows
    mov     ax, [file_buffer]
    ror     ax, 8
    mov     [rows], ax                      ; rows = len(img)

    call    printnumber
    call    printnewline

    ; Cols
    mov     ax, [file_buffer + 0x2]
    ror     ax, 8
    mov     [cols], ax                      ; cols = len(img[0])

    call    printnumber
    call    printnewline

    ; i = 0
    mov     r10, 0x0
    ; j = 0
    mov     r9, 0x0

    ; img[0][0];
    mov     al, [file_buffer + r10 + mem_offset]
    ror     al, 4
    movzx   rax, al

    call    printnumber
    call    printnewline

    inc     r10                     ; i++;

    ; img[0][1];
    mov     al, [file_buffer + r10 + mem_offset]
    ror     al, 4
    movzx   rax, al

    call    printnumber
    call    printnewline

    inc     r10                     ; i++;

    ; img[0][2];
    mov     al, [file_buffer + r10 + mem_offset]
    ror     al, 4
    movzx   rax, al

    call    printnumber
    call    printnewline

    inc     r10                     ; i++;

    ; img[0][3];
    mov     al, [file_buffer + r10 + mem_offset]
    ror     al, 4
    movzx   rax, al

    call    printnumber
    call    printnewline

    inc     r10                     ; i++;

    pop     rax
    pop     rsi

    mov     r10, 0x0
    mov     r9, 0x0

    jmp     for_rows

_start:
    mov     rax, 2                  ; SYS_OPEN
    mov     rdi, originalFileName   ; const char *filename
    mov     rsi, [fileFlags]        ; int flags
    syscall

    mov     [fileDescriptor], rax
    mov     rsi, msg2
    call    print

    mov     rax, [fileDescriptor]
    call    printnumber
    call    printnewline

    ; Read a message to the created file
    mov     rax, 0                  ; SYS_READ
    mov     rdi, [fileDescriptor]
    mov     rsi, file_buffer
    mov     rdx, buffer_size         ; Bytes to read
    syscall

    push    rax

    ; Close file Descriptor
    mov     rax, 3                  ; SYS_CLOSE
    mov     rdi, [fileDescriptor]
    syscall

    ; Print the number of bytes readed
    mov     rsi, msg1
    call    print
    
    pop     rax
    
    call    printnumber
    call    printnewline

    jmp     conv2

finish:
    ; Print message Readed
    ;mov     rsi, file_buffer
    ;call    println

    call    exit
