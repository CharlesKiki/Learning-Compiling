dseg segment
	org 10h
	myaddr dw $
	bvar db 1,2,3
		db '123'
	buf db 5 dup(?)
	even
	len1 = $-bvar
	wvar dw 1,2
	len2 equ $-dvar
	len3 equ buf-bvar
dseg ends
mov ax,offset dvar
mov ax,len1
mov ax,len2
mov ax,len3
mov ax,myaddr
mov ax,word ptr bvar+2
mov ax,lengthof wvar+lengthof bvar
mov ax,type dvar+sizeof bvar
mov ax,word ptr dvar+1