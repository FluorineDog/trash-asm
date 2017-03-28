.386
STACK SEGMENT USE16 STACK
        DB 200 DUP(0)
STACK   ENDS
DATA    SEGMENT USE16
BUF1    DB 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
BUF2    DB 10 DUP(0)
BUF3    DB 10 DUP(0)
BUF4    DB 10 DUP(0)
STR1    DB 'Press any key to begin!$'
DATA    ENDS
CODE    SEGMENT USE16
        ASSUME CS: CODE, DS: DATA, SS: STACK
START:  mov AX, DATA
        mov DS, AX
        mov SI, OFFSET BUF1
        mov DI, OFFSET BUF2
        mov BX, OFFSET BUF3
        mov BP, OFFSET BUF4
        mov CX, 10

MYCODE: lea DX, STR1
        mov AH, 9
        int 21H
        mov AH, 1
        int 21H

LOPA:   mov AL, [SI]
        mov [DI], AL
        inc AL
        mov [BX], AL
        add AL, 3
        mov DS:[BP], AL
        inc SI
        inc DI
        inc BP
        inc BX
        dec CX
        jnz LOPA
        mov AH, 4CH
        int 21H
CODE    ENDS
END     START