;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Print_Character.s
; Given a character as input, this subr will print the character
; To LCD
; Preconditions:
;	* Character stored in R5
;	* Pins configured to LCD use
; Postconditions:
;	* Character displayed to LCD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT Print_Character
 IMPORT LCD_command
 IMPORT Keypad_config_dir
 IMPORT LCD_config_dir
 INCLUDE Constants.inc
 
	 
Print_Character
	PUSH {R0, R1, LR}
	
	MOVS R0, R5
	MOVS R1, #1
	BL LCD_command

	POP {R0, R1, PC}
	END