;8254������1�����ڷ�ʽ3
;ѡ��2
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
    MOV AL, 76H             ;8254������0�����ڷ�ʽ3������������ 
    OUT DX, AL 
    MOV DX, B8254 
    MOV AL, 00H 
    OUT DX, AL 
    MOV AL, 48H             ;������ֵ4800H->1s
    OUT DX, AL 
AA1: 
    JMP AA1 
;�������1S������
CODE ENDS 
    END START