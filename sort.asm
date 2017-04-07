    extrn sorv:word, N:abs 
    public sort
.386
stack segment para use16 public 'stack'
    db 200 dup(0)
stack ends

data segment para use16 public 'dat'
data ends



code segment public para use16 'code' 
    assume cs:code, ss:stack, ds:data
sort    proc uses esi dx di cx bx
; algorithm: bubble sort with no help
; stable algorithm
        
        lea si, sorv        ; init
        lea dx, [si + N]   ; destination
        
loop1:   
        mov bx, [si]    ; load ptr
        mov ax, 14[bx]  ; load first num
        
        lea di, 2[si]   ; di = si + 2
loop2:  
        mov bx, [di]
        cmp ax, 14[bx]  
        jge endif1
        xchg bx, [di]   ; swap largest ptr to bx 
        mov ax, 14[bx]  ; load num in pointed by bx
endif1:    
        add di, 2
        cmp di, dx
        jne loop2

        mov [si], bx    ; push local largest ptr to local top
        add si, 2       
        cmp si, dx
        jne loop1


        mov esi, 0
        mov ax, -1
loop3:
        mov bx, sorv[esi*2]
        cmp ax, [bx]
        je endif2
        lea cx, 1[si]
endif2: 
        mov word ptr[bx], cx
        cmp esi, N
        jne loop3

        xor ax, ax
        ret
sort    endp
code    ends
end