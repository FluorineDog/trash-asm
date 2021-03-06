        name    e0
        extrn   inputer:far, calcavg:far, sort:near, print:near
        public  N, sorv, info
.386
N equ 10
data    segment use16 public 'dat'
info    db  "why", 7 dup(0), 100, 85, 80, ?
        dw  ?
        db  "are", 7 dup(0), 95, 85, 80, ?
        dw  ?
        db  "you", 7 dup(0), 50, 55, 80, ?
        dw  ?
        db  "so",  8 dup(0), 86, 66, 80, ?
        dw  ?
        db  "good",6 dup(0), 76, 85, 80, ?
        dw  ?
        db  "at",  8 dup(0), 77, 60, 80, ?
        dw  ?
        db  "this",6 dup(0), 60, 85, 80, ?
        dw  ?
        db  N-8 dup("null",6 dup(0), 77, 85, 80, ?, ?, ?)
        db  "gouguilin",1 dup(0), 100, 85, 80, ?
        dw  ?
sorv    dw  10 dup(0)
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

code    segment use16 para public 'code'
                assume cs:code, ds:data, ss:stack, es:data
start:  
        mov ax, data
        mov ds, ax   
        mov es, ax
        mov di, offset info

        ; call inputer 
prep:   
        mov si, N
        lea di, info
        call calcavg

        ; push si
        ; push di
        mov si, offset info
        mov di, offset sorv
lint:
        mov [di], si
        add si, 16
        add di, 2
        cmp di, offset sorv + 2*N
        jne lint
        call sort
        call print
        ; pop di
        ; pop si

input:  
        mov dx, offset inmsg1
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
find:   
        mov ch, info[bx+di]
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
        add bx, 16
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