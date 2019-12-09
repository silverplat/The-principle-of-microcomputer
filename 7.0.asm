M8251_DATA EQU 0600H             ;8251���ݶ˿ڵ�ַ
M8251_CON  EQU 0602H             ;8251���ƶ˿ڵ�ַ
M8254_2    EQU 06C4H             ;8254������2�˿ڵ�ַ
M8254_CON  EQU 06C6H             ;8254���ƼĴ����˿ڵ�ַ
M8255_CON  EQU 0646H             ;8255���ƼĴ����˿ڵ�ַ
M8255_B    EQU 0642H             ;8255B�ڵ�ַ
 
SSTACK  SEGMENT STACK
    DW 64 DUP(?)
SSTACK  ENDS
 
CODE SEGMENT
    ASSUME CS:CODE
START:  
    MOV AX, 0000H
    MOV DS, AX
 
    MOV DX, M8255_CON
    MOV AL, 90H
    OUT DX, AL
    MOV DX, M8255_B
    MOV AL, 00H
    OUT DX, AL
    ;��ʼ��8255��B�����
 
AA0: 
    MOV SI, 3000H                    ;������д���׵�ַ
    MOV CX, 001AH
    MOV AX, 61H
AA1: 
    MOV [SI], AX
    INC AX
    INC SI
    LOOP AA1
 
    ;��ʼ�� 8254
    MOV AL, 10110110B
    MOV DX, M8254_CON
    OUT DX, AL
    MOV AL, 0CH			;12,������9600
    MOV DX, M8254_2
    OUT DX, AL
    MOV AL, 00H
    OUT DX, AL
 
    MOV DX, M8251_CON
    MOV AL, 00H
    OUT DX, AL
    CALL DELAY
    ;��λ 8251
 
    MOV AL, 40H
    OUT DX, AL
    CALL DELAY
 
    ;8251 ��ʽ��
    MOV AL,01111110B	;��������16��ʱ��Ƶ��1.8432Mhz����12
    OUT DX, AL
    CALL DELAY
 
    ;8251 ������
    MOV AL, 00110100B	
    OUT DX, AL
    CALL DELAY
 
    MOV DI, 4000H
    MOV SI, 3000H
    MOV CX, 001AH
A1: 
    MOV AL, [SI]
    PUSH AX
    MOV AL, 37H
    MOV DX, M8251_CON
    OUT DX, AL
    POP AX
    MOV DX, M8251_DATA
    OUT DX, AL  
    ;��������
    MOV DX, M8251_CON
A2: 
    IN AL, DX
    AND AL, 01H
    ;�жϷ��ͻ����Ƿ�Ϊ��
    JZ A2
    CALL DELAY
A3: 
    IN AL, DX 
    MOV DX, M8255_B
    OUT DX, AL
    TEST AL, 02H
    ;�ж��Ƿ���յ�����
    JZ A3
    TEST AL, 38H
    ;�ж��Ƿ��д���
    JZ CO
    MOV DX, M8255_B
    OUT DX, AL
    JMP EXIT
CO:
    MOV DX, M8251_DATA
    IN AL, DX 
    ;��ȡ���յ�������
    MOV [DI], AL
    INC DI
    INC SI
    LOOP A1
EXIT:    
    MOV AH,4CH
    INT 21H 
 
DELAY:
    PUSH CX
    MOV CX,3000H
A5: 
    PUSH AX
    POP AX
    LOOP A5
    POP CX
    RET
CODE ENDS
    END START