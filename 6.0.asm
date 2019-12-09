;8254计数器1工作在方式0
;选作1
A8254 EQU 0600H
B8254 EQU 0602H 
C8254 EQU 0604H 
CON8254 EQU 0606H

CODE SEGMENT 
    ASSUME CS:CODE
START: 
    
    MOV DX, CON8254
    MOV AL, 01110000B       ;8254计数器1工作在方式0，计数时输出低电平，到0时输出高电平 
    OUT DX, AL 
    MOV DX, B8254 
    MOV AL, 05H 		;计数初值低8位
    OUT DX, AL 
    MOV AL, 00H			;计数初值高8位
    OUT DX, AL 
AA1: 
    JMP AA1 

CODE ENDS 
    END START