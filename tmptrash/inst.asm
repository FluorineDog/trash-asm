.386
stack   segment stack
        dw 200 dup(?)
stack   ends 
include basis.inc
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
        and word ptr ss:[bp], 0FCFFh
        popf

        ; call dword ptr backup
        push seg NEWP
        push offset NEWP
        jmp backup
NEWP:
        pop bx
        test bh, 0EFh   ; if 10h or 00h
        jne done
        mov bl, al
        sub bl, 'a'
        cmp bl, 26
        ja done
        sub al, ('a'-'A')
        putchar 07h
done:
        pop bx
        iret
second  endp
code    ends
end     start
