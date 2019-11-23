;x86 asm Tetris
;Microprocessors Project
;---------------------------        
        .MODEL HUGE 
        .STACK 64
        .DATA
        ;INSERT DATA HERE
GAMESCRWIDTH        DW  100      ;width of each screen
GAMESCRHEIGHT       DW  150     ;height of each screen
								;Tetris grid is 15x10, so each block is 10x10 pixels
GAMELEFTSCRX        DW  20      ;top left corner X of left screen
GAMELEFTSCRY        DW  20      ;top left corner Y of left screen
GAMERIGHTSCRX       DW  180     ;top left corner X of right screen
GAMERIGHTSCRY       DW  20      ;top left corner Y of right screen
        .CODE
;---------------------------        
MAIN    PROC    FAR
        MOV AX, @DATA   ;SETUP DATA ADDRESS
        MOV DS, AX      ;MOV DATA ADDRESS TO DS
        
        MOV AH, 0       ;PREPARE GFX MODE
        MOV AL, 13H
        INT 10H         ;ENTER GFX MODE
        
        CALL DRAWGAMESCR


        MOV AH, 4CH     ;SETUP FOR EXIT
        INT 21H         ;RETURN CONTROL TO DOS
MAIN    ENDP
;---------------------------
;This PROC draws the screens of the two players given the parameters in data segment
;@param     none
;@return    none
DRAWGAMESCR PROC    NEAR
			MOV SI, 0				;0 for left, 4 for right
			MOV AL, 9               ;frame color
            MOV AH, 0CH             ;draw pixel command
DRAWFRAME:
            MOV CX, GAMELEFTSCRX[SI]   ;beginning of top left X
            MOV DX, GAMELEFTSCRY[SI]   ;beginning of top left Y
			
            MOV BX, GAMELEFTSCRX[SI]
            ADD BX, GAMESCRWIDTH    ;set right limit
DRAWHOR:
            INT 10H                 ;draw top
            ADD DX, GAMESCRHEIGHT   ;go to bottom
            INT 10H                 ;draw bottom
            SUB DX, GAMESCRHEIGHT   ;go back to top
            INC CX                  ;inc X
            CMP CX, BX              ;check if column is at limit
            JBE DRAWHOR             ;if yes, exit loop
            
            MOV CX, GAMELEFTSCRX+[SI]    ;beginning of top left X
            MOV DX, GAMELEFTSCRY+[SI]    ;beginning of top left Y
			
            MOV BX, GAMELEFTSCRY+[SI]
            ADD BX, GAMESCRHEIGHT   ;set bottom limit
            
DRAWVER:    
            INT 10H                 ;draw left
            ADD CX, GAMESCRWIDTH    ;go to right
            INT 10H                 ;draw right
            SUB CX, GAMESCRWIDTH    ;go back to left
            INC DX                  ;inc Y
            CMP DX, BX              ;check if row is at limit
            JBE DRAWVER
			ADD SI, 4				;inc SI
			MOV AL, 4				;set color to red for right frame
			CMP SI, 8				;check if loop ran twice
			JNE	DRAWFRAME
        
            RET
DRAWGAMESCR ENDP
;---------------------------    
END     MAIN








