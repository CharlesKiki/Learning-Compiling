``` avrasm
push 0
push 1
push 2
call xxx
```

> 调用约定:这是调用函数的语句；

``` x86asm
push ebp
mov ebp, esp
```

> 是用来保护堆栈的，常常出现在函数的开头,后面也常常会跟着很多push来保护寄存器；

``` x86asm
label:
cmp ecx, 10
je xxx
inc ecx
; do sth
jmp label
```

> 这就是一个经典的循环，当然还有很多其他的形式；

``` x86asm
test eax, eax / cmp eax, ecx
je/jz xxx
push xxx
call xxx
```

> 判断条件后调用函数， 一般就是比较关键的语句了。

另外不同的语言，不同的编译器生成的代码风格也不同，如果代码中出现了上面提到的

``` x86asm
push ebp
mov ebp, esp
```
那这个程序很可能是C语言写的

对于字符串，如果字符串是

``` nginx
db "123",'\0'
```

这种形式的，一般是C/C++

``` lsl
db 3, "123"
```
这种形式的，则更有可能是Delphi。

