data    segment
        ;数据段定义40个内存单元内写入字符a
        source_buffer   db      40dup('a')
data    ends
;*********************************************
extra   segment
        ;虽然这是额外的段，但是应该都会加载到不远的内存控件
        dest_buffer     db      40dup(?)
extra   ends
;*********************************************
code    segment
        ;far和near是子程序调用时的参数
        main    proc    far
                assume cs:code,ds:data,es:extra
        start:
                ;在堆栈内压入数据段指针
                push    ds
                ;ax清零？？
                sub     ax,ax
                push    ax
                ;获取data段指针
                mov     ax,data
                mov     ds,ax
                ;额外段的段地址
                mov     ax,extra
                mov     es,ax
                ;si段加载buffer地址
                lea     si,source_buffer
                lea     di,dest_buffer
                cld
                mov     cx,40
                rep     movsb
                ret
        main    endp
code    ends
        end     start
