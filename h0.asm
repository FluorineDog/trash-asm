.386

data    segment use16
guard   db  10,?
in_name db  10 dup (0)
pointer dw  ?
inmsg1  db  'please enter the name of student to search:', 0dh, 0ah, '$'

grade   db  'FFFFFFDCBAA'
;       ..  '01234567890'
; inmsg2  db  'empty input, please retry.', 0dh, 0ah, 0dh, 0ah, '$'
msg2    db  'no such entry, please retry.', 0dh, 0ah, 0dh, 0ah, '$'
msg3    db  0dh, 0ah, 'the grade is $'


data    ends

stack   segment use16 stack
        db 200 dup (?)
stack   ends

code    segment use16
                assume cs:code, ds:data, ss:stack

start:
input:  mov dx, offset inmsg1
        mov ah, 9
        int 21h
        mov dx, offset guard
        mov ah, 0ah
        int 21h
        mov bl, byte ptr guard+1
        movzx bx, bl
        cmp bx, 0
        je input
        cmp bx, 1
        jne init
        cmp in_name, 'q'
        je exit
exit:   
init:
        mov ah, 4ch
        int 21h
        
code    ends
end     start

