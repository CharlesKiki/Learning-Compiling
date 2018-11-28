DATA SEGMENT
	WordVar dw 2 dup(?)
	ByteVar db ?
DATA ENDS
MOV byte ptr ES:WordVar[BX] , 100
MOV AX , offset WordVar[SI]
LEA AX , WordVar[SI]
CMP WordVar , ByteVar
MOV AL , ByteVar + WordVar
ADD WordVar , AL
MOV ByteVar , ByteVar ~ WordVar