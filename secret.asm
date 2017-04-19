.386
stack   segment stack
        dw 200 dup(?)
stack   ends 
include basis.inc
data    segment
; info    db 70,117,99,107,234,52,184,239,102,114,9,142,202,32,66,226,134,229,206,47,170,70,168,78,166,238,153,38
info    db 49, 29, 26, 75, 202, 84, 200, 111, 7, 0, 108, 174, 234, 69, 55, 103, 225, 138, 187, 72, 198, 198, 56, 215
final   dd 647622310
guard   db 5, ?
inbuf   db 5 dup (?)
info1   db "Enter password$"
info2   db "Incorrect$"
data    ends


code    segment use16
                assume cs:code, ss:stack, ds:data
start:
secret  proc
        mov ax, data
        mov ds, ax
        prints info1         
        ; push dword ptr final
        scanfs_ guard
        clrf
        ; pop eax

        mov cl, guard+1
        movzx ecx, cl
        mov edi, 11
        sub edi, ecx
        mov eax, dword ptr inbuf
        lea ebx, info

        mov ecx, 3*2
loo:   
        xor [ebx], eax
        mul edi
        add ebx, 4
        dec ecx
        jne loo

        ; sub esp, 4
        ; pop ebx
        mov ebx, final
        cmp ebx, eax
        je equal
unequal:
        puts info2
        jmp done
equal:
        lea ebx, info
        push dword ptr 4[ebx]
        mov byte ptr 5[ebx], '$'
        prints [ebx]
        pop dword ptr info+4

        putchar 11
        mov ah, 5[ebx]        
        mov al, ah
        shr al, 4
        add al, '0'
        putchar al
        putchar 11
        mov al, ah
        and al, 0fh
        add al, '0'
        putchar al

        putchar 11
        mov ah, 6[ebx]        
        mov al, ah
        shr al, 4
        add al, '0'
        putchar al
        putchar 11
        mov al, ah
        and al, 0fh
        add al, '0'
        putchar al

        putchar 11
        mov ah, 7[ebx]        
        mov al, ah
        shr al, 4
        add al, '0'
        putchar al
        putchar 11
        mov al, ah
        and al, 0fh
        add al, '0'
        putchar al
        clrf
        jmp done
done:   
        mov ax, 0
        int 21h 
secret  endp
code    ends
end     start