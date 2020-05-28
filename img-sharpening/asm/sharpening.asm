global _start


section .data
    ; Image file names
    original_filename:          db      "./../temp/original.txt", 0x0
    sharpening_filename:        db      "./../temp/sharpening.txt", 0x0
    ; Open file in rw mode
    file_flags_orw:             dq      002o
    ; Create file in rw mode
    file_flags_crw:             dq      0102o
    ; user has read write permission
    file_mode:                   dq      00600o
    ; To store file descriptor, used to open and close operation
    file_descriptor:             dq      0x0


section .bss
    ; Max resolution: 4096x2160 in 8-bits mode = 8847360 bytes
    ; Max rows and cols: 4096
    ;   - Number of bits to represent 4096: 2^13 -> 13 bits
    ;   - Number of bytes to represent 13 bits: 2 bytes
    ;
    ; Total bytes = rows_bytes + cols_bytes + img_bytes
    ;             = 2 + 2 + 8847360 = 8847364
    ;
    ; Bytes organization:
    ;   - rows -> file[0:1]
    ;   - cols -> file[2:3]
    ;   - img  -> file[4:8847364]
    ; Reserve memory to read the file
    original_file_buffer:       resq    8847364
    sharpening_file_buffer:     resq    8847364
    ; Amount of reserved memory
    buffer_size:                equ     8847364
    ; Reserved memory to rows and cols
    rows                        resq    2
    cols                        resq    2
    ; Offset 'cause the first four bytes are to store the number of
    ; rows and columns in the image
    mem_offset                  equ     0x4


section .text

; if (result < 0)
to_zero:
    ; result = 0
    mov     rax, 0
    ; j++
    jmp     next_col

; if (result > 255)
to_255:
    ; result = 255
    mov     rax, 255
    ; j++
    jmp     next_col

; Kernel
; {{ 0, -1,  0},
;  {-1,  5, -1},
;  { 0, -1,  0}}
; con2_3x3(img_window)
conv2_3x3:
    ; result = 0
    mov     rbx, 0x0

    ; Compute index to get img[(i - 1)*rows + (j - 1)]
    ; rax = i - 1
    mov     rax, r10
    sub     rax, 0x1
    ; rax = (i - 1)*rows
    mov     rdx, [cols]
    imul    rdx
    ; (j - 1)
    mov     rdx, r9
    sub     rdx, 0x1
    ; rax = (i - 1)*rows + (j - 1)
    add     rax, rdx
    ; pos = rax
    mov     rsi, rax

    ; Get img[(i - 1)*rows + (j - 1)]
    mov byte al, [original_file_buffer + rsi + mem_offset]
    movzx   rax, al
    ; mask[0][0]
    mov     rdx, 0
    ; eax = mask[0][0]*img[(i - 1)*rows + (j - 1)]
    imul    rdx
    ; result += rax
    movsx   rax, eax
    add     rbx, rax


    ; Compute index to get img[(i - 1)*rows + j]
    ; rax = i - 1
    mov     rax, r10
    sub     rax, 0x1
    ; rax = (i - 1)*rows
    mov     rdx, [cols]
    imul    rdx
    ; rax = (i - 1)*rows + j
    add     rax, r9
    ; pos = rax
    mov     rsi, rax

    ; Get img[(i - 1)*rows + j]
    mov byte al, [original_file_buffer + rsi + mem_offset]
    movzx   rax, al
    ; mask[0][1]
    mov     rdx, -1
    ; eax = mask[0][1]*img[(i - 1)*rows + j]
    imul    rdx
    ; result += rax
    movsx   rax, eax
    add     rbx, rax


    ; Compute index to get img[(i - 1)*rows + (j + 1)]
    ; rax = i - 1
    mov     rax, r10
    sub     rax, 0x1
    ; rax = (i - 1)*rows
    mov     rdx, [cols]
    imul    rdx
    ; (j + 1)
    mov     rdx, r9
    add     rdx, 0x1
    ; rax = (i - 1)*rows + (j + 1)
    add     rax, rdx
    ; pos = rax
    mov     rsi, rax

    ; Get img[(i - 1)*rows + (j + 1)]
    mov byte al, [original_file_buffer + rsi + mem_offset]
    movzx   rax, al
    ; mask[0][2]
    mov     rdx, 0
    ; eax = mask[0][2]*img[(i - 1)*rows + (j + 1)]
    imul    rdx
    ; result += rax
    movsx   rax, eax
    add     rbx, rax


    ; Compute index to get img[i*rows + (j - 1)]
    ; rax = i
    mov     rax, r10
    ; rax = i*rows
    mov     rdx, [cols]
    imul    rdx
    ; (j - 1)
    mov     rdx, r9
    sub     rdx, 0x1
    ; rax = i*rows + (j - 1)
    add     rax, rdx
    ; pos = rax
    mov     rsi, rax

    ; Get img[i*rows + (j - 1)]
    mov byte al, [original_file_buffer + rsi + mem_offset]
    movzx   rax, al
    ; mask[1][0]
    mov     rdx, -1
    ; eax = mask[1][0]*img[i*rows + (j - 1)]
    imul    rdx
    ; result += rax
    movsx   rax, eax
    add     rbx, rax


    ; Compute index to get img[i*rows + j]
    ; rax = i
    mov     rax, r10
    ; rax = i*rows
    mov     rdx, [cols]
    imul    rdx
    ; rax = i*rows + j
    add     rax, r9
    ; pos = rax
    mov     rsi, rax

    ; Get img[i*rows + j]
    mov byte al, [original_file_buffer + rsi + mem_offset]
    movzx   rax, al
    ; mask[1][1]
    mov     rdx, 5
    ; eax = mask[1][1]*img[i*rows + j]
    imul    rdx
    ; result += rax
    movsx   rax, eax
    add     rbx, rax


    ; Compute index to get img[i*rows + (j + 1)]
    ; rax = i
    mov     rax, r10
    ; rax = i*rows
    mov     rdx, [cols]
    imul    rdx
    ; (j + 1)
    mov     rdx, r9
    add     rdx, 0x1
    ; rax = i*rows + (j + 1)
    add     rax, rdx
    ; pos = rax
    mov     rsi, rax

    ; Get img[i*rows + (j + 1)]
    mov byte al, [original_file_buffer + rsi + mem_offset]
    movzx   rax, al
    ; mask[1][2]
    mov     rdx, -1
    ; eax = mask[1][2]*img[i*rows + (j + 1)]
    imul    rdx
    ; result += rax
    movsx   rax, eax
    add     rbx, rax


    ; Compute index to get img[(i + 1)*rows + (j - 1)]
    ; rax = i + 1
    mov     rax, r10
    add     rax, 0x1
    ; rax = (i + 1)*rows
    mov     rdx, [cols]
    imul    rdx
    ; (j - 1)
    mov     rdx, r9
    sub     rdx, 0x1
    ; rax = (i + 1)*rows + (j - 1)
    add     rax, rdx
    ; pos = rax
    mov     rsi, rax

    ; Get img[(i + 1)*rows + (j - 1)]
    mov byte al, [original_file_buffer + rsi + mem_offset]
    movzx   rax, al
    ; mask[2][0]
    mov     rdx, 0
    ; eax = mask[2][0]*img[(i + 1)*rows + (j - 1)]
    imul    rdx
    ; result += rax
    movsx   rax, eax
    add     rbx, rax

    ; Compute index to get img[(i + 1)*rows + j]
    ; rax = i + 1
    mov     rax, r10
    add     rax, 0x1
    ; rax = (i + 1)*rows
    mov     rdx, [cols]
    imul    rdx
    ; rax = (i + 1)*rows + j)
    add     rax, r9
    ; pos = rax
    mov     rsi, rax

    ; Get img[(i + 1)*rows + j]
    mov byte al, [original_file_buffer + rsi + mem_offset]
    movzx   rax, al
    ; mask[2][1]
    mov     rdx, -1
    ; eax = mask[2][1]*img[(i + 1)*rows + j]
    imul    rdx
    ; result += rax
    movsx   rax, eax
    add     rbx, rax

    ; Compute index to get img[(i + 1)*rows + (j + 1)]
    ; rax = i + 1
    mov     rax, r10
    add     rax, 0x1
    ; rax = (i + 1)*rows
    mov     rdx, [cols]
    imul    rdx
    ; (j + 1)
    mov     rdx, r9
    add     rdx, 0x1
    ; rax = (i + 1)*rows + (j + 1)
    add     rax, rdx
    ; pos = rax
    mov     rsi, rax

    ; Get img[(i + 1)*rows + (j + 1)]
    mov byte al, [original_file_buffer + rsi + mem_offset]
    movzx   rax, al
    ; mask[2][2]
    mov     rdx, 0
    ; eax = mask[2][2]*img[(i + 1)*rows + (j + 1)]
    imul    rdx
    ; result += rax
    movsx   rax, eax
    add     rbx, rax
    
    ; if (result < 0)
    cmp     rbx, 0
    jl      to_zero

    ; if (result > 255)
    cmp     rbx, 255
    jg      to_255

    mov     rax, rbx

    jmp     next_col

; for (int j: r9 = 0; j < cols; j++)
for_cols:
    ; j++
    inc     r9
    ; conv2_3x3(img[i-1:i+2, j-1:j+2])
    jmp     conv2_3x3

; j++
next_col:
    ; Store result in the stack
    push    rax

    ; Compute index to get img[i*rows + j]
    ; rax = i
    mov     rax, r10
    ; rax = i*rows
    mov     rdx, [cols]
    imul    rdx
    ; rax = i*rows + j
    add     rax, r9
    ; pos = rax
    mov     rsi, rax

    ; Load result from the stack
    pop     rax

    ; sharpening[i][j] = result
    mov byte [sharpening_file_buffer + rsi + mem_offset], al

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

    ; i < rows
    cmp     r10, [rows]
    jl      for_cols

    ; i == row -> loop ends
    jmp     finish

; conv2(original_file_buffer, rows: r10, cols: r9)
conv2:
    push    rax
    push    rsi

    ; rows = len(img)
    mov     ax, [original_file_buffer]
    ror     ax, 8
    mov     [rows], ax

    ; cols = len(img[0])
    mov     ax, [original_file_buffer + 0x2]
    ror     ax, 8
    mov     [cols], ax

    ; i = 0
    mov     r10, 0x0
    ; j = 0
    mov     r9, 0x0

    pop     rax
    pop     rsi

    jmp     for_rows

; int main()
_start:
    ; Read original image
    ; SYS_OPEN
    mov     rax, 2
    ; const char *filename
    mov     rdi, original_filename
    ; int flags
    mov     rsi, [file_flags_orw]
    syscall

    mov     [file_descriptor], rax

    ; Read img from the file
    ; SYS_READ
    mov     rax, 0
    mov     rdi, [file_descriptor]
    mov     rsi, original_file_buffer
    ; Bytes to read
    mov     rdx, buffer_size
    syscall

    push    rax

    ; Close file Descriptor
    ; SYS_CLOSE
    mov     rax, 3
    mov     rdi, [file_descriptor]
    syscall
    
    pop     rax

    ; Read sharpening image
    ; SYS_OPEN
    mov     rax, 2
    ; const char *filename
    mov     rdi, sharpening_filename
    ; int flags
    mov     rsi, [file_flags_orw]
    syscall

    mov     [file_descriptor], rax

    ; Read img from the file
    ; SYS_READ
    mov     rax, 0
    mov     rdi, [file_descriptor]
    mov     rsi, sharpening_file_buffer
    ; Bytes to read
    mov     rdx, buffer_size
    syscall

    push    rax

    ; Close file Descriptor
    ; SYS_CLOSE
    mov     rax, 3
    mov     rdi, [file_descriptor]
    syscall

    pop     rax

    ; conv2(original_file_buffer, rows: r10, cols: r9)
    jmp     conv2

finish:
    ; Write sharpening image
    ; SYS_OPEN
    mov     rax, 2
    ; const char *filename
    mov     rdi, sharpening_filename
    ; int flags
    mov     rsi, [file_flags_crw]
    ;   int mode
    mov     rdx, [file_mode]
    syscall

    mov     [file_descriptor], rax

    ; Write the result image in the file
    ; SYS_WRITE
    mov     rax, 1
    mov     rdi, [file_descriptor]
    mov     rsi, sharpening_file_buffer
    mov     rdx, buffer_size
    syscall

    ; Slose file Descriptor
    ; SYS_CLOSE
    mov     rax, 3
    mov     rdi, [file_descriptor]
    syscall

    ; Exit
    ; SYS_EXIT
	mov     rax, 60
	mov     rdi, 0
	syscall
