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

putchar macro charactor_
        push ax
        push dx
        mov ah, 02h
        mov dl, charactor_
        int 21h
        pop dx
        pop ax
        endm

prints  macro message_
        push ax
        push dx
        mov dx, offset message_
        mov ah, 09h
        int 21h
        pop dx
        pop ax
        endm 

puts    macro message_
        prints message_
        clrf
        endm

scanfs_ macro guard_
        push ax
        push dx
        mov dx, offset guard_
        mov ah, 0ah
        int 21h
        clrf
        pop dx
        pop ax
        endm 

flush   macro
        push ax
        mov ax, 3
        int 10h
        pop ax
        endm