.386

clrf    macro 
        push eax
        push edx
        mov ah, 2
        mov dl,0ah
        int 21h
        mov dl,0dh
        int 21h
        pop edx
        pop eax
endm

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
divtble db 0, 0, 0, 0, 0, 0, 0
        db 1, 1, 1, 1, 1, 1, 1
        db 2, 2, 2, 2, 2, 2, 2
        db 3, 3, 3, 3, 3, 3, 3
        db 4, 4, 4, 4, 4, 4, 4
        db 5, 5, 5, 5, 5, 5, 5
        db 6, 6, 6, 6, 6, 6, 6
        db 7, 7, 7, 7, 7, 7, 7
        db 8, 8, 8, 8, 8, 8, 8
        db 9, 9, 9, 9, 9, 9, 9
        db 10, 10, 10, 10, 10, 10, 10
        db 11, 11, 11, 11, 11, 11, 11
        db 12, 12, 12, 12, 12, 12, 12
        db 13, 13, 13, 13, 13, 13, 13
        db 14, 14, 14, 14, 14, 14, 14
        db 15, 15, 15, 15, 15, 15, 15
        db 16, 16, 16, 16, 16, 16, 16
        db 17, 17, 17, 17, 17, 17, 17
        db 18, 18, 18, 18, 18, 18, 18
        db 19, 19, 19, 19, 19, 19, 19
        db 20, 20, 20, 20, 20, 20, 20
        db 21, 21, 21, 21, 21, 21, 21
        db 22, 22, 22, 22, 22, 22, 22
        db 23, 23, 23, 23, 23, 23, 23
        db 24, 24, 24, 24, 24, 24, 24
        db 25, 25, 25, 25, 25, 25, 25
        db 26, 26, 26, 26, 26, 26, 26
        db 27, 27, 27, 27, 27, 27, 27
        db 28, 28, 28, 28, 28, 28, 28
        db 29, 29, 29, 29, 29, 29, 29
        db 30, 30, 30, 30, 30, 30, 30
        db 31, 31, 31, 31, 31, 31, 31
        db 32, 32, 32, 32, 32, 32, 32
        db 33, 33, 33, 33, 33, 33, 33
        db 34, 34, 34, 34, 34, 34, 34
        db 35, 35, 35, 35, 35, 35, 35
        db 36, 36, 36, 36, 36, 36, 36
        db 37, 37, 37, 37, 37, 37, 37
        db 38, 38, 38, 38, 38, 38, 38
        db 39, 39, 39, 39, 39, 39, 39
        db 40, 40, 40, 40, 40, 40, 40
        db 41, 41, 41, 41, 41, 41, 41
        db 42, 42, 42, 42, 42, 42, 42
        db 43, 43, 43, 43, 43, 43, 43
        db 44, 44, 44, 44, 44, 44, 44
        db 45, 45, 45, 45, 45, 45, 45
        db 46, 46, 46, 46, 46, 46, 46
        db 47, 47, 47, 47, 47, 47, 47
        db 48, 48, 48, 48, 48, 48, 48
        db 49, 49, 49, 49, 49, 49, 49
        db 50, 50, 50, 50, 50, 50, 50
        db 51, 51, 51, 51, 51, 51, 51
        db 52, 52, 52, 52, 52, 52, 52
        db 53, 53, 53, 53, 53, 53, 53
        db 54, 54, 54, 54, 54, 54, 54
        db 55, 55, 55, 55, 55, 55, 55
        db 56, 56, 56, 56, 56, 56, 56
        db 57, 57, 57, 57, 57, 57, 57
        db 58, 58, 58, 58, 58, 58, 58
        db 59, 59, 59, 59, 59, 59, 59
        db 60, 60, 60, 60, 60, 60, 60
        db 61, 61, 61, 61, 61, 61, 61
        db 62, 62, 62, 62, 62, 62, 62
        db 63, 63, 63, 63, 63, 63, 63
        db 64, 64, 64, 64, 64, 64, 64
        db 65, 65, 65, 65, 65, 65, 65
        db 66, 66, 66, 66, 66, 66, 66
        db 67, 67, 67, 67, 67, 67, 67
        db 68, 68, 68, 68, 68, 68, 68
        db 69, 69, 69, 69, 69, 69, 69
        db 70, 70, 70, 70, 70, 70, 70
        db 71, 71, 71, 71, 71, 71, 71
        db 72, 72, 72, 72, 72, 72, 72
        db 73, 73, 73, 73, 73, 73, 73
        db 74, 74, 74, 74, 74, 74, 74
        db 75, 75, 75, 75, 75, 75, 75
        db 76, 76, 76, 76, 76, 76, 76
        db 77, 77, 77, 77, 77, 77, 77
        db 78, 78, 78, 78, 78, 78, 78
        db 79, 79, 79, 79, 79, 79, 79
        db 80, 80, 80, 80, 80, 80, 80
        db 81, 81, 81, 81, 81, 81, 81
        db 82, 82, 82, 82, 82, 82, 82
        db 83, 83, 83, 83, 83, 83, 83
        db 84, 84, 84, 84, 84, 84, 84
        db 85, 85, 85, 85, 85, 85, 85
        db 86, 86, 86, 86, 86, 86, 86
        db 87, 87, 87, 87, 87, 87, 87
        db 88, 88, 88, 88, 88, 88, 88
        db 89, 89, 89, 89, 89, 89, 89
        db 90, 90, 90, 90, 90, 90, 90
        db 91, 91, 91, 91, 91, 91, 91
        db 92, 92, 92, 92, 92, 92, 92
        db 93, 93, 93, 93, 93, 93, 93
        db 94, 94, 94, 94, 94, 94, 94
        db 95, 95, 95, 95, 95, 95, 95
        db 96, 96, 96, 96, 96, 96, 96
        db 97, 97, 97, 97, 97, 97, 97
        db 98, 98, 98, 98, 98, 98, 98
        db 99, 99, 99, 99, 99, 99, 99
        db 100
msg2    db  'no such entry, please retry.', 0dh, 0ah, 0dh, 0ah, '$'
msg3    db  'the grade is $'


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

        call dspt       ; 
        mov di, 1    ; initialize timer
time1:
        mov cx, N 
        mov bx, 0
prep:   
        mov edx, 0
        movzx eax, info[bx+10]
        lea edx, [eax*4+edx]
        movzx eax, info[bx+11]
        lea edx, [eax*2+edx]
        movzx eax, info[bx+12]
        lea edx, [eax*1+edx]
        ; mov dl, 7    ; old code using division
        ; div dl       ; removed
        mov al, divtble[edx]    ; new code with direct table

        mov info[bx+13], al
        add bx, 14
        dec cx
        jne prep
        
        dec di          ; extra loops
        jnz time1       ;
        call dspt       ;

input:  mov dx, offset inmsg1
        mov ah, 9
        int 21h
        mov dx, offset guard
        mov ah, 0ah
        int 21h
        clrf
        mov bl, byte ptr guard+1
        movzx bx, bl
        cmp bx, 0
        je input
        cmp bx, 1
        jne initbg
        cmp in_name, 'q'
        je exit
initbg:
        call dspt       ;
        mov eax, NREP   ; init timer

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

        dec eax         ; extra loops
        jne init        ; 
        call dspt       ;

        mov dx, offset msg2
        mov ah, 9
        int 21h
        jmp input
 
succ:   

        dec eax         ; extra loops
        jne init        ; 
        call dspt       ;

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

        clrf
        clrf
        jmp input
       
exit:   mov ah, 4ch
        int 21h
        
code    ends
end     start


