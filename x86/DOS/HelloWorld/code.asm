;程序功能 ：打印HelloWorld

data segment
	mess db 'HelloWorld.$' 
	err  db 'Something Wrong.$'
	
data ends

stack segment stack
	;这个程序没有用到堆栈段
	db '1','2','3','4','5','6','7','8','9','0'
stack ends 

code segment
assume cs:code,ds:data
	start : 
			;给DS寄存器赋值程序的数据段地址
			mov ax,data
			mov ds,ax
			
			;给SS寄存器赋值程序的堆栈段地址
			;并且堆栈的大小最多为16个byte
			mov ax,stack
			mov ss,ax
			mov sp, 16
			
			;调用9号调用，打印字符串
			mov ah,09h
			lea dx,mess
			int 21h
			jmp exit
			
	;当某处的符号位变化是逻辑上的错误标志时
	;跳转此处，并打印错误消息。9号调用
	
	error:	lea dx,err
			mov ah,09h
			int 21h

	exit:   mov ax,4c00H
			int 21h
			
code ends 
	end start
