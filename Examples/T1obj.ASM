;反汇编
List File [nul.map]: NUL
Libraries [.lib]:
Definitions File [nul.def]:
LINK : warning L4021: no stack segment

13B2:0000 B8B113        MOV     AX,13B1
;DATA = 13B1 段基址 
;Q:这里为什么不直接使用AH？ 不直接赋值DS？
;A：DS只能间接赋值 程序员不可见

13B2:0003 8ED8          MOV     DS,AX
;DS = AX 赋值  DX =DH + DL
13B2:0005 8A160000      MOV     DL,[0000]
;al,ah,bl,bh,cl,ch,dh中任意一个替换dl
;     AH&AL＝AX：累加寄存器，常用于运算； 
;     BH&BL＝BX：基址寄存器，常用于地址索引； 
;     CH&CL＝CX：计数寄存器，常用于计数； 
;     DH&DL＝DX：数据寄存器，常用于数据传递。 
；https://blog.csdn.net/u013529907/article/details/37592583
;寻址方式 
;Q：偏移地址 ----> 指向一个存储值
;A：[0000] DS:[0000] = 一个值 F
13B2:0009 B402          MOV     AH,02
;Q：AH函数不需要传参？？
;A：或许有参数 默认从段地址的第一个偏移地址作为参数
13B2:000B CD21          INT     21
;
13B2:000D B8004C        MOV     AX,4C00
13B2:0010 CD21          INT     21
13B2:0012 5F            POP     DI
13B2:0013 7D5F          JGE     0074
13B2:0015 7D5F          JGE     0076
13B2:0017 7D5F          JGE     0078
13B2:0019 7D5F          JGE     007A
13B2:001B 7D5F          JGE     007C
13B2:001D 7D5F          JGE     007E
13B2:001F 7D5F          JGE     0080
-