;触发中断，在锯齿、矩形、三角、阶梯波间轮回
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

    ;锯齿波
JUCHI:
    MOV DX, 0600H     ;DAC0832接IOY0,0600H为控制端口地址
    MOV AL, 00H       ;AL为数字量
JC1: 
    OUT DX, AL        ;转换为模拟量
    MOV CX,01FFH
    LOOP $
    CMP AL ,0FFH
    JE JC2
    INC AL            ;AL步加1，直到等于0FFH
    JMP JC1
JC2:
	CMP DI,0H
	JNZ M
    JMP JUCHI
 

    ;矩形波
JUXING:
    MOV DX, 0600H
    MOV AL, 00H       ;先输出00H的波形
    OUT DX, AL
    MOV CX,0FFFFH
    LOOP $
    MOV AL, 0FFH      ;再输出0FFH的波形
    OUT DX, AL
    MOV CX,0FFFFH
    LOOP $
    
    CMP DI,1H
    JNZ M
   	JMP JUXING

M1: JMP M		
 
;三角波
SANJIAO:
SJ1:
    MOV DX, 0600H
    OUT DX, AL
    MOV CX,01FFH
    LOOP $
    CMP AL, 0FFH
    JZ SJ2           
    INC AL            ;将AL从00H步加0FFH
    JMP SJ1
SJ2:
	CMP AL, 00H
    JZ SJ3
    DEC AL
    MOV DX, 0600H
    OUT DX, AL
    MOV CX,01FFH
    LOOP $
                ;将AL从0FFH步减至00H
    JMP SJ2
SJ3:
	CMP DI,2H
	JNZ M
    JMP SANJIAO
 
JIETI: 
    ;阶梯波
    MOV AX, 0FEH       
    ;波形振幅最大值为0FFH
    ;8086的DIV除法可能会出现余数为负导致加起来之后的最大值大于0FFH，故使用0FEH作最大值
    MOV BL,04H         ;阶梯波中的阶梯数，如果想改变阶梯波中的阶梯数请修改这里
    DIV BL             ;用最大振幅除以阶梯数，得到每个台阶的高度
    MOV BL, AL         ;将上述除法的商保存在BL中
    MOV BH, 00H        ;BH置0
JT0:
    MOV AX,0000H       ;AX初始化0000H
JT1:
    MOV DX, 0600H
    OUT DX, AL
    CMP AX, 00FFH      ;判断AX是否达到幅度上线
    JAE JT2            ;达到上限，表示一次阶梯波完整生成，开始新一次生成
    MOV CX,0FFFFH
    LOOP $
    ADD AX, BX         ;用当前解体高度加上每个阶梯的高度得到下一阶梯的高度
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
