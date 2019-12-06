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

FRAMETEXTOFFSET		EQU 50

NEXTPIECETEXTLENGTH EQU 4
NEXTPIECETEXT		DB	"Next"
LEFTNEXTPIECELOCX	EQU 45
LEFTNEXTPIECELOCY	EQU 3
RIGHTNEXTPIECELOCX	EQU 107
RIGHTNEXTPIECELOCY	EQU 3


SCORETEXTLENGTH		EQU 5
SCORETEXT			DB	"Score"
LeftScoreLocX		EQU 45
LeftScoreLocY		EQU 10
RightScoreLocX		EQU 107
RightScoreLocY		EQU 10

LeftScoreTextLength EQU 2
LeftScoreText		DB "00"
LeftScoreStringLocX	EQU 45
LeftScoreStringLocY	EQU LeftScoreLocY+1

RightScoreTextLength 	EQU 2
RightScoreText			DB "00"
RightScoreStringLocX	EQU 107
RightScoreStringLocY	EQU RightScoreLocY+1

FreezeStringLength		EQU 6
FreezeStringColor		EQU 4
FreezeString			DB	"Freeze"
LeftFreezeLocX			EQU 45
LeftFreezeLocY			EQU 13
RightFreezeLocX			EQU 107
RightFreezeLocY			EQU 13

LeftFreezeTextLength 	EQU 2
LeftFreezeText			DB "00"
LeftFreezeStringLocX	EQU 45
LeftFreezeStringLocY	EQU LeftFreezeLocY+1

RightFreezeTextLength 	EQU 2
RightFreezeText			DB "00"
RightFreezeStringLocX	EQU 107
RightFreezeStringLocY	EQU RightFreezeLocY+1

SpeedUpStringLength		EQU 8
SpeedUpString			DB	"Speed Up"
LeftSpeedUpLocX			EQU 45
LeftSpeedUpLocY			EQU 16
RightSpeedUpLocX		EQU 107
RightSpeedUpLocY		EQU 16

LeftSpeedUpTextLength 	EQU 2
LeftSpeedUpText			DB "00"
LeftSpeedUpStringLocX	EQU 45
LeftSpeedUpStringLocY	EQU LeftSpeedUpLocY+1

RightSpeedUpTextLength 	EQU 2
RightSpeedUpText		DB "00"
RightSpeedUpStringLocX	EQU 107
RightSpeedUpStringLocY	EQU RightSpeedUpLocY+1

RemoveLinesStringLength		EQU 12
RemoveLinesString			DB	"Remove Lines"
LeftRemoveLinesLocX			EQU 45
LeftRemoveLinesLocY			EQU 19
RightRemoveLinesLocX		EQU 107
RightRemoveLinesLocY		EQU 19

LeftRemoveLinesTextLength 	EQU 2
LeftRemoveLinesText			DB "00"
LeftRemoveLinesStringLocX	EQU 45
LeftRemoveLinesStringLocY	EQU LeftRemoveLinesLocY+1

RightRemoveLinesTextLength 	EQU 2
RightRemoveLinesText		DB "00"
RightRemoveLinesStringLocX	EQU 107
RightRemoveLinesStringLocY	EQU RightRemoveLinesLocY+1

ChangePieceStringLength		EQU 12
ChangePieceString			DB	"Change Piece"
LeftChangePieceLocX			EQU 45
LeftChangePieceLocY			EQU 22
RightChangePieceLocX		EQU 107
RightChangePieceLocY		EQU 22

LeftChangePieceTextLength	EQU 2
LeftChangePieceText			DB "00"
LeftChangePieceStringLocX	EQU 45
LeftChangePieceStringLocY	EQU LeftChangePieceLocY+1

RightChangePieceTextLength 	EQU 2
RightChangePieceText		DB "00"
RightChangePieceStringLocX	EQU 107
RightChangePieceStringLocY	EQU RightChangePieceLocY+1


DeltaScore	EQU 1

						;Tetris grid is 20X10, so each block is 20X20 pixels
GAMELEFTSCRX        DW  100     ;top left corner X of left screen
GAMELEFTSCRY        DW  30      ;top left corner Y of left screen
GAMERIGHTSCRX       DW  600     ;top left corner X of right screen
GAMERIGHTSCRY       DW  30      ;top left corner Y of right screen


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

PowerupEveryPoint			EQU 4

;CURRENT PIECE INFO
leftPieceId					DB	?			;contains the ID of the current piece
leftPieceOrientation		DB	?			;contains the current orientation of the piece
leftPieceLocX				DB	?			;the Xcoord of the top left corner
leftPieceLocY				DB	?			;the Ycoord of the top left corner
leftPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)
leftPieceSpeed				DB	1			;contains the falling speed of the left piece
Player1Score				DB	0			;score of first player
leftPowerup1Count			DB  0
leftPowerup2Count			DB  0
leftPowerup3Count			DB	0
leftPowerup4Count			DB 	0
leftPowerup5Count			DB 	0
leftPieceRotationLock 		DB 0 	;lock the rotation of the piece 0:locked 1:free

rightPieceId				DB	?			;contains the ID of the current piece
rightPieceOrientation		DB	?			;contains the current orientation of the piece
rightPieceLocX				DB	?			;the Xcoord of the top left corner
rightPieceLocY				DB	?			;the Ycoord of the top left corner
rightPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)
rightPieceSpeed				DB	1			;contains the falling speed of the right piece
Player2Score				DB	0			;score of second player
rightPowerup1Count			DB 	0
rightPowerup2Count			DB	0
rightPowerup3Count			DB	0
rightPowerup4Count			DB	0
rightPowerup5Count			DB	0
rightPieceRotationLock	DB 0	;lock the rotation of the piece 0:locked 1:free


tempPieceOffset				DW	?			;contains the address of the current piece


collisionPieceId				DB	?			;contains the ID of the current piece
collisionPieceOrientation		DB	?			;contains the current orientation of the piece
collisionPieceLocX				DB	?			;the Xcoord of the top left corner
collisionPieceLocY				DB	?			;the Ycoord of the top left corner
collisionPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)
collisionPieceSpeed				DB	1			;contains the falling speed of the left piece

;NEXT PIECE INFO
nextLeftPieceId					DB	?			;contains the ID of the current piece
nextLeftPieceOrientation		DB	?			;contains the next orientation of the piece
nextLeftPieceLocX				DB	?			;the Xcoord of the top left corner
nextLeftPieceLocY				DB	?			;the Ycoord of the top left corner
nextLeftPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)

nextRightPieceId				DB	?			;contains the ID of the current piece
nextRightPieceOrientation		DB	?			;contains the current orientation of the piece
nextRightPieceLocX				DB	?			;the Xcoord of the top left corner
nextRightPieceLocY				DB	?			;the Ycoord of the top left corner
nextRightPieceData				DB	16 DUP(?)	;contains the 4x4 matrix of the piece (after orientation)

tempNextPieceOffset				DW	?			;contains the address of the next piece

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
		CALL DrawGUIText

		MOV SI,0
		MOV BX,0
		CALL GetTempNextPiece
		CALL SetNextPieceData
		CALL GenerateRandomPiece

		MOV SI,4
		MOV BX,0
		CALL GetTempNextPiece
		CALL SetNextPieceData
		CALL GenerateRandomPiece

		; MOV SI,4
		; CALL FreezeRotation
		; CALL SpeedUpOpponentPiece

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
;This procedure sets the next piece data for left or right screen according to tempNextPieceOffset
;@param			BX: Piece ID			
;@return		none
SetNextPieceData	PROC	NEAR
		PUSHA
		MOV DI,	tempNextPieceOffset
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
SetNextPieceData	ENDP
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
;This procedure copies the next piece address into tempNextPiece according to SI
;@param			SI: screenId: 0 for left, 4 for right
;@return		none 
GetTempNextPiece	PROC	NEAR
		PUSH SI
		CMP SI, 0					;If the screen is left
		JNZ	RIGHT1
		LEA SI, nextLeftPieceId			;copy the leftPieceOffset to SI
		MOV tempNextPieceOffset, SI		;load the leftPieceOffset to tempPieceOffset
		JMP EXT1
RIGHT1:										;else if the screen is right
		LEA SI, nextRightPieceId		;copy the rightPieceOffset to SI
		MOV tempNextPieceOffset, SI		;load the rightPieceOffset to tempPieceOffset
EXT1:	POP SI
		RET
GetTempNextPiece	ENDP
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

		CMP leftPieceRotationLock,1 ;check if the rotation is locked
		JZ LeftRotKeyParsed

		MOV SI, 0
		CALL GetTempPiece

		MOV SI,0
		CALL RotatePiece
LeftRotKeyParsed:
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

		CMP rightPieceRotationLock,1 ;check if the rotation is locked
		JZ BreakParseInput

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
COLL1:	
		MOV SI,0
		CALL UnfreezeRotation
		CALL ResetPieceSpeed	;if changed reset it to its original
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
COLL2:	
		MOV SI,4
		CALL UnfreezeRotation
		CALL ResetPieceSpeed	;if chnaged reset it to its original speed
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
						CALL CopyNextPieceData
						CALL GetTempNextPiece
						CALL DeleteNextPiece
						CALL SetNextPieceData
						CALL DrawNextPiece
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
;Procedure to generate a random number
;@param		CL: Random Number % CL 
;@return 	BL: the random number
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
				ADD Player1Score, DeltaScore		;increase score
				CALL AddPowerupCheck
				CALL UpdatePlayersScore

				MOV SI, 4D
				JMP CHECKLINESIIS4
CHECKLINESIIS0:
				MOV SI, 0D
				ADD Player2Score, DeltaScore		;increase score
				CALL AddPowerupCheck
				CALL UpdatePlayersScore
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
;Parses score number into text to be displayed on the screen
;Params		NONE
;Returns 	NONE
ChangeScoreToText	PROC	NEAR
					PUSHA
					MOV AH, 0
					MOV AL,Player1Score
					MOV CL,10D
					DIV CL
					ADD AL,30H
					LEA SI,LeftScoreText
					MOV [SI],AL
					INC SI
					ADD AH,30H
					MOV [SI],AH

					MOV AH, 0
					MOV AL,Player2Score
					MOV CL,10D
					DIV CL
					ADD AL,30H
					LEA SI,RightScoreText
					MOV [SI],AL
					INC SI
					ADD AH,30H
					MOV [SI],AH
					
					POPA
					RET
ChangeScoreToText	ENDP
;---------------------------------------------------
;This procedure is responsible for drawing the text for the UI
;@param				none
;@return			none
DrawGUIText		PROC	NEAR
				PUSHA

				;render the left screen next piece text
				mov ah, 13h
				mov cx, NEXTPIECETEXTLENGTH
				mov dh, LEFTNEXTPIECELOCY
				mov dl, LEFTNEXTPIECELOCX
				lea bp, NEXTPIECETEXT
				mov bx, 4d
				int 10h

				;render the right screen next piece text
				mov ah, 13h
				mov cx, NEXTPIECETEXTLENGTH
				mov dh, RIGHTNEXTPIECELOCY
				mov dl, RIGHTNEXTPIECELOCX
				lea bp, NEXTPIECETEXT
				mov bx, 4d
				int 10h
				
				;render the left screen score text
				mov ah, 13h
				mov cx, SCORETEXTLENGTH
				mov dh, LeftScoreLocY
				mov dl, LeftScoreLocX
				lea bp, SCORETEXT
				mov bx, 4d
				int 10h
				
				;render the left screen score text
				mov ah, 13h
				mov cx, SCORETEXTLENGTH
				mov dh, RightScoreLocY
				mov dl, RightScoreLocX
				lea bp, SCORETEXT
				mov bx, 4d
				int 10h

				CALL UpdatePlayersScore	;render the score itself

				;render left powerups

				mov ah, 13h
				mov cx, FreezeStringLength
				mov dh, LeftFreezeLocY
				mov dl, LeftFreezeLocX
				lea bp, FreezeString
				mov bx, 4d
				int 10h

				mov ah, 13h
				mov cx, SpeedUpStringLength
				mov dh, LeftSpeedUpLocY
				mov dl, LeftSpeedUpLocX
				lea bp, SpeedUpString
				mov bx, 4d
				int 10h

				mov ah, 13h
				mov cx, RemoveLinesStringLength
				mov dh, LeftRemoveLinesLocY
				mov dl, LeftRemoveLinesLocX
				lea bp, RemoveLinesString
				mov bx, 4d
				int 10h

				mov ah, 13h
				mov cx, ChangePieceStringLength
				mov dh, LeftChangePieceLocY
				mov dl, LeftChangePieceLocX
				lea bp, ChangePieceString
				mov bx, 4d
				int 10h

				;render right powerups

				mov ah, 13h
				mov cx, FreezeStringLength
				mov dh, RightFreezeLocY
				mov dl, RightFreezeLocX
				lea bp, FreezeString
				mov bx, 4d
				int 10h

				mov ah, 13h
				mov cx, SpeedUpStringLength
				mov dh, RightSpeedUpLocY
				mov dl, RightSpeedUpLocX
				lea bp, SpeedUpString
				mov bx, 4d
				int 10h

				mov ah, 13h
				mov cx, RemoveLinesStringLength
				mov dh, RightRemoveLinesLocY
				mov dl, RightRemoveLinesLocX
				lea bp, RemoveLinesString
				mov bx, 4d
				int 10h

				mov ah, 13h
				mov cx, ChangePieceStringLength
				mov dh, RightChangePieceLocY
				mov dl, RightChangePieceLocX
				lea bp, ChangePieceString
				mov bx, 4d
				int 10h

				POPA
				RET
DrawGUIText		ENDP
;---------------------------------------------------
;This procedure parses the scores of the two players and changes
;it to strings, then draws them on the screen
;@param			none
;@return		none
UpdatePlayersScore	PROC	NEAR
					PUSHA
					CALL ChangeScoreToText

					mov ah, 13h
					mov cx, LeftScoreTextLength
					mov dh, LeftScoreStringLocY
					mov dl, LeftScoreStringLocX
					lea bp, LeftScoreText
					mov bx, 4d
					int 10h

					mov ah, 13h
					mov cx, RightScoreTextLength
					mov dh, RightScoreStringLocY
					mov dl, RightScoreStringLocX
					lea bp, RightScoreText
					mov bx, 4d
					int 10h
					POPA
					RET
UpdatePlayersScore	ENDP
;---------------------------------------------------
;This procedure copies data of the next piece to the current piece to draw it
;@params		SI: 0 for left screen,4 for right screen
;@returns 		NONE
CopyNextPieceData	PROC	NEAR
					PUSHA
					
					CALL GetTempNextPiece
					MOV DI,tempNextPieceOffset

					CALL GetTempPiece
					MOV SI,tempPieceOffset
					
					MOV CX,20D
					
CPY:				MOV AL,[DI]
					MOV [SI],AL
					INC SI
					INC DI
					LOOP CPY
					POPA
					RET
CopyNextPieceData	ENDP
;---------------------------
;This procedure draws the piece stored in temp piece
;in it's corresponding Data,(X,Y)
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
DrawNextPiece		PROC	NEAR
		PUSHA
		MOV BX, tempNextPieceOffset
		MOV DI, BX						;Load the piece 4x4 string address in pieceData
		ADD DI,	4						;Go to the string data to put in DI
		MOV CX, 0D						;iterate over the 16 cells of the piece
		;if the piece has color !black, draw it with it's color
		;cell location is:
		;cell_x = orig_x + id%4
		;cell_y = orig_y + id/4
DRAWPIECELOPX1:			
		MOV DL, [DI]					;copy the byte of color of current cell into DL
		CMP DL, 0D						;check if color of current piece block is black
		JZ	 DRAWPIECEISBLACK1
		
		PUSH CX
		
		MOV AX, CX
		MOV CL, 4D
		DIV CL						;AH = id%4, AL = id/4
		MOV CX, 0
		MOV DX, 0
		MOV CL, 12				;load selected piece X into CL
		MOV DL, 2				;load selected piece Y into DL
		ADD CL, AH					;CX = orig_x + id%4
		ADD DL, AL					;DX = orig_y + id/4
		
		MOV AL, [DI]

		CALL DrawBlockClr
		
		POP  CX
DRAWPIECEISBLACK1:		
		INC DI
		INC CX
		CMP CX, 16D
		JNZ DRAWPIECELOPX1


		POPA
		RET
DrawNextPiece		ENDP
;---------------------------
;---------------------------
;This procedure clears the current temp piece (used in changing direction or rotation)	;NEEDS TESTING
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
DeleteNextPiece		PROC	NEAR
		PUSHA
		MOV BX, tempNextPieceOffset
		MOV DI, BX						;Load the piece 4x4 string address in pieceData
		ADD DI,	4						;Go to the string data to put in DI
		MOV CX, 0D						;iterate over the 16 cells of the piece
		;if the piece has color !black, draw it with black
		;cell location is:
		;cell_x = orig_x + id%4
		;cell_y = orig_y + id/4
LOPX1:			
		MOV DL, [DI]					;copy the byte of color of current cell into DL
		CMP DL, 0D						;check if color of current piece block is black
		JZ 	ISBLACK1
		
		PUSH CX
		
		MOV AX, CX
		MOV CL, 4D
		DIV CL						;AH = id%4, AL = id/4
		MOV CX, 0
		MOV DX, 0
		MOV CL, 12				;load selected piece X into CL
		MOV DL, 2				;load selected piece Y into DL
		ADD CL, AH					;CX = orig_x + id%4
		ADD DL, AL					;DX = orig_y + id/4
		
		MOV AL, 0

		CALL DrawBlockClr
		
		POP  CX
ISBLACK1:		
		INC CX
		INC DI
		CMP CX, 16D
		JNZ LOPX1
		POPA
		RET
DeleteNextPiece		ENDP
;---------------------------
;This procedure checks if a player should get a powerup now, if he should, then add a random powerup to him
;@param				SI: 0 for player1, 4 for player2
;@return			none
AddPowerupCheck		PROC	NEAR
					PUSHA
					CMP SI, 0
					JNZ PowerupSIis4
					LEA DI, Player1Score	;load offset playerscore1 into bx
					JMP PowerupBreak
PowerupSIis4:
					LEA DI, Player2Score	;load offset playerscore2 into bx
PowerupBreak:
					MOV AH, 0
					MOV AL, [DI]
					MOV CL, PowerupEveryPoint			;check if score is divisible by powerupPoints
					DIV CL					;divide score by CL, check if it is divisible by it
					CMP AH, 0
					JNZ NoPowerUp
					MOV BX, 0
					MOV CL, 5				;number of powerups
					CALL GenerateRandomNumber
					;bl now has a random number from 0 to 3 inclusive
					ADD DI, BX
					INC DI					;moves DI to rand_number+1
					MOV BL, 1
					ADD [DI], BL			;increases the number of that powerup
NoPowerUp:
					POPA
					RET
AddPowerupCheck		ENDP
;---------------------------
;This procedure removes four lines from a given screen
;@param			SI: screenId: 0 for left, 4 for right
;@return		none
RemoveFourLines		PROC	NEAR
		PUSHA
		
		MOV CX,4									;number of lines to be removed
		
		;get the last row in the grid
		MOV DX, FRAMEHEIGHT			
		DEC DX

RemoveFourLinesLoop: 
		CALL RemoveLine			
		DEC DX										;go to next line
		LOOP RemoveFourLinesLoop

		POPA
		RET
RemoveFourLines		ENDP
;---------------------------
;This procedure speeds up the block speed at the opponent
;@param			SI: screenId of the calling player: 0 will affect the right screen, 4 will affect the left screen
;@return		none
SpeedUpOpponentPiece		PROC	NEAR
		PUSHA
		
		CMP SI, 4							;if it is called by the right player
		JZ SpeedUpLeftPlayer	;increase left player piece speed

	SpeedUpRightPlayer:
		ADD rightPieceSpeed	,5
		POPA
		RET	

	SpeedUpLeftPlayer:
		INC leftPieceSpeed
		POPA
		RET

SpeedUpOpponentPiece		ENDP
;---------------------------
;This procedure reset the speed of the piece  to its original speed
;@param			SI: screenId 0 for left, 4 for right
;@return		none
ResetPieceSpeed		PROC	NEAR
		PUSHA
		
		CMP SI, 4						;check which screen to reset its piece speed
		JZ ResetRightSpeed	

	ResetLeftSpeed:
		MOV CL, leftPieceSpeed
		CMP CL,1
		JZ BreakResetPieceSpeed
		MOV leftPieceSpeed, 1	;set the piece speed to  1
		JMP BreakResetPieceSpeed

	ResetRightSpeed:
		MOV CL, rightPieceSpeed
		CMP CL,1
		JZ BreakResetPieceSpeed
		MOV rightPieceSpeed, 1	;set the piece speed to  1

	BreakResetPieceSpeed:
		POPA
		RET

ResetPieceSpeed		ENDP
;---------------------------
;This procedure freeze the rotation for the opponent
;@param			SI: screenId of the calling player 0: will affect the right screen 4: will affect the left screen
;@return		none
FreezeRotation		PROC	NEAR
		PUSHA
		
		CMP SI, 4						;if it is called by right screen freeze left piece
		JZ FreezeRotationLeftPiece	

	FreezeRotationRightPiece:
		MOV rightPieceRotationLock, 1 ;set the piece speed to  1
		POPA
		RET

	FreezeRotationLeftPiece:
		MOV leftPieceRotationLock, 1	;set the piece speed to  1
		POPA
		RET

FreezeRotation		ENDP
;---------------------------
;This procedure unfreeze the rotation for specific screen 
;@param			SI: screenId 0: left 4: right
;@return		none
UnfreezeRotation		PROC	NEAR
		PUSHA
		
		CMP SI, 4						;if it is called by right screen freeze left piece
		JZ UnfreezeRightScreen	

	UnfreezeLeftScreen:
		MOV CL, leftPieceRotationLock	;get the lock variable
		CMP CL, 0															
		JZ BreakUnfreezeRotation			
		MOV leftPieceRotationLock, 0	;reset lock variable to 0 if it wasn't
		JMP BreakUnfreezeRotation

	UnfreezeRightScreen:
		MOV CL, rightPieceRotationLock	;get the lock variable
		CMP CL, 0															
		JZ BreakUnfreezeRotation			
		MOV rightPieceRotationLock, 0	;reset lock variable to 0 if it wasn't
		
	BreakUnfreezeRotation:
		POPA
		RET

UnfreezeRotation		ENDP
;---------------------------
END     MAIN