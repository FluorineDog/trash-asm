;User input module
;By Shaobo Cui
;In cooperation with Guilin Gou
stu_rec struct
    stu_name db 10 dup(0)
    stu_scov db 4 dup(0)
    stu_rank dw 0
stu_rec ends
extrn recs:stu_rec
public userinp
.386
include macros.lib
stack segment use16 para stack 'stack'
    db 200 dup(0)
stack ends

data segment use16  para public 'dat'
iprom db "You are now providing the input for student No. $"
inpit1 db "Please provide a name:$"
inpit2 db "Please provide score for course 1:$"
inpit3 db "Please provide score for course 2:$"
inpit4 db "Please provide score for course 3:$"
inp db 11,?,11 dup(0),0
emp db 11 dup(0)
n equ 5
data ends

code segment use16 para public 'code'
        assume cs:code,ds:data,ss:stack
getrec proc
          push si
          push di
          push ebp
          newline
          putstr inpit1
          sub ecx,1
          sal ecx,1
          readstr inp
          movzx eax,inp+1
          mov inp+2[eax],0 
          lea si,inp+2
          lea di,[ebx+8*ecx]
          movsd
          movsd
          movsw
          lea di,inp+2
          lea si,emp
          movsd
          movsd
          movsw
          newline
it2:      putstr inpit2
          readstr inp
          mov eax,0
          mov dl,inp+1
          cmp dl,3
          je hund2
          cmp dl,2
          je ten2
          cmp dl,1
          je one2
          jmp it2
hund2:    mov al,inp+2
          strnum al,it2
          mov dl,100
          mul dl
          mov dl,inp+3
          strnum dl,it2
          movzx edx,dl
          lea ebp,[2*edx]
          lea edx,[ebp+8*edx]
          add ax,dx
          mov dl,inp+4
          strnum dl,it2
          add al,dl
          jmp wriit2
ten2:     mov dl,inp+2
          strnum dl,it2
          movzx edx,dl
          lea ebp,[2*edx]
          lea edx,[ebp+8*edx]
          add ax,dx
          mov dl,inp+3
          strnum dl,it2
          add al,dl
          jmp wriit2
one2:     mov al,inp+2
          strnum al,it2
wriit2:   mov 10[ebx+8*ecx],al
          newline
it3:      putstr inpit3
          readstr inp
          mov dl,inp+1
          mov eax,0
          cmp dl,3
          je hund3
          cmp dl,2
          je ten3
          cmp dl,1
          je one3
          jmp it3
hund3:    mov al,inp+2
          strnum al,it3
          mov dl,100
          mul dl
          mov dl,inp+3
          strnum dl,it3
          movzx edx,dl
          lea ebp,[2*edx]
          lea edx,[ebp+8*edx]
          add ax,dx
          mov dl,inp+4
          strnum dl,it3
          add al,dl
          jmp wriit3
ten3:     mov dl,inp+2
          strnum dl,it3
          movzx edx,dl
          lea ebp,[2*edx]
          lea edx,[ebp+8*edx]
          add ax,dx
          mov dl,inp+3
          strnum dl,it3
          add al,dl
          jmp wriit3
one3:     mov al,inp+2
          strnum al,it3
wriit3:   mov 11[ebx+8*ecx],al
          newline
it4:      putstr inpit4
          readstr inp
          mov eax,0
          mov dl,inp+1
          cmp dl,3
          je hund4
          cmp dl,2
          je ten4
          cmp dl,1
          je one4
          jmp it4
hund4:    mov al,inp+2
          strnum al,it4
          mov dl,100
          mul dl
          mov dl,inp+3
          strnum dl,it4
          movzx edx,dl
          lea ebp,[2*edx]
          lea edx,[ebp+8*edx]
          add ax,dx
          mov dl,inp+4
          strnum dl,it4
          add al,dl
          jmp wriit4
ten4:     mov dl,inp+2
          strnum dl,it4
          movzx edx,dl
          lea ebp,[2*edx]
          lea edx,[ebp+8*edx]
          add ax,dx
          mov dl,inp+3
          strnum dl,it4
          add al,dl
          jmp wriit4
one4:     mov al,inp+2
          strnum al,it4
wriit4:   mov 12[ebx+8*ecx],al
          pop ebp
          pop di
          pop si
          clearscreen
          ret
getrec endp

userinp proc
          push ebx
          mov ecx,1
          lea ebx,recs
rein:     cmp cl,n
          jg fin
          newline
          putstr iprom
          mov dl,cl
          add dl,30h
          mov ah,2
          int 21h
          push ecx
          call getrec
          pop ecx
          inc ecx
          jmp rein
fin:      pop ebx
          ret
userinp endp
code ends
end