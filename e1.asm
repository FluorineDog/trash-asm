.386
N equ 10
data    segment use16
info    db  "why", 7 dup(0), 100, 85, 80, ?
        db  "are", 7 dup(0), 95, 85, 80, ?
        db  "you", 7 dup(0), 50, 55, 80, ?
        db  "so",  8 dup(0), 86, 66, 80, ?
        db  "good",6 dup(0), 76, 85, 80, ?
        db  "at",  8 dup(0), 77, 60, 80, ?
        db  "this",6 dup(0), 60, 85, 80, ?
        db  N-8 dup("null",6 dup(0), 77, 85, 80, ?)
        db  "gouguilin",1 dup(0), 100, 85, 80, ?
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
start:  mov ax, data
        mov ds, ax   

        mov cx, N 
        mov bx, 0
prep:  
        mov edx, 0
        movzx eax, info[bx+10]
        lea edx, [eax*4+edx]
        movzx eax, info[bx+11]
        lea edx, [eax*2+edx]
        movzx eax, info[bx+12]
        lea eax, [eax*1+edx]
        mov dl, 7
        div dl
        mov info[bx+13], al
        add bx, 14
        dec cx
        test cx,cx
        jne prep

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

init:
        mov byte ptr in_name[bx], 0 ; set string tail = \0
        mov bp, N
        mov bx, 0
        mov di, 0
find:   mov ch, info[bx+di]
        cmp ch, in_name[di]
        jne miss
        test ch, ch
        jz succ
        inc di
        jmp find
miss:   
        dec bp
        test bp, bp
        je fail
        add bx, 14
        mov di, 0
        jmp find
fail:
        mov dx, offset msg2
        mov ah, 9
        int 21h
        jmp input
 
succ:   
        lea ax, info[bx]
        mov pointer, ax

output:
        lea dx, msg3
        mov ah, 9
        int 21h
        mov bx, pointer
        mov al, 13[bx]
        movzx ax, al
        mov cl, 10
        div cl
        movzx bx, al

        mov dl, grade[bx]
        mov ah, 02h
        int 21h

        mov dl, 0dh
        mov ah, 02h
        int 21h

        mov dl, 0ah
        mov ah, 02h
        int 21h
        jmp input
       
exit:   mov ah, 4ch
        int 21h
        
code    ends
end     start
