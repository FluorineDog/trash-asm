.386
stack   segment stack
        dw 200 dup(?)
stack   ends 


code    segment use16
                assume cs:code, ss:stack
start:
inst    proc
        mov ax, 3516h  
        int 21h
        ; result in es:bx
        mov backup, bx
        mov bx, es
        mov backup+2, bx

        mov ds, segment second
        mov dx, offset second
        mov al, 16h

        mov ax, 3100h
        mov dx, 512
        int 21h
inst    endp
        backup dd ?
second  proc far
        push bx
        push ax

        pushf
        and flags, 0CEEF
        call dword ptr backup

        pop bx
        test bh, 0EFh   ; if 10h or 00h
        jne done
        mov bl, al
        sub bl, 'a'
        cmp bl, 26
        jb done
        sub al, ('a'-'A')
done:
        pop bx
        iret
second  endp
code    ends
end     start
