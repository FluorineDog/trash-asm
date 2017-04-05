.386
N equ 10
NREP equ 0FFF0h   ; repeat for timing
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

dspt    proc                           ;display seconds and 1/100 seconds, resolution: 55ms							    ;this procedure does not preserve %ax
        local timestr[8]:byte           ;format : 0,0,'"',0,0,cr,lf,'$'
        push cx
        push dx         
        push ds 		        ;store %cs, %dx, %ds
        push ss 				
        pop  ds 			;%ds <- %ss Note: read & write memory, waste of time
        mov  ah, 2ch 
        int  21h                        ;call dos api to get system time
        xor  ax, ax                     ;clear %ax
        mov  al, dh                     ;%al <- seconds, now seconds in %ax
                                        ;these two operation could be repalced by movzx
        mov  cl, 10                     ;set divisor
        div  cl                         ;%ax / 10 =>  %al <- seconds / 10, %ah <- econds % 10
        add  ax,3030h                   ;convert 10 seconds and seconds to char (encoding as ASCII)
                                        ;it's okay to use "or" instead.
        mov  word ptr timestr,ax        ;Intel cpu use small end
                                        ;therefore in local string the two number not reversed
        mov  timestr+2,'"'              ;add indicator
        xor  ax,ax                
        mov  al,dl                 
        div  cl                    
        add  ax,3030h
        mov  word ptr timestr+3,ax      ;just like above
        mov  word ptr timestr+5,0a0dh   ;put cr and lf
        mov  timestr+7,'$'              ;add string::end
        lea  dx,timestr                 ;get address of timestr
        mov  ah,9                  
        int  21h                        ;call api to output timestr
        pop  ds 
        pop  dx
        pop  cx                         ;restore registers
        ret                             ;return to the caller
dspt    endp

start:  mov ax, data
        mov ds, ax   

        call dspt 

        mov di, NREP ; set di to repeat time
time1:
        mov cx, N 
        mov bx, 0
prep:   
        mov dx, 0
        movzx ax, info[bx+10]   ; code to slow down the speed
        sal ax, 2               ;
        add dx, ax              ;
        ; lea edx, [eax*4+edx]
        movzx ax, info[bx+11]   ;
        sal ax, 1               ;
        add dx, ax              ;
        ; lea edx, [eax*2+edx]
        movzx ax, info[bx+12]   ;
        add dx, ax              ;
        mov ax, dx              ;
        ; lea eax, [eax*1+edx] 
        mov dl, 7               ;
        div dl                  ;
        mov info[bx+13], al     ;
        add bx, 14
        dec cx
        test cx,cx
        jne prep
        
        dec di
        jnz time1
        call dspt 

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

