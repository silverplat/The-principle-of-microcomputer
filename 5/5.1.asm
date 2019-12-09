STACK SEGMENT STACK
    DW 32 DUP(?)
STACK ENDS
 
CODE SEGMENT
    ASSUME  CS:CODE, SS:STACK
 
START:
    MOV CX, 0FH
AA1: 
    MOV DX, 0600H     ;���β��ĵױ�00H
    MOV AL, 00H
    OUT DX, AL
    CALL DELAY2
 
AA2:
    MOV DX, 0600H     ;���β���00H������0FFH
    OUT DX, AL
    CALL DELAY1
    CMP AL, 0FFH
    JE AA3
    INC AL
    JMP AA2
 
AA3:
    MOV DX, 0600H     ;���β������ϱ�0FFH
    MOV AL, 0FFH
    OUT DX, AL
    CALL DELAY2
 
AA4:
    MOV DX, 0600H     ;���β���0FFH�½���00H
    OUT DX, AL
    CALL DELAY1
    CMP AL, 00H
    JE AA1
    DEC AL
    JMP AA4           ;һ�����β������������ĸ�������ɣ�ѭ������
 
DELAY1:  
    PUSH CX
    MOV CX, 0FFH
AA5: 
    PUSH AX
    POP AX
    LOOP AA5
    POP CX
    RET
 
DELAY2:  
    PUSH CX
    MOV CX, 0FFFFH
AA6: 
    PUSH AX
    POP AX
    LOOP AA6
    POP CX
    RET
 
CODE ENDS
    END START