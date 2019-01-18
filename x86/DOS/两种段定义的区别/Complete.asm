assume cs:codesg, ss:stacksg, ds:datasg
stacksg segment
    db 32 dup (0)
stacksg ends
datasg segment
    mess db 'hello world!$'
datasg ends
codesg segment
    start:
        mov ax,datasg
        mov ds,ax
        mov ax, stacksg
        mov ss, ax
        mov sp, 20h
        lea bx,mess
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
codesg ends
    end start
