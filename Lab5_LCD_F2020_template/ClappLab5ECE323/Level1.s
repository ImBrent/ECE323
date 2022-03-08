;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Level1.s
;This subroutine takes 2 strings as input and displays on LCD
;Preconditions:
;				R3 - Pointer to first null-terminated string
;				R4 - Pointer to second null-terminated string
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT Level1
 IMPORT LCD_command
 IMPORT print_string
	 
CLEAR       EQU		0X01
HOME        EQU		0X02
LCD_ON      EQU		0X0C
BLINK       EQU		0X0F
CURSOR_ON   EQU		0X0E
LEFT        EQU		0X10
RIGHT       EQU		0X14
NEXT_LINE   EQU		0xC0
FOURBIT     EQU		0x28   ;0b00101000 = 0x28
LCD_OFF     EQU		0x0A

Level1
	PUSH {R0-R7, LR}
	BL print_string			;Print first string
	
	;;;; Move cursor to second line
	
	MOVS R0, #NEXT_LINE
	MOVS R1, #0
	BL LCD_command
	
	
	MOVS R3, R4				;Prepare pre-conditions for print_string
	BL print_string			;Print second string
	POP{R0-R7, PC}
	END