;��ʼʱ�������ʾ0�����µ����忪��KK1�Ĵ���Ϊn����1<=n<=6��������ߵ�6-n���������ͬʱ��ʾ��0������n>6������˳�
A8255_CON EQU 0606H
A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H
 
PUBLIC TIMES
DATA SEGMENT
TIMES DB 06H
DATA ENDS
 
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    MOV AX, OFFSET MIR6
    MOV SI, 0038H
    MOV [ES:SI], AX
    MOV AX, CS
    MOV SI, 003AH
    MOV [ES:SI], AX
    CLI
    MOV AL, 11H
    OUT 20H, AL
    MOV AL, 08H
    OUT 21H, AL
    MOV AL, 04H
    OUT 21H, AL
    MOV AL, 01H
    OUT 21H, AL
    MOV AL, 3FH
    OUT 21H, AL
    STI
    MOV DX,A8255_CON
    MOV AL,81H
    OUT DX,AL
    MOV DX,A8255_B
    MOV AL,3FH
    OUT DX,AL
    MOV DX,A8255_A
    MOV AL,00H
    OUT DX,AL
MAIN:
    CMP TIMES,00H
    JE EXIT
    CALL LED
    JMP MAIN
EXIT:
    MOV AL,00H
    MOV DX,A8255_B
    OUT DX,AL
    MOV AH, 4CH
    INT 21H
MIR6:
    DEC TIMES
    PUSH AX
    MOV AL, 20H
    OUT 20H, AL
    POP AX
    IRET
LED:
X2:    
    MOV BX, OFFSET TIMES
    MOV CX, [BX]
    MOV BX, 0000H
    MOV AL, 11011111B
X1: 
    MOV DX,A8255_A
    OUT DX,AL
    ROR AL,1
    PUSH AX
    MOV AL,3FH
    MOV DX,A8255_B
    OUT DX,AL
    POP AX
    CALL DELAY
    LOOP X1
    RET
DELAY:
    PUSH CX
    MOV CX,0FFH
X4:
    LOOP X4
    POP CX
    RET
CODE ENDS
     END START