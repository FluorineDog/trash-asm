;Module 2
;Main module&functionalities 3-4
;By Shaobo Cui
;Module 1 also by myself

stu_rec struct
    stu_name db 11 dup(0)
    stu_scov db 4 dup(0)
    stu_rank db 0
stu_rec ends
extrn sorv:word,recs:stu_rec,sorted:byte
public sort,prinrep
.386
stack segment para use16 public 'stack'
    db 200 dup(0)
stack ends

data segment para use16 'dat'
        n equ 5
     hint db "    Name    Ranking  Mean $"  
     space db "     $" 
data ends

newline macro
    mov dl,0dh
    mov ah,2
    int 21h
    mov dl,0ah
    int 21h
endm

putstr macro strn
    lea dx,strn
    mov ah,9
    int 21h
endm

putln macro strn
    putstr strn
    newline
endm

printscore macro m
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
        mov ah,2
        pop dx
        int 21h
        pop dx
        int 21h
        pop dx
        int 21h
        pop dx
endm

code segment para use16 public 'code'
    assume cs:code,ss:stack,ds:data
    sort proc 
        push dx
        push esi
        push edi
        push ebp
        movzx eax,al
        mov ecx,0
        mov edi,0
sor:    cmp ecx,n
        je  com
        lea ebx,sorv[2*ecx]
        mov dl,0
        mov esi,ebx
finm:   cmp ebx,offset sorv+2*n
        je  conts
        mov di,[ebx]
        cmp [edi+eax],dl
        jle noxc
        mov esi,ebx
        mov dl,[edi+eax]
noxc:   add ebx,2
        jmp finm
conts:  mov di,[esi]
        mov bp,sorv[2*ecx]
        mov sorv[2*ecx],di
        mov [esi],bp
        inc ecx
        jmp sor
com:    lea ecx,sorv
        mov bl,-1
        mov dl,0
        mov bh,0
        mov ebp,0
wr:     cmp ecx,offset sorv+2*n
        je  bak
        mov bp,[ecx]
        cmp [ebp+eax],bl
        je  plu
        mov bl,[ebp+eax]
        add dl,bh
        inc dl
        mov bh,0
        mov 6[ebp],dl
        add ecx,2
        jmp wr
plu:    mov 6[ebp],dl
        inc bh
        add ecx,2
        jmp wr
bak:    pop ebp
        pop edi
        pop esi
        pop dx        
        ret
sort endp

prinrep proc
        newline
        putln hint
        mov ecx,0
beg:    cmp ecx,2*n
        je  fin
        putstr recs[8*ecx]
        putstr space
        push ecx
        printscore byte ptr recs+15[8*ecx]
        pop ecx
        putstr space
        push ecx
        printscore byte ptr recs+14[8*ecx]
        pop ecx
        newline
        add ecx,2
        jmp beg
fin:    ret
prinrep endp
code ends
end