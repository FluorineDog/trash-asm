	extrn info:byte, N:abs 
	public print
.386
stack	segment para use16 public 'stack'
        db 200 dup(0)
stack	ends

data	segment para use16 public 'dat'
msg0	db '| Name      | Chinese  |   Math   |  English |  Average |   rank   |', '$'
	;   012345678901
msg1	db '*-', 6 dup( 10 dup('-'), '*'), '$'
prefix	db '| $'
outbuf	db 10 dup (' ') 
	db '|$'
data	ends

include basis.inc



code	segment use16 public para 'code' 
	    assume cs:code, ss:stack, ds:data
itos	proc uses dx bx cx di
        mov dx,di

 	mov cx, 10
	mov al, ' '
	lea di, outbuf
	rep stosb 

       ;num in di
        mov bl,10
        mov ax,dx
        div bl
        movzx dx,al
        movzx ax,ah
        or ax,30h
        mov outbuf+5, al
	test dx, dx
	je itosDone

        mov ax,dx
        div bl
        movzx dx,al
        movzx ax,ah
        or ax,30h
        mov outbuf+4, al
	test dx, dx
	je itosDone

        mov ax,dx
        div bl
        movzx dx,al
        movzx ax,ah
        or ax,30h
        mov outbuf+3, al
itosDone:
	ret
itos	endp

print	proc uses es bx bp cx si di
	mov ax, ds
	mov es, ax
	puts msg1
	puts msg0
	puts msg1

	lea bx, info
	mov bp, N
loop1:

	mov si, bx
	lea di, outbuf
	mov cx, 10
	rep movsb

	mov cx, 10
	mov al, 0
	lea di, outbuf
	repnz scasb
	mov al, ' '
	rep stosb 
	prints prefix
	prints outbuf

	mov cx, 10
	mov al, ' '
	lea di, outbuf
	rep stosb 
	movzx di, byte ptr 10[bx]
	call itos	
	prints outbuf

	movzx di, byte ptr 11[bx]
	call itos	
	prints outbuf

	movzx di, byte ptr 12[bx]
	call itos	
	prints outbuf

	movzx di, byte ptr 13[bx]
	call itos	
	prints outbuf

	mov di, 14[bx]
	call itos	
	prints outbuf
	clrf
	prints msg1
	clrf
	add bx, 16
	dec bp
	jnz loop1
	xor ax, ax
	ret	
print	endp

code	ends
end 