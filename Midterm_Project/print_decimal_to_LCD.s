;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;print_decimal_to_LCD.s
;Given a decimal value in R3, this subroutine will display that value to the LCD
;at the current position of the cursor
;Preconditions:
;	* R3: Decimal value to be displayed
;	* Pins configured for writing to LCD
;Postconditions:
;	* Value passed in R3 is display to LCD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT print_decimal_to_LCD
 INCLUDE Constants.inc
 IMPORT LCD_command
 IMPORT Divide
	 
Divisor				RN		3
Dividend			RN		2
Quotient			RN		4
Zero_flag			RN		5
Divisor_Init		EQU		1000000000 ;1 billion initially. Max register can hold is 4 billion.
	 
print_decimal_to_LCD
	PUSH{R0-R6,LR}
	
	MOVS Dividend, R3	;Input goes into dividend
	LDR Divisor, =Divisor_Init ;First value that will divide by
	MOVS R1, #1		;R1 will always be 1. Always giving data to LCD_command
	MOVS Zero_flag, #0	;Set this flag to one once a zero is found
loop
	CMP Divisor, #0
	BEQ	done			;Quit when divisor is zero
	
	BL Divide	;Find how many times Divisor goes into dividend
	
	;Set zero flag if non-zero quotient
	CMP Quotient, #0 
	BEQ zero
	MOVS Zero_flag, #1;Non-zero value found. Set zero flag.
zero
	;If zero flag not set, then don't display
	CMP Zero_flag, #1
	BNE skip_display
	;Convert quotient to ASCII and display it
	MOVS R0, Quotient
	ADDS R0, #0x30	;Convert to ASCII
	BL LCD_command ;Display value.
skip_display	
	;Subtract divisor * quotient from dividend
	MULS Quotient, Divisor, Quotient
	SUBS Dividend, Dividend, Quotient
	
	;Decrease Divisor by a factor of 10
	PUSH{R2}
	MOVS R2, Divisor	;Divisor becomes dividend for subroutine
	MOVS R3, #10		;Dividing by factor of 10
	BL Divide			;New divisor is currently stored in R4
	POP{R2}
	MOVS Divisor, R4
	
	B loop
done
	POP{R0-R6,PC}
	ALIGN
	END