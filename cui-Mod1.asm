;Module 1
;Main module&functionalities 1-2
;By Shaobo Cui
;Module 2 also by myself

extrn sort:near,prinrep:near
public sorv,recs,sorted
.386
stack segment use16 para stack 'stack'
    db 200 dup(0)
stack ends

stu_rec struct
    stu_name db 11 dup(0)
    stu_scov db 4 dup(0)
    stu_rank db 0
stu_rec ends

data segment use16  para public 'dat'
n equ 5
recs stu_rec 5 dup(<>)
bufval db 0
wmval db 0
sorted db 0
sorv dw recs+9,recs+25,recs+41,recs+57,recs+73
mprom db "Please select the functionality from the following list:$"
item1 db "1. Input the records$"
item2 db "2. Calculate the weighed means$"
item3 db "3. Calculate rankings$"
item4 db "4. Print a score report$"
item5 db "5. Quit the program$"
choi db "Please indicate your choice here(by the number preceding the item):$"
iprom db "You are now providing the input for student No. $"
inpit1 db "Please provide a name:$"
inpit2 db "Please provide score for course 1:$"
inpit3 db "Please provide score for course 2:$"
inpit4 db "Please provide score for course 3:$"
rprom db "Please select the standard for ranking:$"
rank1 db "1. Weighed Mean$"
rank2 db "2. Course 1$"
rank3 db "3. Course 2$"
rank4 db "4. Course 3$"
err1 db "You haven't provided a valid input yet. Provide an input now?(y for yes,others for no):$"
err2 db "You haven't calculated the weighed mean yet. We will calculate it for you now.$"
err3 db "You haven't calculated a ranking yet.$"
err4 db "This input is invalid!$"
finp db "Calculation complete.$"
inp db 11,?,11 dup(0)
emp db 11 dup(0)
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

readchar macro 
    mov ah,1
    int 21h
endm

readstr macro strn
    lea dx,strn
    mov ah,10
    int 21h
endm

strnum macro val,invj
    sub val,30h
    cmp val,0
    jl  invj
    cmp val,9
    jg  invj
endm


code segment para use16 'code'
    assume cs:code,ss:stack,ds:data
    
menu proc
        putln mprom
        putln item1
        putln item2
        putln item3
        putln item4
        putln item5
cho:    putstr choi
        readstr inp 
        mov al,1
        cmp al,byte ptr inp+1
        jne cho
        mov al,inp+2
        lea di,inp+2
        lea si,emp
        movsd
        movsd
        movsw
        ret
menu endp

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
          mov inp+2[eax],'$' 
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
wriit2:   mov 11[ebx+8*ecx],al
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
wriit3:   mov 12[ebx+8*ecx],al
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
wriit4:   mov 13[ebx+8*ecx],al
          pop ebp
          pop di
          pop si
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

calcmean proc
        push dx
        push esi
        lea ebx,recs
        mov ecx,0
lop:    cmp ecx,2*n
        je fin
        movzx eax,byte ptr 11[ebx+8*ecx]
        movzx esi,byte ptr 12[ebx+8*ecx]
        lea eax,[2*eax+esi]
        movzx esi,byte ptr 13[ebx+8*ecx]
        lea eax,[2*eax+esi]
        mov dx,9363
        mul dx
        mov ax,dx
        mov 14[ebx+8*ecx],al
        add ecx,2
        jmp lop
fin:    pop esi
        pop dx 
        ret
calcmean endp

meanproc proc 
          cmp bufval,1
          jne proce
cont:     call calcmean
          mov wmval,1
          newline
          putln finp
          jmp compl
proce:    putln err1
          readchar
          cmp al,'y'
          jne compl
          call userinp
          mov bufval,1
          mov sorted,0
          jmp cont
compl:    ret
meanproc endp

rnkskel proc 
          cmp bufval,1
          jne bufin
choo:     newline
          putln rprom
          putln rank1
          putln rank2
          putln rank3
          putln rank4
          readchar
          sub al,30h
          cmp al,1
          jl choo
          je conv
          cmp al,4
          jg  choo
stsor:    push ax
          call sort
          pop ax
          newline
          putln finp
          mov sorted,al
gob:      ret
bufin:    newline
          putln err1
          readchar
          cmp al,'y'
          jne gob
          call userinp
          mov bufval,1
          mov wmval,0
          jmp choo
conv:     mov al,5
          cmp wmval,1
          je stsor
          newline
          putln err2
          call meanproc
          mov wmval,1
          jmp conv
rnkskel endp

start:    mov ax,data
          mov ds,ax
          mov es,ax
          jmp beg
resbuf:   mov bufval,1
          mov sorted,0
          mov wmval,0          
beg:      call menu
          cmp al,31h
          je inpu
          cmp al,32h
          je mean
          cmp al,33h
          je rank
          cmp al,34h
          je report
          cmp al,35h
          je exit
          putln err4
          jmp beg
inpu:     call userinp
          jmp resbuf
mean:     call meanproc
          jmp beg
rank:     call rnkskel
          jmp beg
report:   cmp bufval,1
          je  chk2
          newline
          putln err1
          readchar
          cmp al,'y'
          jne beg
          call userinp
          mov bufval,1
          mov wmval,0
          mov sorted,0
chk2:     cmp wmval,1
          je chkf
          newline
          putln err2
          call meanproc
          mov wmval,1
chkf:     cmp sorted,0
          jne rcal
          putln err3
          call rnkskel
rcal:     call prinrep
          jmp beg
exit:     newline
          mov ah,4ch
          int 21h
code ends
end start