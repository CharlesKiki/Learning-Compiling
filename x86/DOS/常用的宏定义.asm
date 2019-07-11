
; 保存dos断点

 
	push ds
	sub ax,ax
	push ax


; 寄存器进栈

pushseg macro 
	push ax
	push bx
	push cx
	push dx
	push si
	push di
endm

; 寄存器出栈

popseg macro 
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
endm

; DOS中断21H

dos21 macro nh
	mov ah,nh
	int 21h
endm

; 接收字符串

getchar macro inbuf,length                   
        lea dx,inbuf
	mov ah,0ah
	int 21h
	mov cx,length
	mov bh,0
	mov bl,inbuf+1
	sub cx,bx
getchar1:
	mov [bx+inbuf+2],20h
	inc bx
	loop getchar1
getchar endm