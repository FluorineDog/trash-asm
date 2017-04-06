extrn sorv:word
public sort
.386
stack segment para use16 public 'stack'
    db 200 dup(0)
stack ends

data segment para use16 public 'dat'
data ends

n equ 5

code segment para use16 'code'
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
