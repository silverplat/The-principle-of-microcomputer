;8254������1�����ڷ�ʽ0
;ѡ��1
A8254 EQU 0600H
B8254 EQU 0602H 
C8254 EQU 0604H 
CON8254 EQU 0606H

CODE SEGMENT 
    ASSUME CS:CODE
START: 
    
    MOV DX, CON8254
    MOV AL, 01110000B       ;8254������1�����ڷ�ʽ0������ʱ����͵�ƽ����0ʱ����ߵ�ƽ 
    OUT DX, AL 
    MOV DX, B8254 
    MOV AL, 05H 		;������ֵ��8λ
    OUT DX, AL 
    MOV AL, 00H			;������ֵ��8λ
    OUT DX, AL 
AA1: 
    JMP AA1 

CODE ENDS 
    END START