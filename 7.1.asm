M8251_DATA EQU 0600H             ;8251数据端口地址
M8251_CON  EQU 0602H             ;8251控制端口地址
M8254_2    EQU 06C4H             ;8254计数器2端口地址
M8254_CON  EQU 06C6H             ;8254控制寄存器端口地址
M8255_CON  EQU 0646H             ;8255控制寄存器端口地址
M8255_B    EQU 0642H             ;8255B口地址
 
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
    ;初始化8255，B口输出
 
AA0: 
    MOV SI, 3000H                    ;数据首写入首地址
    MOV CX, 001AH
    MOV AX, 61H
AA1: 
    MOV [SI], AX
    INC AX
    INC SI
    LOOP AA1
 
    ;初始化 8254
    MOV AL, 10110110B
    MOV DX, M8254_CON
    OUT DX, AL
    MOV AL, 0CH			;12,波特率9600
    MOV DX, M8254_2
    OUT DX, AL
    MOV AL, 00H
    OUT DX, AL
 
    MOV DX, M8251_CON
    MOV AL, 00H
    OUT DX, AL
    CALL DELAY
    ;复位 8251
 
    MOV AL, 40H
    OUT DX, AL
    CALL DELAY
 
    ;8251 方式字
    MOV AL,01111110B	;波特因子16，时钟频率1.8432Mhz，得12
    OUT DX, AL
    CALL DELAY
 
    ;8251 控制字
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
    ;发送数据
    MOV DX, M8251_CON
A2: 
    IN AL, DX
    AND AL, 01H
    ;判断发送缓冲是否为空
    JZ A2
    CALL DELAY
A3: 
    IN AL, DX 
    MOV DX, M8255_B
    OUT DX, AL
    TEST AL, 02H
    ;判断是否接收到数据
    JZ A3
    TEST AL, 38H
    ;判断是否有错误
    JZ CO
    MOV DX, M8255_B
    OUT DX, AL
    JMP EXIT
CO:
    MOV DX, M8251_DATA
    IN AL, DX 
    ;读取接收到的数据
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