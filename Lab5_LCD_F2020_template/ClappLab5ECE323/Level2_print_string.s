;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Level2_print_string.s
;Prints the null-terminated string pointed to be R2.
;Returns index of null character in R2.
;Preconditions:
;		Head of string pointed to by R2
;Postconditions:
;		Null byte of string pointed to by R2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT Level2_print_string
 IMPORT LCD_command
	 
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
	
current_character	RN	0

Level2_print_string
	PUSH{R0-R1,R3-R7,LR}

loop
	
	LDRB	current_character, [R2] 
	CMP 	current_character, #0			; 	comparing the current character with null character
	BEQ		done		; 	if true we are done storing the chracters from string array

	ADDS 	R2, R2, #1
	MOVS R1, #1	;data operation
	BL		LCD_command
	B		loop
	
done


	POP {R0-R1,R3-R7,PC}

	END