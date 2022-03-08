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