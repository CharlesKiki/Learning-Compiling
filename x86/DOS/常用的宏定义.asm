
; ����dos�ϵ�

 
	push ds
	sub ax,ax
	push ax


; �Ĵ�����ջ

pushseg macro 
	push ax
	push bx
	push cx
	push dx
	push si
	push di
endm

; �Ĵ�����ջ

popseg macro 
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
endm

; DOS�ж�21H

dos21 macro nh
	mov ah,nh
	int 21h
endm

; �����ַ���

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