.386
STACK SEGMENT USE32 STACK
        DB 200 DUP(0)
STACK   ENDS
DATA    SEGMENT USE32
buf1    DB 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
buf2    DB 10 DUP(0)
buf3    DB 10 DUP(0)
buf4    DB 10 DUP(0)
DATA    ENDS

CODE    SEGMENT USE16
        ASSUME CS: CODE, DS: DATA, SS: STACK
START:  MOV EAX, DATA
        MOV DS, EAX
        MOV ecx, 0
LOPA:   MOV AL, buf1[ecx]
        MOV buf2[ecx], AL
        INC AL
        MOV buf3[ecx], AL
        ADD AL, 3
        MOV buf4[ecx], AL
        INC ecx
        CMP ecx,10
        JNE LOPA
        MOV AH, 4CH
        INT 21H
CODE    ENDS
END     START
