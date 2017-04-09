    extrn sorv:word, N:abs 
    public sort
.386
stack segment para use16 public 'stack'
    db 200 dup(0)
stack ends
N2 equ N+N
data segment para use16 public 'dat'
data ends



code    segment use16 public para 'code' 
    assume cs:code, ss:stack, ds:data
sort    proc uses esi dx di cx bx bp
; algorithm: bubble sort with no help
; stable algorithm
        
        lea si, sorv    ; init
        mov dx, si      ; destination
        add dx, N
        add dx, N
        
loop1:   
        mov bp, [si]    ; load ptr
        mov al, ds:13[bp]  ; load first num
        
        lea di, 2[si]   ; di = si + 2
loop2:  
        mov bx, [di]
        cmp al, 13[bx]
        jge endif1
        xchg bp, [di]   ; swap largest ptr to bp 
        mov al, ds:13[bp]  ; load num in pointed by bx
endif1:    
        add di, 2
        cmp di, dx
        jne loop2

        mov [si], bp    ; push local largest ptr to local top
        add si, 2       
        lea ax, [si+2]
        cmp ax, dx
        jne loop1

        mov esi, 0
        mov al, -1
loop3:
        mov bx, sorv[esi*2]
        cmp al, 13[bx]
        je endif2
        lea cx, 1[si]
        mov al, 13[bx]
endif2: 
        mov 14[bx], cx
        inc esi
        cmp esi, N
        jne loop3

        xor ax, ax
        ret
sort    endp
code    ends
end