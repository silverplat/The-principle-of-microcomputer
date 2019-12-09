;使六位数码管从左到右显示稳定的数字“123456”
A8255_CON EQU 0606H
A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H
 
DATA SEGMENT
TABLE1:
    DB 7DH
    DB 6DH
    DB 66H
    DB 4FH
    DB 5BH
    DB 06H
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    LEA SI,TABLE1
    MOV DX,A8255_CON
    MOV AL,81H
    OUT DX,AL
    MOV DX,A8255_B
    MOV AL,3FH
    OUT DX,AL
    MOV DX,A8255_A
    MOV AL,00H
    OUT DX,AL
X2:    
    MOV CX,06H
    MOV BX,0000H
    MOV AL,11011111B
X1: 
    MOV DX,A8255_A
    OUT DX,AL
    ROR AL,1
    PUSH AX
    MOV AL,[BX+SI]
    MOV DX,A8255_B
    OUT DX,AL
    POP AX
    CALL DELAY
    INC BX
    LOOP X1
    JMP X2    
DELAY:
    PUSH CX
    MOV CX,0FFH
X4:
    LOOP X4
    POP CX
    RET
CODE ENDS
     END START