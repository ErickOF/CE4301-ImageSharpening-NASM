; 0h  = '\0'
; 0Ah = '\n'
%include './asm/utils/stdio.asm' ; #include <stdio.h>


SECTION .data
    newline              db      0ah, 0h
    emptystr             db      0h
    buffer     times 256 db      0h


SECTION .text
    global  _start


_start:
    call    exit

    ret