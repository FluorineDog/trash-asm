convToChars macro m
        push dx
        movzx dx,m
        mov bl,10
        mov ax,dx
        div bl
        movzx dx,al
        movzx ax,ah
        or ax,30h
        push ax
        mov ax,dx
        div bl
        movzx dx,al
        movzx ax,ah
        or ax,30h
        push ax
        mov ax,dx
        div bl
        movzx dx,al
        movzx ax,ah
        or ax,30h
        push ax
endm    