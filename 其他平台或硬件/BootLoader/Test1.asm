; 软盘的作为PC的引导
; TAB=4

; 标准FAT12格式软盘专用的代码 Stand FAT12 format floppy code

		DB		0xeb,'Unknow', 0x90
		;PC会自动读取软盘中的固定位置
		;在汇编当中0xEB是跳转指令，0x58是跳转的地址，而0x90则是空指令。
		;此处直接适用机械指令写入，本质是汇编命令的二进制形式，eb == jmp entry 
		;第二个参数为直到RESB命令长度，该命令执行相对偏移跳转,Unknow需要重新计算长度，手工
		;这也意味着者直到RESB的命令都没有被执行
		;0x90尚不清楚这个参数的含义，但是这个参数有可能是关于CPU或者硬件初始化程序的参数
		;属于硬件约定，应该查阅对应硬件平台的手册
		DB		"InitHere"		; 启动扇区名称（8字节）
		DW		512				; 每个扇区（sector）大小（必须512字节）
		DB		1				; 簇（cluster）大小（必须为1个扇区）
		DW		1				; FAT起始位置（一般为第一个扇区）
		DB		2				; FAT个数（必须为2）
		DW		224				; 根目录大小（一般为224项）
		DW		2880			; 该磁盘大小（必须为2880扇区1440*1024/512）
		DB		0xf0			; 磁盘类型（必须为0xf0）
		DW		9				; FAT的长度（必须9扇区）
		DW		18				; 一个磁道（track）有几个扇区（必须为18）
		DW		2				; 磁头数（必须2）
		DD		0				; 不使用分区，必须是0
		DD		2880			; 重写一次磁盘大小
		DB		0,0,0x29		; 依次是磁盘中断服务(INT 13)的驱动器号(第1,2 软磁盘驱动器号：0,1。硬盘驱动器号从 0x80 开始)，保留字节，及扩展引导标记(0x29)
		DD		0xffffffff		; 卷序列号
		DB		"InitProgram"	; 磁盘名称(卷标)，根据 FAT 系统 8.3 文件名规范，共11字节
		DB		"FAT12   "		; 磁盘格式名称 文件系统类型描述：8字节

; 以下是引导记录的程序体，该程序体用来引导真正的操作系统

entry:
	MOV AX,0     ; CPU 各寄存器初始化
	MOV SS,AX
	MOV SP,0x7c00
	MOV DS,AX
	MOV ES,AX

	MOV SI,msg
putloop:
	MOV AL,[SI]
	ADD SI,1 	; 检查 [SI] 指向的字符串当前位置是否为 '\x0'
	CMP AL,0
	JE fin
	MOV AH,0x0e ; 字符显示功能
	MOV BX,15   ; 颜色代码
	INT 0x10    ; BIOS 显示中断调用，具体可以参考 BIOS 中断大全类的书
	JMP putloop
fin:
	HLT         ; 执行 CPU 暂停指令
	JMP fin     ; 无限循环

msg:
	DB 0x0a, 0x0a 	  ; 0x0a 在 ASCII 中为换行符，此处有两个
	DB "hello, world"
	DB 0x0a           ; 换行符
	DB 0
	RESB 0x7dfe-$     ; 将下面的 0x55, 0xaa 填充到扇区末尾两个字节，这是引导扇区的识别标志，如被破坏则引导记录被视为无效，无法正常引导操作系统。
	DB 0x55, 0xaa

; 以下是引导记录后面跟随的数据结构
	DB 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00 ; 第1个 FAT 表
	RESB 4600 										  ; 凑齐 FAT 实际大小，共 9 个扇区
	DB 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00 ; 第2个 FAT 表
	RESB 1469432 									  ; 凑齐整张 1.44M 软盘大小


