STACK SEGMENT STACK
	DW 32 DUP(?)
STACK ENDS

CODE SEGMENT
	ASSUME CS:CODE
START:
	MOV AL,10000000B
	MOV DX,0646H
	OUT DX,AL
	MOV DX,0642H
	MOV AL,10000000B	;D7
	OUT DX,AL
	
	MOV AX,OFFSET MIR6	;�ж���ڵ�ַ
	MOV SI,0038H		
	MOV [SI],AX
	MOV AX,CS
	MOV SI,003AH 
	MOV [SI],AX
	
	MOV AX,OFFSET MIR7
	MOV SI,003CH
	MOV [SI],AX
	MOV AX,CS
	MOV SI,003EH
	MOV [SI],AX
	
	CLI
	
	MOV AL,11H			;ICW1
	OUT 20H,AL
	MOV AL,08H			;ICW2
	OUT 21H,AL
	MOV AL,04H			;ICW3
	OUT 21H,AL
	MOV AL,03H			;ICW4
	OUT 21H,AL
	MOV AL,00101111B	;OCW1
	OUT 21H,AL

	STI
	
	MOV BL,1		;��־
A:
	CMP BL,1
	JZ A1
	JMP A2
A1:
	MOV DX,0642H
	IN  AL,DX

	CMP AL,80H
	JZ A
	SHL AL,1
	OUT DX,AL
	
	MOV CX,0FFFFH
	LOOP $
	MOV CX,0FFFFH
	LOOP $	
	
	JMP A
A2:
	MOV DX,0642H
	IN  AL,DX

	CMP AL,01H
	JZ A
	SHR AL,1
	OUT DX,AL
	
	MOV CX,0FFFFH
	LOOP $
	MOV CX,0FFFFH
	LOOP $
	
	JMP A
	
MIR7:

	MOV BL,1	
	IRET
	
MIR6:

	MOV BL,0
	IRET
	

CODE ENDS
	END START