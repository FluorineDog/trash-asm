	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "g0.c"
_TEXT	segment	byte public 'CODE'
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP,ss:DGROUP
_TEXT	ends
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
	?debug	C E9FA827D4A0467302E63
	?debug	C E92E7B7D4A15433A5C54435C494E434C5544455C737464696F2E68
	?debug	C E92E7B7D4A16433A5C54435C494E434C5544455C7374646172672E+
	?debug	C 68
_BSS	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 3
_main	proc	near
@4:
;	?debug	L 5
	mov	ax,offset DGROUP:s@
	push	ax
	call	near ptr _printf
	pop	cx
@2:
;	?debug	L 6
	mov	ax,offset DGROUP:_in_name
	push	ax
	mov	ax,offset DGROUP:s@+45
	push	ax
	call	near ptr _scanf
	pop	cx
	pop	cx
	or	ax,ax
	je	@4
@3:
;	?debug	L 7
	cmp	byte ptr DGROUP:_in_name,0
	jne	@5
;	?debug	L 8
	jmp	short @6
@5:
;	?debug	L 10
	mov	ax,offset DGROUP:s@+48
	push	ax
	call	near ptr _printf
	pop	cx
@6:
;	?debug	L 12
	xor	ax,ax
	jmp	short @1
@1:
;	?debug	L 13
	ret	
_main	endp
_TEXT	ends
_BSS	segment word public 'BSS'
_in_name	label	byte
	db	10 dup (?)
_BSS	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
	db	112 	; please
	db	108 	;
	db	101 	;
	db	97	;
	db	115	;
	db	101	;
	db	32	
	db	101
	db	110
	db	116
	db	101
	db	114
	db	32
	db	116
	db	104
	db	101
	db	32
	db	110
	db	97
	db	109
	db	101
	db	32
	db	111
	db	102
	db	32
	db	115
	db	116
	db	117
	db	100
	db	101
	db	110
	db	116
	db	32
	db	116
	db	111
	db	32
	db	115
	db	101
	db	97
	db	114
	db	99
	db	104
	db	58
	db	10
	db	0
	db	37
	db	115
	db	0
	db	112
	db	114
	db	111
	db	99
	db	101
	db	115
	db	115
	db	105
	db	110
	db	103
	db	10
	db	0
_DATA	ends
_TEXT	segment	byte public 'CODE'
	extrn	_printf:near
	extrn	_scanf:near
_TEXT	ends
	public	_in_name
	public	_main
	end
