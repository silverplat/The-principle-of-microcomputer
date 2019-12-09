MY8255_A EQU 0600H
MY8255_B EQU 0602H
MY8255_C EQU 0604H
MY8255_CON  EQU 0606H

 
DATA SEGMENT
    DTABLE  DB 00H,3FH,06H,5BH,4FH,66H,6DH,7DH,07H, 7FH,6FH,77H,7CH,39H,5EH,79H,71H
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:  
    MOV AX,DATA
    MOV DS,AX
    MOV SI,3000H
    MOV AL,00H
    MOV [SI],AL             ;����ʾ����
    MOV [SI+1],AL
    MOV [SI+2],AL
    MOV [SI+3],AL
    MOV [SI+4],AL
    MOV [SI+5],AL
    MOV DI,3005H
    MOV DX,MY8255_CON       ;д 8255 ������
    MOV AL,81H
    OUT DX,AL
BEGIN:  
    CALL DIS                ;������ʾ�ӳ���
    CALL CLEAR              ;����
    CALL CCSCAN             ;ɨ��
    JNZ INK1
    JMP BEGIN
 
INK1:  
    CALL DIS
    CALL DALLY
    CALL DALLY
    CALL CLEAR
    CALL CCSCAN
    JNZ INK2                ;�м����£�ת�� INK2
    JMP BEGIN
    ;ȷ�����¼�
INK2:  
    MOV CH,0FEH
    MOV CL,00H
 
COLUM:  
    MOV AL,CH
    MOV DX,MY8255_A
    OUT DX,AL
    MOV DX,MY8255_C
    IN AL,DX
L1: 
    TEST AL,01H             ;is L1?
    JNZ L2
    MOV AL,00H              ;L1
    JMP KCODE
L2: 
    TEST AL,02H             ;is L2?
    JNZ L3
    MOV AL,04H              ;L2
    JMP KCODE
L3: 
    TEST AL,04H             ;is L3?
    JNZ L4
    MOV AL,08H              ;L3
    JMP KCODE
L4: 
    TEST AL,08H             ;is L4?
    JNZ NEXT
    MOV AL,0CH              ;L4
KCODE:  
    ADD AL,CL
    ADD AL,1
    CALL PUTBUF
    PUSH AX
KON: 
    CALL DIS
    CALL CLEAR
    CALL CCSCAN
    JNZ KON
    POP AX
NEXT:  
    INC CL
    MOV AL,CH
    TEST AL,08H
    JZ KERR
    ROL AL,1
    MOV CH,AL
    JMP COLUM
KERR:  
    JMP BEGIN
    
CCSCAN: ;AL ==Y
    MOV AL,00H              ;����ɨ���ӳ���
    MOV DX,MY8255_A
    OUT DX,AL
    MOV DX,MY8255_C
    IN AL,DX
    NOT AL
    AND AL,0FH
    RET
    
CLEAR:  
    MOV DX,MY8255_B         ;�����ӳ���
    MOV AL,00H
    OUT DX,AL
    RET
    
DIS: 
    PUSH AX                 ;��ʾ�ӳ���
    MOV SI,3000H
    MOV DL,0DFH
    MOV AL,DL
AGAIN:  
    PUSH DX
    MOV DX,MY8255_A
    OUT DX,AL
    MOV AL,[SI]
    MOV BX,00H;OFFSET DTABLE
    AND AX,00FFH
    ADD BX,AX
    MOV AL,[BX]
    MOV DX,MY8255_B
    OUT DX,AL
    CALL DALLY
    INC SI
    POP DX
    
    MOV AL,DL
    TEST AL,01H
    JZ OUT1
    ROR AL,1
    MOV DL,AL
    JMP AGAIN
OUT1:  
    POP AX
    RET
    
DALLY:  
    PUSH CX                  ;��ʱ�ӳ���
    MOV CX,03C0H
    LOOP $
    POP CX
    RET
    
PUTBUF: 					;�����ֵ����Ӧλ�Ļ�����
	PUSH CX
	PUSH AX
	MOV CX,5
	MOV SI,3005H
P1:
	MOV AL,[SI-1]
	MOV [SI],AL
	DEC SI
	LOOP P1
	POP AX
	MOV [SI],AL
	POP CX
    RET
    
CODE ENDS
    END START