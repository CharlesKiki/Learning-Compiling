## 在开始之前 ##
汇编是历史久远的产物，对应的平台下有诸多和现在工作环境不同的特征。
	
1. 不要让汇编源码的文件名过长，这会导致编译失败。


## ML命令 ##

## DEBUG命令 ##
当使用Debug [程序名]后，进入单步调试。<br>
此时，显示出所有寄存器的内容。

T是执行一个指令<br>
P也是执行一条指令,区别是在执行INT的时候会把这个INT整个的执行完毕,而不是跳转到这个中断程序去跟踪执行 

> 值得注意的是DS寄存器的值是程序装载进入内存的位置。

装载进内存的程序起始物理地址在075A0H（DS=075AH），然而数据段和代码段并不在这里开始，<br>
加载位置后100H的程序段前缀PSP，datasegment该开始于076A0.
> 更值得注意的是，虽然装载位置是DS值，但是仍会有100H的程序段前缀PSP。

检查段起始位置的方法。
> 段的起始位置总是在16的倍数(10H).

想要查看指定内存单元(常常是从某段地址开始查看之后的内存单元)命令。

> D 地址:地址 
> 
例如 D 076A:0000 常看之后的多行内存单元

## LINK命令 ##

## DOS下的子程序调用 ##

## 汇编程序结构 ##


段的定义语法：
> 	segname SEGMENT [align_type][combine_type][user_type]['class']
> 	...
> 	segname ENDS

其中的组合类型(combine_type)可以是：

    PUBLIC：该段连接时将与有相同名字的其他分段连接在一起，其连接次序由连接命令指定。
    COMMON：该段在连接时与其他同名分段有相同的起始地址，所以会产生覆盖。
    AT expression： 使段的起始地址是表达式所计算出来的16位段地址，但它不能用来指定代码段。
    STACK：指定该段在运行时为堆栈段的一部分。


`stacksg segment stack`中最后的`stack`使连接程序Link将定义的堆栈段当堆栈段。 

## TroubleShooting ##
当遇到编译问题时可以解决问题的渠道

	1.微软官方MSDN的错误提醒:
	https://docs.microsoft.com/zh-cn/previous-versions/visualstudio/visual-studio-2008/bcs4ah1c(v%3dvs.90) 