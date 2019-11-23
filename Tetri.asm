;x86 asm Tetris
;Microprocessors Project
;--------------------------- 
		INCLUDE macros.inc
        .MODEL HUGE 
        .STACK 64
        .DATA
        ;INSERT DATA HERE
GAMESCRWIDTH        DW  100      ;width of each screen
GAMESCRHEIGHT       DW  160     ;height of each screen
								;Tetris grid is 16x10, so each block is 10x10 pixels
GAMELEFTSCRX        DW  10      ;top left corner X of left screen
GAMELEFTSCRY        DW  15      ;top left corner Y of left screen
GAMERIGHTSCRX       DW  170     ;top left corner X of right screen
GAMERIGHTSCRY       DW  15      ;top left corner Y of right screen
        .CODE
;---------------------------        
MAIN    PROC    FAR
        MOV AX, @DATA   ;SETUP DATA ADDRESS
        MOV DS, AX      ;MOV DATA ADDRESS TO DS
        
        MOV AH, 0       ;PREPARE GFX MODE
        MOV AL, 13H
        INT 10H         ;ENTER GFX MODE
        
		CALL DRAWGAMESCR
		
		MOV CX, 0
		MOV DX, 15
		MOV SI, 0
		MOV AL, 1
		CALL DRAWBLOCKCLR

		MOV CX, 1
		MOV DX, 15
		MOV SI, 0
		MOV AL, 3
		CALL DRAWBLOCKCLR
		MOV CX, 2
		MOV DX, 15
		MOV SI, 0
		MOV AL, 2
		CALL DRAWBLOCKCLR
		
		
		
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
            MOV CX, GAMELEFTSCRX[SI]    ;beginning of top left X
            MOV DX, GAMELEFTSCRY[SI]   	;beginning of top left Y
			ADD DX, GAMESCRHEIGHT	  	;go to bottom
			;INC DX						;draw at bottom + 1 as this is the border
            MOV BX, GAMELEFTSCRX[SI]
            ADD BX, GAMESCRWIDTH    ;set right limit
DRAWHOR:
            INT 10H                 ;draw bottom
            INC CX                  ;inc X
            CMP CX, BX              ;check if column is at limit
            JBE DRAWHOR             ;if yes, exit loop
            
            MOV CX, GAMELEFTSCRX+[SI]    ;beginning of top left X
			DEC CX						 ;go to left - 1
            MOV DX, GAMELEFTSCRY+[SI]    ;beginning of top left Y
			
            MOV BX, GAMELEFTSCRY+[SI]
            ADD BX, GAMESCRHEIGHT   	 ;set bottom limit
            
DRAWVER:    
            INT 10H                 ;draw left
            ADD CX, GAMESCRWIDTH    ;go to right
			ADD CX, 1				;draw at right + 1
            INT 10H                 ;draw right
            SUB CX, GAMESCRWIDTH    ;go back to left	
			SUB CX, 1
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
;Takes a block (X,Y) in the 16x10 grid of tetris and returns the color of the block
;@param		CX: X coord,
;		    DX: Y coord, 
;			SI: screen ID: 0 for left, 4 for right
;@return	AL:	color for (X,Y) grid
GETBLOCKCLR	PROC	NEAR							;XXXXXXXXX - NEEDS TESTING
			MOV AX, CX		;top left of (X,Y) block is 10*X + gridTopX
			MOV BL, 10D	
			MUL BL
			ADD AX, 5D
			ADD AX, GAMELEFTSCRX[SI]
			MOV	CX, AX		;CX = 10*Xcoord + gridTopX + 5
			
			MOV AX, DX		;same as above
			MUL BL
			ADD AX, 5D
			ADD AX, GAMELEFTSCRY[SI]
			MOV DX, AX
			
			
			MOV AH, 0DH
			MOV BH, 0
			INT 10H
			RET
GETBLOCKCLR	ENDP
;---------------------------
;Takes a block (X,Y) in the 16x10 grid of tetris and colors the block with a given color
;@param		CX:	X coord,
;			DX: Y coord,
;			SI: screen ID: 0 for left, 4 for right
;			AL: color for (X,Y) grid
;@return	
DRAWBLOCKCLR	PROC	NEAR

			MOV DI, AX		;push color to DI
							;go to top left of block
			MOV	AX, CX
			MOV BL, 10D
			MUL BL
			ADD AX, GAMELEFTSCRX[SI]
			MOV CX, AX		;CX = 10*Xcoord + gridTopX
			
			MOV AX, DX
			MUL BL
			ADD AX, GAMELEFTSCRY[SI]
			MOV DX, AX		;DX = 10*Ycoord + gridTopY
			
			MOV AX, DI		;pop color to AX
			
			MOV DI, CX		;DI = limit of CX
			ADD DI, 10		;DI = CX + 10 (LIMIT OF CX)
			MOV BX, DX		;BX = limit of DX
			ADD	BX, 10		;BX = DX + 10 (LIMIT OF DX)

			MOV AH, 0CH
LOOPX:
			MOV DX, BX		;Reset DX to original Y
			SUB DX, 10
LOOPY:
			INT 10H			;draw pixel at (CX,DX)
			INC DX			;go to next pixel Y
			CMP DX, BX		
			JNZ LOOPY
			INC CX
			CMP CX, DI
			JNZ LOOPX
			
			
			RET
DRAWBLOCKCLR	ENDP
;---------------------------
END     MAIN








