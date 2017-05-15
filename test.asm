.386

stack segment use16
      db  200 dup (0)
stack ends 

code segment use16
        assume ss:stack, cs:code
start:  push dword  123
        push eax
        pop eax
        pop ax
        mov ax, 4c00h
        int 21h
code ends
end start