;x86 asm Tetris
;Microprocessors Project
;---------------------------        
		.MODEL HUGE 
        .STACK 64
        .DATA
		;INSERT DATA HERE
SCRWIDTH		DB	?
SCRHEIGHT		DB	?
LEFTSCRX		DB	?
LEFTSCRY		DB	?
RIGHTSCRX		DB	?
RIGHTSCRY		DB	?
        .CODE
;---------------------------  		
MAIN    PROC    FAR
        MOV AX, @DATA	;SETUP DATA ADDRESS
        MOV DS, AX		;MOV DATA ADDRESS TO DS
		
		MOV AH, 0		;PREPARE GFX MODE
		MOV AL, 13H
		INT	10H			;ENTER GFX MODE
		
		

MAIN    ENDP
;---------------------------
;This PROC draws the screens of the two players given the parameters in data segment
;@param 	none
;@return 	none
DRAWSCR	PROC	NEAR
	

;---------------------------    
END     MAIN








