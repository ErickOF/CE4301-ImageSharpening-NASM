; 0h  = '\0'
; 0Ah = '\n'
%include 'utils.asm' ; #include <utils.h>


SECTION .data
input_img_path   db  'Ingrese la ruta de la imagen a abrir: ', 0h
output_img_path  db  'Ingrese la ruta donde desea guardar la imagen: ', 0h
empty_str        db  '', 0h
new_line         db  '', 0Ah, 0h

SECTION .text
    global  _start
 
_start:
    mov     eax, input_img_path
    call    sprint                ; sprint(input_img_path)

    mov     eax, new_line
    call    sprint                ; sprint(new_line)

    mov     eax, output_img_path
    call    sprint                ; sprint(output_img_path)

    mov     eax, new_line
    call    sprint                ; sprint(new_line)
 
    call    exit                  ; exit()