; 0h  = '\0'
; 0Ah = '\n'
%include 'stdio.asm' ; #include <stdio.h>


SECTION .data
    cmd        times 100 db 'python3 imshow.py -o ', 0x0
    cmd2                 db ' -s ', 0x0
    lencmd               equ $ - cmd
    lencmd2              equ $ - cmd2
    input_img_path_str   db      'Ruta de la imagen (BMP): ', 0h
    output_img_path_str  db      'Ruta donde desea guardar la imagen (BMP): ', 0h
    width_msg            db      'Ancho de la imagen: ', 0h
    height_msg           db      'Alto de la imagen: ', 0h
    newline              db      0ah, 0h
    emptystr             db      0h
    buffer     times 256 db      0h
    input_img  times 256 db      0h
    output_img times 256 db      0h
    width      times  32 db      0h
    height     times  32 db      0h


SECTION .text
    global  _start


_start:
    ; Asking for input image
    mov     rsi, input_img_path_str
    call    sprint

    call    scanf
    mov     rsi, [buffer]
    mov     [input_img], rsi
    
    mov     rsi, input_img
    call    sprintln

    ; Asking for image width
    ; mov     rsi, width_msg
    ; call    sprint

    ; call    scanf
    ; call    str2int

    ; mov     [width], rax
    ; mov     rax, [width]

    ; call    iprint

    ; Asking for image height
    ; mov     rsi, height_msg
    ; call    sprint

    ; call    scanf
    ; call    str2int

    ; mov     [height], rax
    ; mov     rax, [height]

    ; call    iprint

    push    dword [input_img]
    pop     dword [cmd + lencmd]

    mov     rsi, cmd
    call    sprintln

    call    exit

    ret