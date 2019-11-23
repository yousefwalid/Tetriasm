;x86 asm Tetris
;Microprocessors Project
;--------------------------- 
		INCLUDE macros.inc
        .MODEL HUGE 
        .STACK 64
        .DATA
        ;INSERT DATA HERE
GAMESCRWIDTH        DW  100     ;width of each screen
GAMESCRHEIGHT       DW  160     ;height of each screen
								;Tetris grid is 16x10, so each block is 10x10 pixels
GAMELEFTSCRX        DW  10      ;top left corner X of left screen
GAMELEFTSCRY        DW  15      ;top left corner Y of left screen
GAMERIGHTSCRX       DW  170     ;top left corner X of right screen
GAMERIGHTSCRY       DW  15      ;top left corner Y of right screen

		;CONTROL KEYS (scancodes)
		
		;Controls for left screen
leftDown			DB	115D	;S key
leftLeft			DB	97D		;A key
leftRight			DB	100D	;D key
leftRot				DB	119D	;W key
		;Controls for right screen
rightDown			DB	80D		;downArrow key
rightLeft			DB	75D		;leftArrow key
rightRight			DB	77D		;rightArrow key
rightRot			DB	72D		;upArrow key

		;CURRENT PIECE INFO
leftPieceId					DB	?			;contains the ID of the current piece
leftPieceOrientation		DB	?			;contains the current orientation of the piece
leftPieceLocX				DB	?			;the Xcoord of the top left corner
leftPieceLocY				DB	?			;the Ycoord of the top left corner
leftPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)

rightPieceId				DB	?			;contains the ID of the current piece
rightPieceOrientation		DB	?			;contains the current orientation of the piece
rightPieceLocX				DB	?			;the Xcoord of the top left corner
rightPieceLocY				DB	?			;the Ycoord of the top left corner
rightPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)

tempPieceOffset				DW	?			;contains the address of the current piece

        .CODE
;---------------------------        
MAIN    PROC    FAR
        MOV AX, @DATA   ;SETUP DATA ADDRESS
        MOV DS, AX      ;MOV DATA ADDRESS TO DS
        
        MOV AH, 0       ;PREPARE GFX MODE
        MOV AL, 13H
        INT 10H         ;ENTER GFX MODE
        
		CALL DrawGameScr
		
		MOV CX, 0
		MOV DX, 15
		MOV SI, 0
		MOV AL, 1
		CALL DrawBlockClr

		MOV CX, 1
		MOV DX, 15
		MOV SI, 0
		MOV AL, 3
		CALL DrawBlockClr
		MOV CX, 2
		MOV DX, 15
		MOV SI, 0
		MOV AL, 2
		CALL DrawBlockClr
		
		
		
        MOV AH, 4CH     ;SETUP FOR EXIT
        INT 21H         ;RETURN CONTROL TO DOS
MAIN    ENDP
;---------------------------
;This PROC draws the screens of the two players given the parameters in data segment
;@param     none
;@return    none
DrawGameScr PROC    NEAR
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
DrawGameScr ENDP
;---------------------------
;Takes a block (X,Y) in the 16x10 grid of tetris and returns the color of the block
;@param		CX: X coord,
;		    DX: Y coord, 
;			SI: screen ID: 0 for left, 4 for right
;@return	AL:	color for (X,Y) grid
GetBlockClr	PROC	NEAR							;XXXXXXXXX - NEEDS TESTING
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
GetBlockClr	ENDP
;---------------------------
;Takes a block (X,Y) in the 16x10 grid of tetris and colors the block with a given color
;@param		CX:	X coord,
;			DX: Y coord,
;			SI: screen ID: 0 for left, 4 for right
;			AL: color for (X,Y) grid
;@return	
DrawBlockClr	PROC	NEAR

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
DrawBlockClr	ENDP
;---------------------------
;This procedure copies the piece address into tempPiece according to SI
;@param			SI: screenId: 0 for left, 4 for right
;@return		none 
GetTempPiece	PROC	NEAR
				CMP SI, 0
				JNZ	RIGHT
				LEA SI, leftPieceId
				MOV tempPieceOffset, SI
				JMP EXT
RIGHT:
				LEA SI, rightPieceId
				MOV tempPieceOffset, SI
EXT:
				RET
GetTempPiece	ENDP
;---------------------------
;This procedure clears the current piece (used in changing direction or rotation)	;NEEDS TESTING
;@param			SI: screenId: 0 for left, 4 for right
;
;@return		none
DeletePiece		PROC	NEAR
				CALL GetTempPiece
				MOV SI, tempPieceOffset
				MOV DI, SI						;Load the piece 4x4 string address in pieceData
				ADD DI,	4						;Go to the string data to put in DI
				MOV CX, 0D						;iterate over the 16 cells of the piece
				;if the piece has color !black, draw it with black
				;cell location is:
				;cell_x = orig_x + id%4
				;cell_y = orig_y + id/4
LOPX:			
				MOV DL, [DI]					;copy the byte of color of current cell into DL
				CMP DL, 0D						;check if color of current piece block is black
				JZ 	ISBLACK
				
				PUSH CX
				
				MOV AX, CX
				MOV CL, 4D
				DIV CL						;AH = id%4, AL = id/4
				MOV CX, 0
				MOV DX, 0
				MOV CL, [SI+2]				;load selected piece X into CL
				MOV DL, [SI+3]				;load selected piece Y into DL
				ADD CL, AH					;CX = orig_x + id%4
				ADD DL, AL					;CX = orig_y + id/4
				
				MOV AL, 0D
				
				PUSHA
				CALL DrawBlockClr
				POPA
				
				POP  CX
ISBLACK:		
				INC DI
				CMP CX, 16D
				JNZ LOPX
				
				RET
DeletePiece		ENDP
;---------------------------
;This procedure takes the direction to move the piece in and re-draws it in the new location	;NOT FINISHED
;@param			
;				BX: direction{0:down, 1:left, 2:right}
;				SI: screenId: 0 for left, 4 for right
;@return		none
MovePiece		PROC	NEAR

				;INSERT COLLISION DETECTION HERE
				;DELETE THE PIECE FROM THE SCREEN
				CALL DeletePiece
				;DRAW THE NEW PIECE IN NEW LOCATION
				
				RET
MovePiece		ENDP
;---------------------------
END     MAIN








