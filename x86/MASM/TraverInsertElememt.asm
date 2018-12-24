;Purpose: This program is uesd to traver a sorted list
;The is insert element is unsign element
;The first of the list element is a number that the list length
;After insert the element , the list length will add one.
;
;Environment: MASM tools,DOS 

data segment
list dw 5,20h,30h,40h,50h,60h
;The element is liner in memory,it is not a char
;20h~60h has no meaning,it can not print
x dw 36h
;x used to save varibal
data ends

code segment
assume cs:code,ds:data
;If you want to see the memory value.
;Like data segement
;DO NOT SEE CS SEGMENT
start:  
		mov ax,data
		;ax = ds
		mov ds,ax
		;
		mov ax,x
		lea bx,list
		;bx is the start of list
		mov cx,[bx]
		;now,the cx is the length of list
Compare: 
		add bx,2
		cmp ax,[bx]
		;[bx] is the list element
		;The logical insert ,if the value of [bx] is more than ax 
		jc ElementOffset
		loop Compare
ElementOffset: 
;Offset the index
	xchg ax,[bx]
	;exchange value
	add bx ,2
	;location offset
	loop ElementOffset
	mov [bx],ax
	inc word ptr list 
	;the first of list element add 1,length add 1
	mov ax ,4c00h
	;call INT 21H 4CH interrupt, safety exit
	int 21h
code ends
end start