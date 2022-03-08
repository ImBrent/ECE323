;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;string_length.s
;This subroutine returns the length of a null-terminated string
;Preconditions:
;		* Address of first byte of string stored in R7
;Postconditions:
;		* Length of string stored in R6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 AREA PROGRAM, CODE, READONLY
 INCLUDE LPC11xx.inc
 EXPORT string_length
	 
STRING_CURSOR	RN	7
STRING_LENGTH	RN	6
CURR_CHAR		RN 	5
	 
string_length
	PUSH{R0-R5, R7, LR}
	MOVS STRING_LENGTH, #0
	
countLoop
	;Get next character from string
	LDRB CURR_CHAR, [STRING_CURSOR]

	;Check if null
	CMP CURR_CHAR, #0
	BEQ done			;If null, then end of string reached
	
	;Otherwise, increment string_length, move to next char and repeat
	ADDS STRING_LENGTH, STRING_LENGTH, #1
	ADDS STRING_CURSOR, STRING_CURSOR, #1
	BL countLoop

done
	POP{R0-R5, R7, PC}
	END