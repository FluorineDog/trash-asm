.386
PUBLIC	STUBUF
EXTRN	FUN3:FAR

MAX_NUM	EQU	5
DATA1	SEGMENT	USE16
BUF1	DB	'OK!'
STUBUF	DB	'liulurong',0,0,0,0,0,0,90,90,90,90,0
		DB	'wuqilong',0,0,0,0,0,0,0,90,90,90,90,0
		DB	'lichuangqi',0,0,0,0,0,90,90,90,89,0
		DB	'lisiqing',0,0,0,0,0,0,0,90,90,90,89,0
		DB	'linlirong',0,0,0,0,0,0,90,90,90,87,0
DATA1	ENDS

STACK	SEGMENT USE16 STACK
		DB 500 DUP(0)
STACK	ENDS
CODE	SEGMENT	USE16	
		ASSUME	DS:DATA1,CS:CODE,SS:STACK
START:
		MOV AX,DATA1
		MOV	DS,AX
		CALL	FUN3
		MOV	DX,OFFSET BUF1
		MOV	AH,9
		INT 21H
		MOV	AH,4CH
		INT	21H
CODE	ENDS
END	START