
data segment
	strmess db 'Please input a string(length<9):$'
	nummess db 0ah,0dh,'Please input the number you want to display:$'
	charmess db 0ah,0dh,'the char is:$'
	errmess1 db 0ah,0dh,'the length of the string you input error!$'
	errmess2 db 0ah,0dh,'the number you input is too large!$'
	;缓冲区大小20byte
	buf db 20 dup (0)
	;记录用户输入的数字
	num db ?
data ends
code segment
	assume cs:code,ds:data
	start :
			;段地址初始化
			mov ax,data
			mov ds,ax

			;9号打印调用
	input0: lea dx,strmess
			mov ah,09h
			int 21h

			;初始化bx寄存器，用于当作缓冲区的下标
			mov bx,0
	input1:
			;DOS1号功能的调用，输入下标
			mov ah,1
			int 21h

			;AL为出口参数，接收键盘输入
			mov buf[bx],al ;等价于mov buf[0],al
			;bx自加，buf缓冲区下一字节单元
			inc bx

			;回车的ASCII码,用意是按键=回车,则表示完成输入
			;这个操作相当于直接回车
			cmp al,0dh
			jnz input1

			;什么都不输入的情况
			cmp bx,0
			jbe err

			;当输入的值值达到9个了
			cmp bx,9
			jbe con

	err:    lea dx,errmess1
			mov ah,09h
			int 21h

			mov dl,0ah
			mov ah,2
			int 21h
			mov dl,0dh
			mov ah,2
			int 21h

			jmp input0

			;显示字符串
	con:    lea dx,nummess
			;9号调用
			mov ah,09h
			int 21h

			;1号调用
			mov ah,01h
			int 21h
			;al的值位输入的一个长度大小的字符，转化为值
			sub al,30h

			;ah寄存器初始化
			mov ah,0
			;记录要查看的长度大小
			mov num,al

			;BX输入的字符串大小，AX
			cmp ax,bx
			jp con2

			;如果没跳转。则进入错误
			lea dx,errmess2
			mov ah,09h
			int 21h
			jmp con

	con2:
			;9号调用打印
			lea dx,charmess
			mov ah,09h
			int 21h

			;实际是对BX操作 BX = BH + BL
			mov bl,num
			mov bh,0

			;2号调用，入口参数DL
			mov dl,buf[bx]
			mov ah,02h
			int 21h

			mov ax,4c00h
			int 21h
code ends
end start
