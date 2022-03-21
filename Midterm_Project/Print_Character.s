;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Print_Character.s
; Given a character as input, this subr will print the character
; To LCD
; Preconditions:
;	* Character stored in R5
;	* Pins configured for LCD use and LCD booted up
; Postconditions:
;	* Character displayed to LCD at current position of cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT Print_Character
 IMPORT LCD_command
 
Print_Character
	PUSH {R0, R1, LR}
	
	MOVS R0, R5
	MOVS R1, #1
	BL LCD_command

	POP {R0, R1, PC}
	END