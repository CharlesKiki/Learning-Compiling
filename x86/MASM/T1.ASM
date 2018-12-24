;汇编数据段
DATA SEGMENT
;SEGMENT关键字：段地址起始位
CHAR DB 'F'
;DB关键字 改地址存储一个ASCII值
DATA ENDs
；ENDS关键字 类似作用域结束
;注释？区分大小写？
;不区分大小写
CODE SEGMENT
ASSUME CS:CODE ,  DS:DATA
;ASSUME关键字 为寄存器赋值
START :
;START 程序段
MOV AX ,DATA
;当使用AX寄存器 == 使用AL段 
MOV DS,AX
;DS = AX == AL 
MOV DL,CHAR
;DX = DL + DH  令16位寄存器后8位赋值ASCII

;执行打印功能
MOV AH,2
;https://wenku.baidu.com/view/137903edc77da26924c5b014.html
;AH寄存器 --- 特定函数指针
INT 21H
;自此开始进入汇编中断结束
;https://zhidao.baidu.com/question/310380801.html
;int n
;n为中断类型码，它的功能是引发中断过程。
MOV AX ,4C00H
INT 21H
CODE ENDS
END START
;中断结束