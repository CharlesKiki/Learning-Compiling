;该程序以MASM语法写成bootloader
;编写Bootloader可以使用BIOS调用
;该代码没有对软盘或者U盘进行FAT32格式的格式化，所以只是用来说明DW 0AA55H作为引导扇区结束的例子

data segment 
    org 07c00h                      ;将程序加载到07c0:0000处 
start: 
    mov ax,data mov es,ax       ;后面的字符串寻址输出需要
    es:bp mov bp,offset msg1 
    lop:
    mov ah,13h                  ;第10h中断向量的功能代码13h---写字符串 
    mov al,0                    ;写模式 使用0就可以 
    mov bh,0                    ;0页，默认为0页即可 
    mov bl,07                   ;显示属性，黑底白字 
    mov cx,32                   ;字符32个，更科学的方法是两个标号相减，为了简化代码，直接数出来 
    mov dh,10                   ;输出在第10行 
    mov dl,24                   ;输出在第24列 
    int 10h                     ;10h 使用第10h中断向量，显示器输出 
    jmp lop                     ;死循环，让字符保持在屏幕上 
    ret msg1 db "Bootloader start." 

    ;这里有两种思路，一种可以填充前面的空白位置，另外一种则是跳至指定位置
    org 07c00h+512-2            ;地址计数器跳到512字节的倒数第二字节，即07c0:01FE 
    DW 0AA55H                   ;此处在512字节的最后两字节写入AA55H ！！ 
data ends
end start
