stu_rec struct
    stu_name db 10 dup(0)
    stu_scov db 4 dup(0)
    stu_rank dw 0
stu_rec ends
extrn recs:stu_rec
public calcmean
.386
stack segment use16 para stack 'stack'
    db 200 dup(0)
stack ends
n equ 5
code segment use16 para public 'code'
calcmean proc
        push dx
        push esi
        lea ebx,recs
        mov ecx,0
lop:    cmp ecx,2*n
        je fin
        movzx eax,byte ptr 10[ebx+8*ecx]
        movzx esi,byte ptr 11[ebx+8*ecx]
        lea eax,[2*eax+esi]
        movzx esi,byte ptr 12[ebx+8*ecx]
        lea eax,[2*eax+esi]
        mov dx,9363
        mul dx
        mov ax,dx
        mov 13[ebx+8*ecx],al
        add ecx,2
        jmp lop
fin:    pop esi
        pop dx 
        ret
calcmean endp
code ends
end