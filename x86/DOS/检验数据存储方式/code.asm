;程序目的:检验数据存储方式

data segment
	;注：标号不是变量，只能通过取地址的方式取访问之后的内存
	x dd 07345678H
data ends
code segment
	assume cs:code,ds:data
start:
	;数据段赋值
	mov ax,data
	mov ds,ax

	;取地址，以word类型读取从X开始的地址
	mov ax,word ptr x
	mov bx,word ptr x+2
	;DOS调用退出
	mov ax,4c00H
	int 21H
code ends
end start
