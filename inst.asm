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
        mov word ptr backup, bx
        mov bx, es
        mov word ptr backup+2, bx


        mov bx, seg second
        mov ds, bx
        mov dx, offset second
        mov ax, 2516h
        int 21h

        mov ax, 3100h
        mov dx, 512
        int 21h
inst    endp
        backup dd ?
        dd 0CCCCh
second  proc far
        push bx
        push ax


        pushf

        pushf
        mov bx, sp
        and word ptr ss:[bx], 0CEEFh
        popf

        call dword ptr backup


        pop bx
        test bh, 0EFh   ; if 10h or 00h
        jne done
        mov bl, al
        sub bl, 'a'
        cmp bl, 26
        ja done
        sub al, ('a'-'A')
        
done:
        pop bx
        iret
second  endp
code    ends
end     start
