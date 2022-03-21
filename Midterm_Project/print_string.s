;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;print_string.s
;Given that the pins are configured for writing and a pointer to the first byte of a 
;null-terminated string is in R3, this subroutine will display that null-teriminated
;string to the LCD at the current position of the cursor.
;If the string is larger than 16 characters, the LCD will move to the next line.
;It is the caller's responsibility to ensure that the cursor is appropriately 
;positioned.
;Preconditions:
;	* Necessary pins are configured for sending data to LCD, and LCD is booted up
;	* R3 contains the first byte of the null-terminated string to send to the LCD
;Postconditions:
;	* The string passed by reference through R3 is printed to the LCD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 INCLUDE Constants.inc
 EXPORT print_string
 IMPORT LCD_command
	
current_character	RN	2
counter		RN	4

print_string
	PUSH{R0-R4,LR}

	MOVS	counter, #0	;initializing counter to be 0
loop
	LDRB	current_character, [R3] 
	ADDS 	R3, R3, #1
	CMP 	current_character, #0		; 	comparing the current character with null character
	BEQ		done		; 	if true we are done storing the chracters from string array
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;sending data to LCD to print;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	CMP		counter, #16
	BLT		same_line
next_line
	CMP		counter, #16
	BGT		same_line
	
	MOVS	R0, #NEXT_LINE
	MOVS	R1, #0
	BL		LCD_command
same_line
	ADDS	counter, #1
	MOVS	R0, current_character
	MOVS	R1, #1
	BL		LCD_command
	B		loop	
done

	POP {R0-R4,PC}
	END