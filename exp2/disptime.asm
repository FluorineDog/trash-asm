
disptime proc        			    ;display seconds and 1/100 seconds, resolution: 55ms
								    ;this procedure does not preserve %ax
    local timestr[8]:byte           ;format : 0,0,'"',0,0,cr,lf,'$'
         push cx
         push dx         
         push ds 				    ;store %cs, %dx, %ds
         push ss 				
         pop  ds 				    ;%ds <- %ss Note: read & write memory, waste of time
         mov  ah, 2ch 
         int  21h                   ;call dos api to get system time
         xor  ax, ax                ;clear %ax
         mov  al, dh                ;%al <- seconds, now seconds in %ax
                                    ;these two operation could be repalced by movzx
         mov  cl, 10                ;set divisor
         div  cl                    ;%ax / 10 =>  %al <- seconds / 10, %ah <- econds % 10
         add  ax,3030h              ;convert 10 seconds and seconds to char (encoding as ASCII)
                                    ;it's okay to use "or" instead.
         mov  word ptr timestr,ax   ;Intel cpu use small end
                                    ;therefore in local string the two number not reversed
         mov  timestr+2,'"'         ;add indicator
         xor  ax,ax                
         mov  al,dl                 
         div  cl                    
         add  ax,3030h
         mov  word ptr timestr+3,ax ;just like above
         mov  word ptr timestr+5,0a0dh ;put cr and lf
         mov  timestr+7,'$'         ;add string::end
         lea  dx,timestr            ;get address of timestr
         mov  ah,9                  
         int  21h                   ;call api to output timestr
         pop  ds 
         pop  dx
         pop  cx                    ;restore registers
         ret                        ;return to the caller
disptime	endp