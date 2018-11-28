data segment
mess1 db 'Please input the first number:$'
mess2 db 0ah,0dh,'Please input the second number:$'
mess3 db 0ah,0dh,'the result is:$'
err db 0ah,0dh,'error input:$'
first db ?
second db ?
result db ?
data ends
code segment
assume cs:code,ds:data
start : mov ax,data
		mov ds,ax
		mov ah,09H
		lea dx,mess1
		int 21H
		mov ah,01H
		int 21H
		cmp al , '0'
		jb error
		sub al,30H
		mov first,al
		mov ah,09H
		lea dx,mess2
		int 21H
		mov ah,01H
		int 21H
		cmp al,'0'
		jb error
		sub al,30H
		mov second,al
		mov ah,09H
		lea dx,mess3
		int 21H
		mov dl,first
		add dl,second
		cmp dl,10
		jz next
		add dl,30H
		mov ah,02H
		int 21H
		jmp exit
next :  mov dl,31H
		mov ah,2
		int 21H
		mov dl,30H
		mov ah,2
		int 21H
		jmp exit
error : mov ah,09H
		lea dx,err
		int 21H
exit :  mov ax,4c00H
		int 21H
code ends
end start

		

		