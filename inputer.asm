        name inputer
        public inputer
.386
include basis.inc
stack   segment use16
db      200 dup(0)
stack   ends

NAMELEN equ 10
LEN     equ 10+3+1+2

dataM    segment use16
newline db 0dh, 0ah, '$'
guard   db 10,0
inbuf   db 12 dup (0)
msg00   db "input rank of student$"
msg01   db "input name$"
msg1    db "input the first grade$"
msg2    db "input the second grade$"
msg3    db "input the third grade$"
dataM    ends

scanfs  macro 
        scanfs_ guard
        endm 

push2di  macro
        push di
        push si
        push cx
        movzx cx, byte ptr guard+1
        mov si, offset inbuf
        ; mov di, di
        ; ds, es has been set
        rep movsb
        mov byte ptr es:[di], 0
        pop cx
        pop si
        pop di
endm

code    segment use16
                assume cs:code, ds:dataM, ss:stack
radix   proc 
        push cx
        push si
        push edx
        scanfs
        mov edx, 0
        movzx cx, guard+1
        mov si, offset inbuf
radixLoop:
        test cx, cx
        jz radixEnd
        dec cx
        lodsb   ;load [si] to al
        and eax, 0Fh
        lea edx, [edx*4+edx]
        lea edx, [edx*2+eax]    ; edx*10+eax
        jmp radixLoop
radixEnd:
        mov eax, edx
        pop edx
        pop si
        pop cx
        ret
radix   endp

inputer proc far
; buf address in di
        ; mov ax, ds
        ; push ax
        push ds
        mov ax, dataM
        mov ds, ax
        ; buf address in es:di
        push di

        prints msg00    ; input rank
        call radix
        dec ax
        sal ax, 4
        add di, ax

        prints msg01    ; input name
        scanfs 
        ; mov di, di
        push2di

        prints msg1     ; input grades *1
        call radix
        mov es:[di+10], al
        
        prints msg2     ;              *2
        call radix
        mov es:[di+11], al

        prints msg3     ;              *3
        call radix
        mov es:[di+12], al

        pop di          ; restore
        ; pop ax
        ; mov ds, ax
        pop ds
        xor ax, ax      ; return void
        ret 
inputer endp
code    ends
end 