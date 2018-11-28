data segment
mess1 db 'Please input a string:$'
mess2 db 0ah,0dh,'The substring is:$'
buf db 10,?,10 dup(?)
data ends
code segment
assume cs:code,ds:data
start : mov ax,data
		mov ds,ax
		mov ah,09H
		lea dx,mess1
		int 21H
		mov ah,0ah
		lea dx,buf
		int 21H
		mov ah,09H
		lea dx,mess2
		int 21H
		lea si,buf+3
		mov dl,[si]
		mov ah,02H
		int 21H
		mov dl,[si+1]
		mov ah,02H
		int 21H
		mov ax,4c00H
		int 21H
code ends 
end start
		