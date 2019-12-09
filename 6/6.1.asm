;8254计数器1工作在方式3
;选做2
A8254 EQU 0600H
B8254 EQU 0602H 
C8254 EQU 0604H 
CON8254 EQU 0606H
SSTACK SEGMENT STACK 
    DW 32 DUP(?) 
SSTACK ENDS 
CODE SEGMENT 
    ASSUME CS:CODE
START: 
 
    MOV DX, CON8254
    MOV AL, 76H             ;8254计数器0工作在方式3，产生方波。 
    OUT DX, AL 
    MOV DX, B8254 
    MOV AL, 00H 
    OUT DX, AL 
    MOV AL, 48H             ;计数初值4800H->1s
    OUT DX, AL 
AA1: 
    JMP AA1 
;输出周期1S方波。
CODE ENDS 
    END START