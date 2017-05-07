.386
stack   segment stack
        dw 200 dup(?)
stack   ends 
include basis.inc
data    segment 
guard   db 2,?
buf     db ?,?
outp    db ?,?,'$'
data    ends

code    segment use16
                assume cs:code, ss:stack, ds:data
start:
cmos    proc
        mov ax, data
        mov ds, ax

        scanfs_ guard
        mov al, buf
        and al, 0fh
        
        out 70h, al
        in  al, 71h

        mov bl, al
        and bl, 0fh
        add bl, '0'
        mov outp+1, bl
        shr al, 4
        add al, '0'
        mov outp, al
        prints outp
        mov ax, 4c00h
        int 21h
cmos    endp
code    ends
end     start