;�����жϣ��ھ�ݡ����Ρ����ǡ����ݲ����ֻ�
STACK SEGMENT STACK
    DW 32 DUP(?)
STACK ENDS
 
CODE SEGMENT
    ASSUME  CS:CODE, SS:STACK
 
START:
	MOV AX,OFFSET MIR6
	MOV SI,0038H
	MOV [SI],AX
	MOV AX,CS
	MOV SI,003AH
	MOV [SI],AX
	
	CLI
	MOV AL,11H
	OUT 20H,AL
	MOV AL,08H
	OUT 21H,AL
	MOV AL,04H
	OUT 21H,AL
	MOV AL,03H
	OUT 21H,AL
	MOV AL,10101111B
	OUT 21H,AL
	STI

	MOV DI,0H
M:
	CMP DI,4H
	JNZ CC
	SUB DI,4H	
CC:	
	CMP DI,0H
	JZ JUCHI
	CMP DI,1H
	JZ JUXING
	CMP DI,2H
	JZ SANJIAO
	CMP DI,3H
	JZ JIETI
	JMP M

    ;��ݲ�
JUCHI:
    MOV DX, 0600H     ;DAC0832��IOY0,0600HΪ���ƶ˿ڵ�ַ
    MOV AL, 00H       ;ALΪ������
JC1: 
    OUT DX, AL        ;ת��Ϊģ����
    MOV CX,01FFH
    LOOP $
    CMP AL ,0FFH
    JE JC2
    INC AL            ;AL����1��ֱ������0FFH
    JMP JC1
JC2:
	CMP DI,0H
	JNZ M
    JMP JUCHI
 

    ;���β�
JUXING:
    MOV DX, 0600H
    MOV AL, 00H       ;�����00H�Ĳ���
    OUT DX, AL
    MOV CX,0FFFFH
    LOOP $
    MOV AL, 0FFH      ;�����0FFH�Ĳ���
    OUT DX, AL
    MOV CX,0FFFFH
    LOOP $
    
    CMP DI,1H
    JNZ M
   	JMP JUXING

M1: JMP M		
 
;���ǲ�
SANJIAO:
SJ1:
    MOV DX, 0600H
    OUT DX, AL
    MOV CX,01FFH
    LOOP $
    CMP AL, 0FFH
    JZ SJ2           
    INC AL            ;��AL��00H����0FFH
    JMP SJ1
SJ2:
	CMP AL, 00H
    JZ SJ3
    DEC AL
    MOV DX, 0600H
    OUT DX, AL
    MOV CX,01FFH
    LOOP $
                ;��AL��0FFH������00H
    JMP SJ2
SJ3:
	CMP DI,2H
	JNZ M
    JMP SANJIAO
 
JIETI: 
    ;���ݲ�
    MOV AX, 0FEH       
    ;����������ֵΪ0FFH
    ;8086��DIV�������ܻ��������Ϊ�����¼�����֮������ֵ����0FFH����ʹ��0FEH�����ֵ
    MOV BL,04H         ;���ݲ��еĽ������������ı���ݲ��еĽ��������޸�����
    DIV BL             ;�����������Խ��������õ�ÿ��̨�׵ĸ߶�
    MOV BL, AL         ;�������������̱�����BL��
    MOV BH, 00H        ;BH��0
JT0:
    MOV AX,0000H       ;AX��ʼ��0000H
JT1:
    MOV DX, 0600H
    OUT DX, AL
    CMP AX, 00FFH      ;�ж�AX�Ƿ�ﵽ��������
    JAE JT2            ;�ﵽ���ޣ���ʾһ�ν��ݲ��������ɣ���ʼ��һ������
    MOV CX,0FFFFH
    LOOP $
    ADD AX, BX         ;�õ�ǰ����߶ȼ���ÿ�����ݵĸ߶ȵõ���һ���ݵĸ߶�
    JMP JT1
JT2:    
	CMP DI,3H
	JNZ M1
    JMP JT0
    
    
MIR6:
	STI
	INC DI
	IRET
 
CODE ENDS
    END START
