;Main module
;By Shaobo Cui
;In cooperation with Guilin Gou

extrn userinp:near,calcmean:near,sort:near,print:near
public sorv,recs,sorted
.386
include macros.lib
stack segment use16 para stack 'stack'
    db 200 dup(0)
stack ends

stu_rec struct
    stu_name db 10 dup(0)
    stu_scov db 4 dup(0)
    stu_rank dw 0
stu_rec ends

data segment use16  para public 'dat'
n equ 5
recs stu_rec 5 dup(<>)
bufval db 0
wmval db 0
sorted db 0
sorv dw recs,recs+16,recs+32,recs+64,recs+80
mprom db "Please select the functionality from the following list:$"
item1 db "1. Input the records$"
item2 db "2. Calculate the weighed means$"
item3 db "3. Calculate rankings$"
item4 db "4. Print a score report$"
item5 db "5. Quit the program$"
choi db "Please indicate your choice here(by the number preceding the item):$"
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
minp db 3,?,3 dup(0)
memp db 3 dup(0)
data ends

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
        readstr minp 
        mov al,1
        cmp al,byte ptr minp+1
        jne cho
        mov al,minp+2
        lea di,minp+2
        lea si,memp
        movsw
        movsb
        ret
menu endp


meanproc proc 
          cmp bufval,1
          jne proce
cont:     call calcmean
          mov wmval,1
          clearscreen
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
          clearscreen
          putln finp
          mov sorted,1
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
          clearscreen
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
rcal:     call print
          jmp beg
exit:     newline
          mov ah,4ch
          int 21h
code ends
end start