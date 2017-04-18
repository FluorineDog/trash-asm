.386
include basis.inc
stack   segment stack
        dw 200 dup(?)
stack   ends 
data    segment 
info1   db 'not found!$'
info2   db "uninstallation over$"

data    ends

code    segment use16
                assume cs:code, ss:stack, ds:data
start:
uninst  proc
        mov ax, data
        mov ds, ax

        mov ax, 3516h
        int 21h

        mov eax, es:[bx-4]
        xor eax, 0CCCCh
        jne p404

        push ds
        mov dx, es:[bx-8]
        mov ax, es:[bx-6]
        mov ds, ax
        mov ax, 2516h
        int 21h
        pop ds

        puts info2
        jmp final
p404:   
        puts info1
        jmp final

final:  
        mov ax, 4c00h
        int 21h
uninst  endp
code    ends
end     start