        name inputer
        public inputer
.386
stack   segment use16
db      200 dup(0)
stack   ends

NAMELEN equ 10
LEN     equ 10+3+1+2

dataM    segment use16
newline db 0dh, 0ah, '$'
guard   db 10,0
inbuf   db 12 dup (0)
msg0    db "input your message $"
msg1    db "input the first grade$"
msg2    db "input the second grade$"
msg3    db "input the third grade$"
dataM    ends

clrf    macro
        push ax
        push dx
        mov ah, 02h
        mov dl, 0dh
        int 21h
        mov dl, 0ah
        int 21h
        pop dx
        pop ax
        endm


prints  macro message
        push ax
        push dx
        mov dx, offset message
        mov ah, 09h
        int 21h
        clrf
        pop dx
        pop ax
        endm 

scanfs  macro 
        push ax
        push dx
        mov dx, offset guard
        mov ah, 0ah
        int 21h
        clrf
        pop dx
        pop ax
endm 

push2di  macro
        push di
        movzx cx, byte ptr guard+1
        mov si, offset inbuf
        ; mov di, di
        ; ds, es is set
        rep movsb
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
        mov cl, guard+1
        movzx si, byte ptr inbuf
radixLoop:
        test cl, cl
        jz radixEnd
        dec cl
        lodsb
        and eax, 0Fh
        lea edx, [edx*4+edx]
        lea edx, [edx*2+eax]
        jmp radixLoop
radixEnd:
        mov eax, edx
        pop edx
        pop si
        pop cx
        ret
radix   endp

inputer proc far
        mov ax, ds
        push ax
        mov ax, dataM
        mov ds, ax
        ; buf address in es:di, number in si
        push di
        push si
        push cx
        mov cx, si

inputerLoop:
        test cx, cx
        ; jz inputerEnd
        prints msg0
        
        scanfs 
        push2di
        
        prints msg1
        call radix
        mov es:[di+10], al
        
        ; prints msg1
        ; call radix
        ; mov es:[di+11], al

        ; prints msg1
        ; call radix
        ; mov es:[di+12], al

        add di, 16
        dec cx
        jmp inputerLoop
inputerEnd:
        pop cx
        pop si
        pop di
        pop ax
        mov ds, ax
        xor ax, ax
        ret 
inputer endp
code    ends
end 