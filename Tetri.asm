;x86 asm Tetris
;Microprocessors Project
;--------------------------- 
INCLUDE macros.inc
.MODEL HUGE 
.STACK 512
.DATA
;INSERT DATA HERE

FRAMEWIDTH        	EQU  10      ;width of each frame in blocks
FRAMEHEIGHT       	EQU  20     ;height of each frame in blocks

BLOCKSIZE			EQU 20

GAMESCRWIDTH        EQU  FRAMEWIDTH * BLOCKSIZE     ;width of each screen in pixels
GAMESCRHEIGHT       EQU  FRAMEHEIGHT * BLOCKSIZE     ;height of each screen in pixels

						;Tetris grid is 16x10, so each block is 10x10 pixels
GAMELEFTSCRX        DW  30      ;top left corner X of left screen
GAMELEFTSCRY        DW  15      ;top left corner Y of left screen
GAMERIGHTSCRX       DW  370     ;top left corner X of right screen
GAMERIGHTSCRY       DW  15      ;top left corner Y of right screen

;===========================================================================
 Menu11 DB "Please enter your name:"
 Menu12 DB "Press Enter Key to Continue"
 Menu21 DB ", Press F2 to play"
 Menu22 DB ", Press F10 to play" 
 Ready  DB 'R'
 RPly1  DB  0
 RPly2  DB  0
 Separatedline DB  80 DUP ('=')
 SPACE DB ' '
 NAME1 DB 15
		DB ?
Player1		DB 10 DUP(' ')
 NAME2 DB 15
		DB ?
Player2		DB 10 DUP(' ')
;===========================================================================



;CONTROL KEYS (scancodes)

;Controls for left screen
leftDownCode			DB	1Fh		;S key
leftLeftCode			DB	1Eh		;A key
leftRightCode			DB	20h		;D key
leftRotCode				DB	11h		;W key
;Controls for right screen
rightDownCode			DB	50h		;downArrow key
rightLeftCode			DB	4Bh 	;leftArrow key
rightRightCode			DB	4Dh		;rightArrow key
rightRotCode			DB	48h 	;upArrow key

;General ScanCodes
EnterCode  DB 1CH
F2Code     DB 3CH
F10Code    DB 44H 

;CURRENT PIECE INFO
leftPieceId					DB	?			;contains the ID of the current piece
leftPieceOrientation		DB	?			;contains the current orientation of the piece
leftPieceLocX				DB	?			;the Xcoord of the top left corner
leftPieceLocY				DB	?			;the Ycoord of the top left corner
leftPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)
leftPieceSpeed				DB	1			;contains the falling speed of the left piece

rightPieceId				DB	?			;contains the ID of the current piece
rightPieceOrientation		DB	?			;contains the current orientation of the piece
rightPieceLocX				DB	?			;the Xcoord of the top left corner
rightPieceLocY				DB	?			;the Ycoord of the top left corner
rightPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)
rightPieceSpeed				DB	1			;contains the falling speed of the right piece

tempPieceOffset				DW	?			;contains the address of the current piece


collisionPieceId				DB	?			;contains the ID of the current piece
collisionPieceOrientation		DB	?			;contains the current orientation of the piece
collisionPieceLocX				DB	?			;the Xcoord of the top left corner
collisionPieceLocY				DB	?			;the Ycoord of the top left corner
collisionPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)
collisionPieceSpeed				DB	1			;contains the falling speed of the left piece

;PIECES DATA
firstPiece 					DB 0,0,0,0,11,11,11,11,0,0,0,0,0,0,0,0	;Line shape
firstPiece1					DB 0,11,0,0,0,11,0,0,0,11,0,0,0,11,0,0	;Line shape after one rotation
firstPiece2					DB 0,0,0,0,11,11,11,11,0,0,0,0,0,0,0,0	;Line shape after two rotations
firstPiece3					DB 0,11,0,0,0,11,0,0,0,11,0,0,0,11,0,0	;Line shape after Three rotations

secondPiece					DB 1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0	;J shape
secondPiece1				DB 0,1,1,0,0,1,0,0,0,1,0,0,0,0,0,0	;J shape after one rotation
secondPiece2				DB 0,0,0,0,1,1,1,0,0,0,1,0,0,0,0,0	;J shape after two rotations
secondPiece3				DB 0,1,0,0,0,1,0,0,1,1,0,0,0,0,0,0	;J shape after three rotations

thirdPiece 					DB 0,0,0,0,6,6,6,0,6,0,0,0,0,0,0,0	;L shape 
thirdPiece1					DB 6,6,0,0,0,6,0,0,0,6,0,0,0,0,0,0	;L shape after one rotation
thirdPiece2					DB 0,0,6,0,6,6,6,0,0,0,0,0,0,0,0,0	;L shape after two rotations
thirdPiece3					DB 0,6,0,0,0,6,0,0,0,6,6,0,0,0,0,0	;L shape after three rotations

fourthPiece 				DB 0,14,14,0,0,14,14,0,0,0,0,0,0,0,0,0	;square
fourthPiece1				DB 0,14,14,0,0,14,14,0,0,0,0,0,0,0,0,0	;square after one rotation
fourthPiece2				DB 0,14,14,0,0,14,14,0,0,0,0,0,0,0,0,0	;square after two rotations
fourthPiece3				DB 0,14,14,0,0,14,14,0,0,0,0,0,0,0,0,0	;square after three rotation

fifthPiece					DB 0,0,0,0,0,2,2,0,2,2,0,0,0,0,0,0	;S shape
fifthPiece1					DB 0,2,0,0,0,2,2,0,0,0,2,0,0,0,0,0	;S shape after one rotation
fifthPiece2					DB 0,0,0,0,0,2,2,0,2,2,0,0,0,0,0,0	;S shape after two rotations
fifthPiece3					DB 0,2,0,0,0,2,2,0,0,0,2,0,0,0,0,0	;S shape after three rotations

sixthPiece					DB 0,0,0,0,5,5,5,0,0,5,0,0,0,0,0,0	;T shape
sixthPiece1					DB 0,5,0,0,5,5,0,0,0,5,0,0,0,0,0,0	;T shape after one rotation
sixthPiece2					DB 0,5,0,0,5,5,5,0,0,0,0,0,0,0,0,0	;T shape after two rotations
sixthPiece3					DB 0,5,0,0,0,5,5,0,0,5,0,0,0,0,0,0	;T shape after three rotations

seventhPiece 				DB 0,0,0,0,4,4,0,0,0,4,4,0,0,0,0,0	;Z shape
seventhPiece1				DB 0,0,4,0,0,4,4,0,0,4,0,0,0,0,0,0	;Z shape after one rotation
seventhPiece2				DB 0,0,0,0,4,4,0,0,0,4,4,0,0,0,0,0	;Z shape after two rotations
seventhPiece3				DB 0,0,4,0,0,4,4,0,0,4,0,0,0,0,0,0	;Z shape after three rotation

Seconds						DB 99			;Contains the previous second value

GameFlag					DB 1			;Status of the game

GRAYBLOCKCLR				EQU	 8		;color of gray solid blocks
.CODE
;---------------------------        
MAIN    PROC    FAR
		MOV AX, @DATA   ;SETUP DATA ADDRESS
		MOV DS, AX      ;MOV DATA ADDRESS TO DS
		MOV ES, AX
		;call videomode13h
		MOV AH, 00H ; Set video mode
		MOV AL, 13H ; Mode 13h
		INT 10H 
 
		;CALL DisplayMenu 
;-----------------------------------------------

		;MOV AH, 00H       ;PREPARE GFX MODE
		;MOV AL, 13H
		;MOV BX,105H
		;INT 10H         ;ENTER GFX MODE

		mov     AX, 4F02H
        mov     BX, 0105H
        INT     10H

		CALL DrawGameScr

		MOV SI, 0
		CALL GenerateRandomPiece

		MOV SI,4
		CALL GenerateRandomPiece

GAMELP:	
		CALL ParseInput
		CALL PieceGravity
		MOV AL,GameFlag
		CMP AL,1
		JNZ Finished
		JMP GAMELP

Finished:	MOV AH, 4CH     ;SETUP FOR EXIT
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
	INT 10H               ;draw right
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

;---------------------------
;This PROC draws the pixels surrounding the frame of the two players given the parameters in data segment
;@param     none
;@return    none
drawPixelsFrame PROC    NEAR
	MOV SI, 0				;0 for left, 4 for right
	MOV AL, 8               ;frame color
	MOV AH, 0CH             ;draw pixel command

drawPixelsFrameLoop:
	MOV CX, GAMELEFTSCRX[SI]    ;beginning of top left X
	MOV DX, GAMELEFTSCRY[SI]   	;beginning of top left Y
	ADD DX, GAMESCRHEIGHT	  	;go to bottom
	;INC DX						;draw at bottom + 1 as this is the border
	MOV BX, GAMELEFTSCRX[SI]
	ADD BX, GAMESCRWIDTH    ;set right limit
	
	ADD CX,5D
	ADD DX,5D

DRAWPIXELHOR:
	INT 10H                 ;draw bottom
	ADD CX,10D               ;inc X
	CMP CX, BX              ;check if column is at limit
	JBE DRAWPIXELHOR             ;if yes, exit loop
	

	MOV CX, GAMELEFTSCRX+[SI]    ;beginning of top left X
	DEC CX						 ;go to left - 1
	MOV DX, GAMELEFTSCRY+[SI]    ;beginning of top left Y
	
	MOV BX, GAMELEFTSCRY+[SI]
	ADD BX, GAMESCRHEIGHT   	 ;set bottom limit
	
	SUB CX, 5D
	ADD DX, 5D

DRAWPIXELVER:
	INT 10H                 ;draw left

	ADD CX, GAMESCRWIDTH    ;go to right
	ADD CX, 10D				;draw at right + 1
	INT 10H               ;draw right
	SUB CX, GAMESCRWIDTH    ;go back to left	
	SUB CX, 10D

	

	ADD DX,10D                  ;inc Y
	CMP DX, BX              ;check if row is at limit
	JBE DRAWPIXELVER

	ADD SI, 4				;inc SI
	CMP SI, 8				;check if loop ran twice
	JNE	drawPixelsFrameLoop

	RET
drawPixelsFrame ENDP
;---------------------------------
;Takes a block (X,Y) in the N*M grid of tetris and returns the color of the block
;@param		CX: X coord,
;		    DX: Y coord, 
;			SI: screen ID: 0 for left, 4 for right
;@return	AL:	color for (X,Y) grid
GetBlockClr	PROC	NEAR							;XXXXXXXXX - NEEDS TESTING
	PUSH CX
	PUSH DX
	PUSH BX
	MOV AX, CX		;top left of (X,Y) block is BLOCKSIZE*X + gridTopX
	MOV BL, BLOCKSIZE	
	MUL BL
	ADD AX, 5D
	ADD AX, GAMELEFTSCRX[SI]
	MOV	CX, AX		;CX = BLOCKSIZE*Xcoord + gridTopX + 5
	
	MOV AX, DX		;same as above
	MUL BL
	ADD AX, 5D
	ADD AX, GAMELEFTSCRY[SI]
	MOV DX, AX
	
	MOV AH, 0DH
	PUSH BX
	MOV BH, 0
	INT 10H
	POP BX

	POP BX
	POP DX
	POP CX
	RET
GetBlockClr	ENDP
;---------------------------
;Takes a block (X,Y) in the N*M grid of tetris and colors the block with a given color
;@param		CX:	X coord,
;			DX: Y coord,
;			SI: screen ID: 0 for left, 4 for right
;			AL: color for (X,Y) grid
;@return	none
DrawBlockClr	PROC	NEAR
	PUSHA
	MOV DI, AX		;push color to DI
					;go to top left of block
	MOV	AX, CX
	MOV BL, BLOCKSIZE
	MUL BL
	ADD AX, GAMELEFTSCRX[SI]
	MOV CX, AX		;CX = BLOCKSIZE*Xcoord + gridTopX
	
	MOV AX, DX
	MUL BL
	ADD AX, GAMELEFTSCRY[SI]
	MOV DX, AX		;DX = BLOCKSIZE*Ycoord + gridTopY
	
	MOV AX, DI		;pop color to AX
	
	MOV DI, CX		;DI = limit of CX
	ADD DI, BLOCKSIZE		;DI = CX + BLOCKSIZE (LIMIT OF CX)
	MOV BX, DX		;BX = limit of DX
	ADD	BX, BLOCKSIZE		;BX = DX + BLOCKSIZE (LIMIT OF DX)

	MOV AH, 0CH
LOOPX:
	MOV DX, BX		;Reset DX to original Y
	SUB DX, BLOCKSIZE
LOOPY:
	INT 10H			;draw pixel at (CX,DX)
	INC DX			;go to next pixel Y
	CMP DX, BX		
	JNZ LOOPY
	INC CX
	CMP CX, DI
	JNZ LOOPX
	
	POPA
	RET
DrawBlockClr	ENDP
;---------------------------
;This procedure sets the piece data for left or right screen according to tempPieceOffset
;@param			BX: Piece ID			
;@return		none
SetScrPieceData	PROC	NEAR
		PUSHA
		MOV DI,	tempPieceOffset
		MOV SI, 0d			;initialize counter	
		MOV [DI], BX		;move id of selected piece to selectedScreenPiece
		MOV AH, 0
		MOV [DI+1], AH		;set orientation to 0
		MOV AH, 0D
		MOV [DI+3], AH		;set pieceY to 0
		MOV AH, 04D			;set pieceX to 4
		MOV [DI+2], AH
		
		ADD DI, 4d			;jump to piece data
		MOV AX, BX
		MOV BX, 64d			
		MUL BX
		MOV BX, AX
SETSCRPIECELOP:	
		MOV CL, firstPiece[BX][SI]
		MOV [DI], CL
		INC DI
		INC SI
		CMP SI, 16d
		JNZ SETSCRPIECELOP
		POPA
		RET
SetScrPieceData	ENDP
;---------------------------
;This procedure copies the piece address into tempPiece according to SI
;@param			SI: screenId: 0 for left, 4 for right
;@return		none 
GetTempPiece	PROC	NEAR
		PUSH SI
		CMP SI, 0					;If the screen is left
		JNZ	RIGHT
		LEA SI, leftPieceId			;copy the leftPieceOffset to SI
		MOV tempPieceOffset, SI		;load the leftPieceOffset to tempPieceOffset
		JMP EXT
RIGHT:										;else if the screen is right
		LEA SI, rightPieceId		;copy the rightPieceOffset to SI
		MOV tempPieceOffset, SI		;load the rightPieceOffset to tempPieceOffset
EXT:	POP SI
		RET
GetTempPiece	ENDP
;---------------------------
;This procedure clears the current temp piece (used in changing direction or rotation)	;NEEDS TESTING
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
DeletePiece		PROC	NEAR
		PUSHA
		MOV BX, tempPieceOffset
		MOV DI, BX						;Load the piece 4x4 string address in pieceData
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
		MOV CL, [BX+2]				;load selected piece X into CL
		MOV DL, [BX+3]				;load selected piece Y into DL
		ADD CL, AH					;CX = orig_x + id%4
		ADD DL, AL					;DX = orig_y + id/4
		
		MOV AL, 0

		CALL DrawBlockClr
		
		POP  CX
ISBLACK:		
		INC CX
		INC DI
		CMP CX, 16D
		JNZ LOPX
		POPA
		RET
DeletePiece		ENDP
;---------------------------
;This procedure draws the piece stored in temp piece
;in it's corresponding Data,(X,Y)
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
DrawPiece		PROC	NEAR
		PUSHA
		MOV BX, tempPieceOffset
		MOV DI, BX						;Load the piece 4x4 string address in pieceData
		ADD DI,	4						;Go to the string data to put in DI
		MOV CX, 0D						;iterate over the 16 cells of the piece
		;if the piece has color !black, draw it with it's color
		;cell location is:
		;cell_x = orig_x + id%4
		;cell_y = orig_y + id/4
DRAWPIECELOPX:			
		MOV DL, [DI]					;copy the byte of color of current cell into DL
		CMP DL, 0D						;check if color of current piece block is black
		JZ	 DRAWPIECEISBLACK
		
		PUSH CX
		
		MOV AX, CX
		MOV CL, 4D
		DIV CL						;AH = id%4, AL = id/4
		MOV CX, 0
		MOV DX, 0
		MOV CL, [BX+2]				;load selected piece X into CL
		MOV DL, [BX+3]				;load selected piece Y into DL
		ADD CL, AH					;CX = orig_x + id%4
		ADD DL, AL					;DX = orig_y + id/4
		
		MOV AL, [DI]

		CALL DrawBlockClr
		
		POP  CX
DRAWPIECEISBLACK:		
		INC DI
		INC CX
		CMP CX, 16D
		JNZ DRAWPIECELOPX


		POPA
		RET
DrawPiece		ENDP
;---------------------------
;This procedure takes the direction to move the piece in and re-draws it in the new location	;NOT FINISHED
;@param			
;				BX: direction{0:down, 1:left, 2:right}
;				SI: screenId: 0 for left, 4 for right
;@return		NONE
MovePiece		PROC	NEAR
		PUSHA
		PUSH BX

		;PUT TEMP PIECE IN MEMORY
		CALL GetTempPiece

		CALL DeletePiece

		;INSERT COLLISION DETECTION HERE
		CALL setCollisionPiece		;Set the offset of the collision piece from temp piece

		CMP BX, 0D					;check for direction of movement
		JZ DOWNDTEMP
		CMP BX, 1D
		JZ LEFTDTEMP
		CMP BX, 2D
		JZ RIGHTDTEMP
DOWNDTEMP:									;move collision piece downward
		MOV BX, offset collisionPieceId
		INC BYTE PTR [BX+3]
		JMP COLLPIECEBRK
LEFTDTEMP:									;move collision piece left 
		MOV BX, offset collisionPieceId
		DEC BYTE PTR [BX+2]
		JMP COLLPIECEBRK
RIGHTDTEMP:									;move collision piece right
		MOV BX, offset collisionPieceId
		INC BYTE PTR [BX+2]		
COLLPIECEBRK:
		CALL CheckCollision					;check if collisionPiece collides
											;AH will be 1 if it collides, 0 if not
		;CALL DrawPiece
		POP BX
		CMP AL, 1
		PUSHF								;Saves the flags to determine if the piece moved or stayed in place
		JZ	BREAKMOVEPIECE					;If the piece collides, break the procedure and leave

		;DELETE THE PIECE FROM THE SCREEN
		;CALL DeletePiece
		;INSERT MOVING LOGIC HERE
	
		CMP BX, 0D
		JZ DOWND
		CMP BX, 1D
		JZ LEFTD
		CMP BX, 2D
		JZ RIGHTD
DOWND:			
		MOV BX, tempPieceOffset
		INC BYTE PTR [BX+3]
		JMP MOVPIECEBRK
LEFTD:
		MOV BX, tempPieceOffset
		DEC BYTE PTR [BX+2]
		JMP MOVPIECEBRK
RIGHTD:
		MOV BX, tempPieceOffset
		INC BYTE PTR [BX+2]
MOVPIECEBRK:	;DRAW THE NEW PIECE IN NEW LOCATION

BREAKMOVEPIECE:
		CALL DrawPiece
		POPF
		POPA
		RET
MovePiece		ENDP
;---------------------------
;This procedure rotates the current piece that's pointed to by the tempPieceOffset by 90 degree from the previous rotation
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
RotatePiece		PROC NEAR
				PUSHA
				CALL DeletePiece
				CALL GetTempPiece
				MOV BX,tempPieceOffset		;Loads the address of the current piece
				LEA DI,firstPiece
				
				MOV AL,[BX]					;Checks ID of the current piece and stores the offset of the original piece's Data in DI
				CMP AL,0
				JZ	ORIEN
				ADD DI,40H
				CMP AL,1
				JZ ORIEN
				ADD DI,40H
				CMP AL,2
				JZ ORIEN
				ADD DI,40H
				CMP AL,3
				JZ ORIEN
				ADD DI,40H
				CMP AL,4
				JZ ORIEN
				ADD DI,40H
				CMP AL,5
				JZ ORIEN
				ADD DI,40H	

ORIEN:										;Checks the current piece orientation to determine which orientation of the piece to choose
				INC BX	
				MOV AL,[BX]
				CMP AL,0
				JZ ROTATE90
				CMP AL,1
				JZ ROTATE180
				CMP AL,2
				JZ ROTATE270
				CMP AL,3
				JZ ROTATE360
				
		

ROTATE90:		;Checks for collision before rotating the piece	
				MOV CX,10H
				CALL RotationCollision
				JZ BREAK
				;Piece is clear to rotate without collision so we proceed with the rotation process
				MOV CL,1					;sets the new orientation of the piece in the data
				MOV [BX],CL
				ADD BX,3					;SI now points to the left/right piece data
				ADD DI,10H					;DI now points to the data of the new orientation
				MOV CX,16
COPYDATA0:		MOV DL,[DI]
				MOV [BX],DL
				INC DI
				INC BX
				LOOP COPYDATA0
				JMP BREAK
				
ROTATE180:		
				MOV CX,20H
				CALL RotationCollision
				JZ BREAK
				;Piece is clear to rotate without collision so we proceed with the rotation process
				MOV CL,2					;sets the new orientation of the piece in the data
				MOV [BX],CL
				ADD BX,3					;SI now points to the left/right piece data
				ADD DI,20H					;DI now points to the data of the new orientation
				MOV CX,16
COPYDATA1:		MOV DL,[DI]
				MOV [BX],DL
				INC DI
				INC BX
				LOOP COPYDATA1
				JMP BREAK
				
ROTATE270:		
				MOV CX,30H
				CALL RotationCollision
				JZ BREAK
				;Piece is clear to rotate without collision so we proceed with the rotation process
				MOV CL,3					;sets the new orientation of the piece in the data
				MOV [BX],CL
				ADD BX,3					;SI now points to the left/right piece data
				ADD DI,30H					;DI now points to the data of the new orientation
				MOV CX,16
COPYDATA2:		MOV DL,[DI]
				MOV [BX],DL
				INC DI
				INC BX
				LOOP COPYDATA1
				JMP BREAK
				
ROTATE360:		
				MOV CX,00H
				CALL RotationCollision
				JZ BREAK
				;Piece is clear to rotate without collision so we proceed with the rotation process
				MOV CL,0					;sets the new orientation of the piece in the data
				MOV [BX],CL
				ADD BX,3					;SI now points to the left/right piece data
				MOV CX,16
COPYDATA3:		MOV DL,[DI]
				MOV [BX],DL
				INC DI
				INC BX
				LOOP COPYDATA3
				JMP BREAK
						
BREAK:			
				POPA
				CALL DrawPiece				
				RET
RotatePiece		ENDP	
;---------------------------
;This procedure parses input and calls corresponding procedures
;@param			none
;@return		none
ParseInput		PROC	NEAR
		MOV AH, 1
		INT 16H
		JNZ YesInput
		RET
YesInput:
		MOV AH, 0
		INT 16H
LeftRotKey:
		CMP AH, leftRotCode
		JNZ LeftLeftKey

		MOV SI, 0
		CALL GetTempPiece

		MOV SI,0
		CALL RotatePiece

		JMP BreakParseInput
LeftLeftKey:
		CMP AH, leftLeftCode
		JNZ LeftDownKey
		MOV SI, 0
		CALL GetTempPiece

		MOV SI, 0
		MOV BX, 1
		CALL MovePiece

		JMP BreakParseInput
LeftDownKey:
		CMP AH, leftDownCode
		JNZ LeftRightKey
		MOV SI, 0
		CALL GetTempPiece

		MOV SI,0
		MOV BX,0
		CALL MovePiece


		JMP BreakParseInput
LeftRightKey:
		CMP AH, leftRightCode
		JNZ RightRotKey
		MOV SI, 0
		CALL GetTempPiece

		MOV SI,0
		MOV BX,2
		CALL MovePiece

		JMP BreakParseInput
RightRotKey:
		CMP AH, rightRotCode
		JNZ RightLeftKey
		MOV SI, 4
		CALL GetTempPiece

		MOV SI, 4
		CALL RotatePiece

		JMP BreakParseInput
RightLeftKey:
		CMP AH, rightLeftCode
		JNZ RightDownKey
		MOV SI, 4
		CALL GetTempPiece

		MOV SI, 4
		MOV BX, 1
		CALL MovePiece

		JMP BreakParseInput
RightDownKey:
		CMP AH, rightDownCode
		JNZ RightRightKey
		MOV SI, 4
		CALL GetTempPiece

		MOV SI, 4
		MOV BX, 0
		CALL MovePiece

		JMP BreakParseInput
RightRightKey:
		CMP AH, rightRightCode
		JNZ BreakParseInput
		MOV SI, 4
		CALL GetTempPiece
		
		MOV SI, 4
		MOV BX, 2
		CALL MovePiece

BreakParseInput:
		RET
ParseInput		ENDP
;---------------------------
;This Procedure is called in the gameloop to move the pieces downward each second
;@param			none
;@return		none
PieceGravity	PROC	NEAR
		PUSHA
		mov  AH, 2CH
		INT  21H 			;RETURN SECONDS IN DH.
		CMP DH,seconds		;Check if one second has passed
		JE NO_CHANGE
		MOV seconds,DH		;moves current second to the seconds variable
		MOV BX,0			;Parameter to move piece in particular direction
		MOV SI,0
		CALL GetTempPiece	;sets the TempPieceOffset with the address of the leftPiece
		MOV AX,0			;Clearing AX before using it
		MOV AX,tempPieceOffset ;gets the leftPiece's data offset
		ADD AX,14H			;Access the speed of the left piece
		MOV DI,AX			;DI=leftPieceSpeed
		MOV CX,0			;Clears the CX before looping
		MOV CL,[DI]			;moves the piece number of steps equal to it's speed
MOVELEFT:		
		CALL MovePiece
		JZ COLL1
		LOOP MOVELEFT
		JMP CHECK2
COLL1:	MOV SI,0
		CALL CheckLineClear		;check if a line has been cleared
		CALL GenerateRandomPiece
		
CHECK2:	MOV SI,4			
		CALL GetTempPiece	;sets the TempPieceOffset with the address of the rightPiece
		MOV AX,0			;Clearing AX before using it
		MOV AX,tempPieceOffset	;gets the rightPiece's data offset
		ADD AX,14H			;Access the speed of the right piece
		MOV DI,AX			;DI=rightPieceSpeed
		MOV CX,0			;Clears the CX before looping
		MOV CL,[DI]			;moves the piece number of steps equal to it's speed
MOVERIGHT:		
		CALL MovePiece
		JZ	COLL2
		LOOP MOVERIGHT
		JMP NO_CHANGE
COLL2:	MOV SI,4
		CALL CheckLineClear		;check if a line has been cleared
		CALL GenerateRandomPiece
NO_CHANGE:	
		POPA
		RET
PieceGravity	ENDP	
;---------------------------
;This procedure sets the collision piece by copying temp piece data to collision data
;@params	none
;@return 	none
setCollisionPiece	PROC	NEAR
			PUSHA

			MOV SI, tempPieceOffset  		;get the offset of the source data
			MOV DI, offset collisionPieceId	;offset of the destination data

			
			MOV CX, 21D						;loop 21 bytes to copy all the data
copyPieceData:		MOV BL, [SI]					;copy the data in byte to BX
			MOV [DI], BL					;paste the data in the destination byte
			INC DI							;increment destination offset
			INC SI							;increment source offset
			LOOP copyPieceData				;loop

			POPA
			RET
setCollisionPiece	ENDP
;---------------------------
;Procedure to check the collision of the collisionPiece with the blocks
;@params: NONE
;@return: AL: 1 collision, 0 no collision
CheckCollisionWithBlocks	PROC	NEAR
				PUSHA

				MOV BX, offset collisionPieceId
				MOV DI, BX						;Load the piece 4x4 string address in pieceData
				ADD DI,	4						;Go to the string data to put in DI
				MOV CX, 0						;iterate over the 16 cells of the piece
				;if the piece has color !black, draw it with it's color
				;cell location is:
				;cell_x = orig_x + id%4
				;cell_y = orig_y + id/4

		loopOverPieceData:			
				MOV DL, [DI]					;copy the byte of color of current cell into DL
				CMP DL, 0D						;check if color of current piece block is black
				JZ	 checkNextByte

				;If byte has color
				PUSH CX

				MOV AX, CX
				MOV CL, 4D
				DIV CL						;AH = id%4, AL = id/4
				MOV CX, 0
				MOV DX, 0
				MOV CL, [BX+2]				;load selected piece X into CL
				MOV DL, [BX+3]				;load selected piece Y into DL
				ADD CL, AH					;CX = orig_x + id%4
				ADD DL, AL					;DX = orig_y + id/4

				CALL GetBlockClr

				CMP AL, 0D
				POP  CX
				JNZ collisionWithBlockHappens 

				
			
			checkNextByte:
				INC CX		
				INC DI
				CMP CX, 16D
				JNZ loopOverPieceData
				
				POPA
				MOV AL,0D
				RET

				collisionWithBlockHappens:

				POPA
				MOV AL,1D
				RET

CheckCollisionWithBlocks	ENDP
;---------------------------
CheckCollisionWithFrame	PROC	NEAR
						PUSHA

		MOV BX, offset collisionPieceId
		MOV DI, BX						;Load the piece 4x4 string address in pieceData
		ADD DI,	4						;Go to the string data to put in DI
		MOV CX, 0D						;iterate over the 16 cells of the piece
		;if the piece has color !black, draw it with black
		;cell location is:
		;cell_x = orig_x + id%4
		;cell_y = orig_y + id/4
CheckCollisionWithFrameLoop:			
		MOV DL, [DI]					;copy the byte of color of current cell into DL
		CMP DL, 0D						;check if color of current piece block is black
		JZ 	blockEmpty
		
		PUSH CX
		
		MOV AX, CX
		MOV CL, 4D
		DIV CL						;AH = id%4, AL = id/4
		MOV CX, 0
		MOV DX, 0
		MOV CL, [BX+2]				;load selected piece X into CL
		MOV DL, [BX+3]				;load selected piece Y into DL
		ADD CL, AH					;CX = orig_x + id%4
		ADD DL, AL					;DX = orig_y + id/4
		
		CMP CX, FRAMEWIDTH
		JAE outOfScreen
		CMP DX, FRAMEHEIGHT
		JAE outOfScreen 
		 
		POP  CX
blockEmpty:		
		INC CX
		INC DI
		CMP CX, 16D
		JNZ CheckCollisionWithFrameLoop

		POPA
		MOV AL,0
		RET

outOfScreen:
			POP  CX
			POPA
			MOV AL,1
			RET
CheckCollisionWithFrame	ENDP
;---------------------------
;Procedure to check the collision with both the frame and blocks
;@params: SI:0 for left screen,4 for right screen
;@return: AL: 1 collision, 0 no collision
CheckCollision	PROC	NEAR
				CALL CheckCollisionWithFrame
				CMP AL, 1
				JE CollisionHappens

				CALL CheckCollisionWithBlocks
				CMP AL,1
				JE CollisionHappens

				MOV AL,0
				RET
CollisionHappens: 
				MOV AL,1
				RET
CheckCollision	ENDP
;---------------------------
;Procedure to generate a random piece and set it's data in current screen data
;@param		SI:0 for left screen,4 for right screen
;@return 	GameFlag Var = Screen that lost
GenerateRandomPiece		PROC 	NEAR
						PUSHA
						MOV AH,2CH
						INT 21H		;Returns seconds in DH
						MOV AX,0
						MOV AL,DH	;AL=Seconds
						MOV CX,7
						DIV CL
						MOV BX,0
						MOV BL,AH	;BL now contains the ID of the random piece
						CALL GetTempPiece
						CALL SetScrPieceData
						CALL setCollisionPiece
						CALL CheckCollision
						CMP AL,1
						JZ COLLIDE
						CALL DrawPiece
						POPA
						RET
COLLIDE:				
						MOV BX,SI
						MOV GameFlag,BL
						POPA
						RET
GenerateRandomPiece		ENDP

;---------------------------
;Procedure to generate a random piece and set it's data in current screen data
;@param		CL: Random Number % CL 
;@return 	BL: Generated Piece ID 
GenerateRandomNumber	PROC 	NEAR
						PUSH AX
						PUSH DX
						
						MOV AH,2CH
						INT 21H		;Returns seconds in DH
						MOV AX,0
						MOV AL,DH	;AL=Seconds
						DIV CL
						MOV BX,0
						MOV BL,AH	;BL now contains the ID of the random piece
						
						POP DX
						POP AX
						
						RET
GenerateRandomNumber	ENDP
;---------------------------
;Procedure to check for collision before rotation
;@param			CX:Added number to go the correct piece, SI:0 for left , 4 for right
;@				ZF:if 0 then collided ,1 clear to rotate
RotationCollision	PROC	NEAR
				PUSHA
				DEC BX						;SI Points to PieceID
				ADD DI,CX					;DI Points to the data after applying the rotation
				PUSH DI					;Stack holds temporarily offset of the data after rotation
				MOV DI,offset collisionPieceId	;DI = collisionPieceID
				MOV CX,4
COPYCOLL0:		MOV AL,[BX]
				MOV [DI],AL
				INC BX
				INC DI
				LOOP COPYCOLL0
				ADD BX,16D
				ADD DI,16D
				MOV AL,[BX]
				MOV [DI],AL
				SUB DI,16D
				POP BX			;BX holds offset of the data after rotation
				MOV CX,16
COPYCOLLDATA0:	MOV AL,[BX]
				MOV [DI],AL
				INC BX
				INC DI
				LOOP COPYCOLLDATA0
				CALL CheckCollision
				CMP AL,1
				POPA
				RET
RotationCollision	ENDP
;---------------------------
;Shifts all the line up from Y = 0:14	 and X = 0:9
;@param			SI: screen ID: 0 for left, 4 for right
;@return		none
ShiftLinesUp	PROC	NEAR
				PUSHA

				CALL GetTempPiece
				CALL DeletePiece		;we need to remove the piece before shifting, to avoid shifting the piece itself

				MOV DX, 0D				;initialize dx at 0
SHIFTUPLOOPY:
				MOV CX, 0D
SHIFTUPLOOPX:
				INC DX
				CALL GetBlockClr		;get block color at (X,Y+1)
				DEC DX
				CALL DrawBlockClr		;draw block color at (X,Y)

				INC CX
				CMP CX, FRAMEWIDTH		;check if X is 10
				JNZ SHIFTUPLOOPX		;if it is, start back from X = 0 at new Y

				INC DX	
				CMP DX, FRAMEHEIGHT-1	;check if Y is = 15
				JNZ SHIFTUPLOOPY

				CALL DrawPiece

				POPA
				RET
ShiftLinesUp	ENDP
;---------------------------
;Shifts all the line down from Y = 0:Y_in and X = 0:9
;@param 		SI: screen ID: 0 for left, 4 for right
;				DX:	Y_in to begin shifting down at
;@return		none
ShiftLinesDown	PROC	NEAR
				PUSHA
				;DX is initially Y_in
SHIFTDOWNLOOPY:
				MOV CX, 0D
SHIFTDOWNLOOPX:
				DEC DX
				CALL GetBlockClr		;get block color at (X,Y+1)
				INC DX
				CALL DrawBlockClr		;draw block color at (X,Y)

				INC CX
				CMP CX, FRAMEWIDTH		;check if X is = FRAME WIDTH
				JNZ SHIFTDOWNLOOPX		;if it is, start back from X = 0 at new Y

				DEC DX	
				CMP DX, 0D 				;check if Y is = 0
				JNZ SHIFTDOWNLOOPY

				MOV CX, 0D
				MOV DX, 0D
				MOV AL, 0D
CLEARFIRSTLINE:	
				CALL DrawBlockClr				
				INC CX
				CMP CX, 10D
				JNZ CLEARFIRSTLINE
				POPA
				RET
ShiftLinesDown	ENDP
;---------------------------
;This procedure inserts a new gray line at the screen
;@param			SI: screen ID: 0 for left, 4 for right
;@return		none
InsertLine		PROC	NEAR
				PUSHA
				CALL ShiftLinesUp		;shift all lines up 1 block

				;draw a gray line at X = 0
				MOV DX, FRAMEHEIGHT-1
				MOV CX, 0D
				MOV AL, GRAYBLOCKCLR
INSERTLINELOOPX:						;loop from x=0:10 and draw gray block		
				CALL DrawBlockClr
				INC CX
				CMP CX, FRAMEWIDTH		
				JNZ INSERTLINELOOPX

				POPA
				RET
InsertLine		ENDP
;---------------------------
;This procedure removes the line at Y = Y_in and shifts all lines down
;@param			SI: screen ID: 0 for left, 4 for right
;				DX: Y_in to have the line removed at
;@return		none
RemoveLine		PROC	NEAR

				CALL ShiftLinesDown

				RET
RemoveLine		ENDP
;---------------------------
;This procedure checks if a full line has been completed, if it is, it gets cleared
;@param			SI: screen ID: 0 for left, 4 for right
;@return		none
CheckLineClear	PROC	NEAR
				PUSHA

				MOV DX, 0D
CHECKLINELOOPY:
				MOV CX, 0D
				MOV BX, 0D 					;counter for the number of colored blocks
CHECKLINELOOPX:
				CALL GetBlockClr
				CMP AL, 0D					;if block color is not black or gray, inc BX
				JE 	CHECKLINESKIPINC
				CMP AL, GRAYBLOCKCLR
				JE	CHECKLINESKIPINC

				INC BX
				INC CX
				CMP CX, FRAMEWIDTH
				JNZ CHECKLINELOOPX
CHECKLINESKIPINC:
				CMP BX, 10D					;check if there is 16 colored blocks
				JNZ	CHECKLINESKIPRMV		;if there is, delete that line
				CALL RemoveLine
				;now we need to insert a line at the other player
				MOV AX, SI
				CMP SI, 0D
				JNZ CHECKLINESIIS0			;if SI is 4, make it 0, if it's 0, make it 4
				MOV SI, 4D
				JMP CHECKLINESIIS4
CHECKLINESIIS0:
				MOV SI, 0D
CHECKLINESIIS4:
				CALL InsertLine				;insert a line at the other player
				MOV SI, AX					;reset the SI value back
CHECKLINESKIPRMV:
				INC DX
				CMP DX, FRAMEHEIGHT
				JNZ CHECKLINELOOPY

				POPA
				RET
CheckLineClear	ENDP
;---------------------------
;Procedure to show menu on opening the game 
;@param			CX:Added number to go the correct piece
;@				ZF:if 0 then collided ,1 clear to rotate
DisplayMenu 		PROC     NEAR
MOV BP, OFFSET Menu11 ; ES: BP POINTS TO THE TEXT
MOV CX,23 ;SIZE OF STRING
MOV DH, 6 ;ROW TO PLACE STRING
MOV DL, 10 ; COLUMN TO PLACE STRING
;CALL PRINTMESSAGE
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
MOV BL, 15 ;WHITE
XOR BH,BH ; VIDEO PAGE = 0
INT 10H

MOV DH, 11 ;ROW TO PLACE CURSOR
MOV DL, 10 ; COLUMN TO PLACE CURSOR
;CALL MOVECURSOR
mov AH,2          ;Move Cursor
INT 10H

MOV DX,OFFSET NAME1
;CALL GETMESSAGE
MOV AH,0AH 
INT 21H

MOV BP, OFFSET Menu12 ; ES: BP POINTS TO THE TEXT
MOV CX, 27 ; LENGTH OF THE STRING
MOV DH, 14 ;ROW TO PLACE STRING
MOV DL, 10 ; COLUMN TO PLACE STRING
;CALL PRINTMESSAGE
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
MOV BL, 15 ;WHITE
XOR BH,BH ; VIDEO PAGE = 0
INT 10H

WAIT4Enter: ;CALL WAIT4KEY
			mov ah,0
			int 16h 
			CMP AH,	EnterCode
			JNE WAIT4Enter
			
;Call ClearScreen
MOV AH, 00H ; Set video mode
MOV AL, 13H ; Mode 13h
INT 10H 

MOV BP, OFFSET Menu11 ; ES: BP POINTS TO THE TEXT
MOV CX,23 ;SIZE OF STRING
MOV DH, 6 ;ROW TO PLACE STRING
MOV DL, 10 ; COLUMN TO PLACE STRING
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
MOV BL, 15 ;WHITE
XOR BH,BH ; VIDEO PAGE = 0
INT 10H

MOV DH, 11 ;ROW TO PLACE CURSOR
MOV DL, 10 ; COLUMN TO PLACE CURSOR
;CALL MOVECURSOR
mov AH,2          ;Move Cursor
INT 10H

MOV DX,OFFSET NAME2
;CALL GETMESSAGE
MOV AH,0AH 
INT 21H

MOV BP, OFFSET Menu12 ; ES: BP POINTS TO THE TEXT
MOV CX, 27 ; LENGTH OF THE STRING
MOV DH, 14 ;ROW TO PLACE STRING
MOV DL, 10 ; COLUMN TO PLACE STRING
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
MOV BL, 15 ;WHITE
XOR BH,BH ; VIDEO PAGE = 0
INT 10H
			
WAIT4Enter2: ;CALL WAIT4KEY
			mov ah,0
			int 16h 
			CMP AH,	EnterCode
			JNE WAIT4Enter2
			
;CALL DisplayMenu2
			
;Call ClearScreen
MOV AH, 00H ; Set video mode
MOV AL, 13H ; Mode 13h
INT 10H

MOV BP, OFFSET Name1 + 2; ES: BP POINTS TO THE TEXT
;INC BP  ;FOR IP text only
MOV CX,10 ;SIZE OF STRING    ;FOR IP text only
;INC BP  ;FOR IP text only
MOV DH, 6 ;ROW TO PLACE STRING
MOV DL, 6 ; COLUMN TO PLACE STRING
;CALL PRINTMESSAGE
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
MOV BL, 15 ;WHITE
XOR BH,BH ; VIDEO PAGE = 0
INT 10H
	
MOV BP, OFFSET Menu21 ; ES: BP POINTS TO THE TEXT
MOV CX,18 ;SIZE OF STRING
MOV DH, 6 ;ROW TO PLACE STRING
MOV DL, 12 ; COLUMN TO PLACE STRING
;CALL PRINTMESSAGE
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
MOV BL, 15 ;WHITE
XOR BH,BH ; VIDEO PAGE = 0
INT 10H


MOV BP, OFFSET Name2 + 2 ; ES: BP POINTS TO THE TEXT
;INC BP  ;FOR IP text only
MOV CX, 10 ;[BP] ;SIZE OF STRING    ;FOR IP text only
;INC BP  ;FOR IP text only
MOV DH, 10 ;ROW TO PLACE STRING
MOV DL, 6 ; COLUMN TO PLACE STRING
;CALL PRINTMESSAGE
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
MOV BL, 15 ;WHITE
XOR BH,BH ; VIDEO PAGE = 0
INT 10H
	
MOV BP, OFFSET Menu22 ; ES: BP POINTS TO THE TEXT
MOV CX,19 ;SIZE OF STRING
MOV DH, 10 ;ROW TO PLACE STRING
MOV DL, 12 ; COLUMN TO PLACE STRING
;CALL PRINTMESSAGE
MOV AH, 13H ; WRITE THE STRING
MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
MOV BL, 15 ;WHITE
XOR BH,BH ; VIDEO PAGE = 0
INT 10H

;CALL Wait4Key
Wait4Ready: ;CALL WAIT4KEY
			MOV AH,0
			INT 16H
			CMP AH,	F2Code
			JE F2Pressed
			CMP AH, F10Code
			JNE WAIT4Ready
			INC AH
			MOV RPly2,AH
    MOV DH, 11 ;ROW TO PLACE STRING
    MOV DL, 6 ; COLUMN TO PLACE STRING
;CALL SetCursorPos
    MOV AH,02H  ; CURSOR POS SET 
    XOR BH,BH ; VIDEO PAGE = 0
    INT 10H ;Set Cursor Pos
    MOV AH, 09H
    MOV AL, 'R'; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION 
    MOV BL, 15 ;WHITE
    XOR BH,BH ; VIDEO PAGE = 0 
    MOV CX, 1
    INT 10H		
			JMP CheckR
F2Pressed:  INC AH
			MOV RPly1,AH
    MOV DH, 7 ;ROW TO PLACE STRING
    MOV DL, 6 ; COLUMN TO PLACE STRING
;CALL SetCursorPos
    MOV AH,02H  ; CURSOR POS SET 
    XOR BH,BH ; VIDEO PAGE = 0
    INT 10H ;Set Cursor Pos
    MOV AH, 09H
    MOV AL, 'R'; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION 
    MOV BL, 15 ;WHITE
    XOR BH,BH ; VIDEO PAGE = 0 
    MOV CX, 1
    INT 10H

CheckR:     CMP AH,5H
			MOV AH, RPly1
			AND AH, RPly2
			JZ  Wait4Ready
			
DisplayMenu      ENDP
;---------------------------------------------------


END     MAIN