P8255A    EQU  0600H
P8255B    EQU  0602H
P8255C    EQU  0604H
P8255MODE EQU  0606H
CODE SEGMENT
	ASSUME CS:CODE
START:	
		MOV DX, P8255MODE ;控制字端口
		MOV AL,10000010B ;1 00 0 0 0 1 0
		OUT DX, AL
 
NEXT:	
;------从B口读入开关状态,将从B端口读入的开关数据送端口A输出--------------
		MOV DX, P8255B ;B端口
		IN AL, DX
		MOV DX, P8255A;A端口
		OUT DX, AL
;-------------------------------------------------------------------
		MOV AH,0BH;检测是否有按键按下
		INT 21H
		CMP AL,0H
		JE NEXT
		
		MOV AH,4CH
		INT 21H
CODE ENDS
	END START
