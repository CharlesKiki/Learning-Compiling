data segment
x dd 07345678H
y dd 0f654321H
z dw 5111H
a dw ?
b dw ?
data ends
code segment
assume cs:code,ds:data
start : mov ax,data
		mov ds,ax
		mov ax,word ptr x
		mov bx,word ptr x+2
		sub ax,word ptr y
		sbb bx,word ptr y+2
		jo error
		mov dx,bx
		add ax,24
		jo error
		adc dx,0
		jo error
		mov cx,z
		idiv cx
		mov a,ax
		mov b,dx
		mov ax, 4c00H
		int 21H
error : mov dl,'f'
		mov ah,02H
		int 21H
code ends
end start