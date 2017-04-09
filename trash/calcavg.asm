
.386
public calcavg
stack   segment stack use16
        db 100 dup(0)
stack   ends



code    segment use16
        assume cs:code, ss:stack
calcavg proc far uses edx edi esi
; buf addreess in es:di, size in si
calcAvgLoop:
        mov edx, 0
        movzx eax, byte ptr es:[di+10]
        lea edx, [eax*4+edx]

        movzx eax, byte ptr es:[di+11]
        lea edx, [eax*2+edx]

        movzx eax, byte ptr es:[di+12]
        lea eax, [eax*1+edx]

        mov dl, 7
        div dl

        mov es:[di+13], al
        add di, 16
        dec si
        jne calcAvgLoop
        xor eax, eax
        ret
calcavg endp        

code    ends
end