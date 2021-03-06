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
inGuard db  2, ?
inOptn  db  2 dup(0)
pointer dw  ?
inmsg1  db  'please enter the name of student to search:', 0dh, 0ah, '$'
grade   db  'FFFFFFDCBAA'
;       ..  '01234567890'
; inmsg2  db  'empty input, please retry.', 0dh, 0ah, 0dh, 0ah, '$'
msg2    db  'no such entry, please retry.', 0dh, 0ah, 0dh, 0ah, '$'
msg3    db  0dh, 0ah, 'the grade is $'
msg4    db 'Option 1: Enter data            Option 2: Calculate averages'
        db 0dh, 0ah
        db 'Option 3: Calculate rankings    Option 4: Display report'
        db 0dh, 0ah
        db '                       Option 5: Exit'
        db 0dh, 0ah
        db '$'
data    ends
include basis.inc

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

        mov si, offset info
        mov di, offset sorv
lint:
        mov [di], si
        add si, 16
        add di, 2
        cmp di, offset sorv + 2*N
        jne lint
 
prep:   
        prints msg4
        mov si, N
        lea di, info
        scanfs_ inGuard
        lea di, info
        mov si, N
        movzx bx, byte ptr inOptn
        sub bx, '1'
        sal bx, 3
        lea bx, jmpTable[bx]
        jmp bx
jmpTable:
        call inputer
        jmp prep
        nop
        
        call calcavg
        jmp prep
        nop

        call sort
        jmp prep
        nop
        nop
        nop

        call print
        jmp prep
        nop
        nop
        nop
        
        jmp exit
        nop
        nop
        nop
        nop
        nop
        nop
        nop

        ; push si
        ; push di
       ; call print
        ; pop di
        ; pop si

       
exit:   mov ah, 4ch
        int 21h
        
code    ends
end     start
