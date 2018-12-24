;The forth exam

data segment
mess1 db 'The first :$' 
mess2 db 0ah,0dh,'The second :$'
err db 0ah,0dh,'error input:$'
buf dw 10,?,10 dup(?)
data ends
code segment
assume cs:code,ds:data
start : 
		mov ax,data
		mov ds,ax
		
		mov ah,09h
		lea dx,mess1
		int 21h
		
		mov ah,0ah
		lea dx,buf
		int 21h

;		mov cl,buf+1
;		cmp cl,3
;		jb error
		
		mov ah,09h
		lea dx,mess2
		int 21h
		
		lea si,buf+3
		mov byte ptr [si+2],'$'
		lea dx,[si]
		mov ah,09h
		int 21h
		jmp exit
		
error: 	lea dx,err
		mov ah,09h
		int 21h

exit:	mov ax,4c00H
		int 21h
		
		code ends 
		end start
