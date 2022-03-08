;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Level3_print_string
;Receives the address of first byte of a string,
;the address of the null byte of a string,
;and the address of the first byte to print
;Prints 32 bytes of the string, starting at the first byte to print,
;And wrapping around as needed
;Preconditions:
;	* R7 has address of first byte of string
;	* R6 has address of first byte to print from
;	* R5 has address of null byte of string
;Posconditions:
;	* LCD displays the characters as described above
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT Level3_print_string
 IMPORT LCD_command


FIRST_ADDRESS	RN	7	;Address of first byte in string
NULL_ADDRESS	RN	5	;Address of null byte in string
CURR_ADDRESS	RN	6	;Address of byte to print in string
COUNTER			RN	4	;Tracks how many characters have been displayed
CURRENT_CHAR	RN	0	;Will store current character

WINDOW_SIZE	EQU		0x20	;Can display 32 chars
LINE_SIZE	EQU		WINDOW_SIZE/2
	
Level3_print_string
	PUSH{R0-R7, LR}

	;Reset cursor to start
	MOVS R0, #0x02	;Code to move cursor home
	MOVS R1, #0		;indicate command
	BL LCD_command

	;Initialize counter
	MOVS COUNTER, #0

display
	;Check if current byte is null
	CMP CURR_ADDRESS, NULL_ADDRESS
	BNE not_null
	MOVS CURR_ADDRESS, FIRST_ADDRESS ;Reset cursor to start if yes
not_null
	LDRB CURRENT_CHAR, [CURR_ADDRESS] ;Load current character
	MOVS R1, #1						;indicate data
	BL LCD_command						;Print current character
	
	ADDS COUNTER, COUNTER, #1		;Increment counter
	ADDS CURR_ADDRESS, #1			;Increment pointer
	
	;If counter is 16, move to next line
	CMP COUNTER, #LINE_SIZE
	BNE check2
	MOVS R0, #0xC0	;Code to move cursor to next line
	MOVS R1, #0
	BL LCD_command
	BL display
check2
	;If counter is 32, done printing
	CMP COUNTER, #WINDOW_SIZE
	BNE display
	
done

	POP{R0-R7, PC}
	END
	