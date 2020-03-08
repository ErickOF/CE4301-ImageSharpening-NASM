; 0h  = '\0'
; 0Ah = '\n'
%include 'utils.asm' ; #include <utils.h>


SECTION .data
    input_img_path_str   db      'Ingrese la ruta de la imagen a abrir: ', 0h
    output_img_path_str  db      'Ingrese la ruta donde desea guardar la imagen: ', 0h
    empty_str            db      '', 0h
    new_line             db      '', 0Ah, 0h

SECTION .bss
    strinput:            resb      32
    img_content:         resb    1024

SECTION .text
    global  _start
 
_start:
    mov     eax, input_img_path_str
    call    sprint                ; sprint(input_img_path)

    call    sinput                ; input()

    mov     eax, strinput
    call    sprint                ; sprintln(input_img_path)

    mov     eax, output_img_path_str
    call    sprint                ; sprint(output_img_path)

    call    sinput                ; input()

    mov     eax, strinput
    call    sprint                ; sprintln(output_img_path)
 
    call    exit                  ; exit()
    ret