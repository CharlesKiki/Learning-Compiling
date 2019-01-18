.8086
.MODEL small
.data
    mess db 'hello world!$'
.stack 20H
.code
start:
    mov ax,@data
    mov ds,ax
    lea bx,mess ;这儿简单地用mov bx, 0将有逻辑错误。这取决于模式，请自行debug观察
output:
    mov dl, [bx]
    cmp dl, '$'
    je stop
    mov ah, 02H
    int 21h
    inc bx
    jmp output
stop:
    mov ax,4c00h
    int 21h
end start
