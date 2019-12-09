STACK SEGMENT STACK
    DW 32 DUP(?)
STACK ENDS
 
CODE SEGMENT
    ASSUME  CS:CODE, SS:STACK
 
START:
    MOV CX, 0FH
AA1: 
    MOV DX, 0600H     ;梯形波的底边00H
    MOV AL, 00H
    OUT DX, AL
    CALL DELAY2
 
AA2:
    MOV DX, 0600H     ;梯形波从00H上升到0FFH
    OUT DX, AL
    CALL DELAY1
    CMP AL, 0FFH
    JE AA3
    INC AL
    JMP AA2
 
AA3:
    MOV DX, 0600H     ;梯形波的最上边0FFH
    MOV AL, 0FFH
    OUT DX, AL
    CALL DELAY2
 
AA4:
    MOV DX, 0600H     ;梯形波从0FFH下降到00H
    OUT DX, AL
    CALL DELAY1
    CMP AL, 00H
    JE AA1
    DEC AL
    JMP AA4           ;一个梯形波周期由上述四个部分组成，循环往复
 
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