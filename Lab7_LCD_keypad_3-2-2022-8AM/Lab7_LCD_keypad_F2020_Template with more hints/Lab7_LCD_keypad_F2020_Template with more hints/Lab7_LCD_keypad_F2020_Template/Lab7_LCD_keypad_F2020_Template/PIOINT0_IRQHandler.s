 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT PIOINT0_IRQHandler
 IMPORT LCD_command
 IMPORT LCD_init 
 IMPORT Keypad_init
 IMPORT BusyWait
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 	 	 	
KEY_NUM		RN		7
NEW_KEY		RN		6

PIOINT0_IRQHandler
	PUSH {R0-R5,LR}
	
	LDR R4, =(0xE000E180)		;disable the interrupt, ICER, page 507, 508
	MOVS R5, #0x1				; Interrupt Clear-enable Register, page 508  (ICER)
	MOVS R5, R5, LSL #31		; Interrupt source: Page 70. 
	STR R5, [R4]
	
	LDR R4, =(0xE000E280)		;clear the pending interrupt, Interrupt Clear-pending Register (ICPR)
	MOVS R5, #0x1
	MOVS R5, R5, LSL #31
	STR R5, [R4]
	
	MOVS KEY_NUM, #0
	
	LDR R3, =0x25000
	BL BusyWait
		
check_row1
		LDR	R4,=(GPIO1DATA) ; just let first row = 0
		MOVS R5, #0x07
		STR R5, [R4]
		
		LDR R4, =(GPIO0DATA)
		LDR R5, [R4]
		MOVS R6, #0x01E
		ANDS R5, R5, R6
		MOVS R5, R5, LSR #1  ; find inoup coulmn and shift down one bit
		
		CMP R5, #0x07  ; if the first coulmn is 0, "1" on th ekeypad is pressed. 
		BEQ _col1
		
		CMP R5, #0x0B	;Check if second column
		BEQ _col2
		
		CMP R5, #0x0D	;Check if third column
		BEQ _col3
		
		;Otherwise, fourth column
		CMP R5, #0x0E
		BEQ _col4
		
		ADDS KEY_NUM, #4	
_row2
		LDR	R4,=(GPIO1DATA) ; just let second row = 0
		MOVS R5, #0x0B
		STR R5, [R4]	
		
		LDR R4, =(GPIO0DATA)
		LDR R5, [R4]
		MOVS R6, #0x01E
		ANDS R5, R5, R6
		MOVS R5, R5, LSR #1  ; find inoup coulmn and shift down one bit		
		
		CMP R5, #0x07  ; if the first coulmn is 0, "1" on th ekeypad is pressed. 
		BEQ _col1
		
		CMP R5, #0x0B	;Check if second column
		BEQ _col2
		
		CMP R5, #0x0D	;Check if third column
		BEQ _col3
		
		;Otherwise, fourth column
		CMP R5, #0x0E
		BEQ _col4		

		ADDS KEY_NUM, #4
_row3	
		LDR	R4,=(GPIO1DATA) ; just let third row = 0
		MOVS R5, #0x0D
		STR R5, [R4]

		LDR R4, =(GPIO0DATA)
		LDR R5, [R4]
		MOVS R6, #0x01E
		ANDS R5, R5, R6
		MOVS R5, R5, LSR #1  ; find inoup coulmn and shift down one bit		
		
		CMP R5, #0x07  ; if the first coulmn is 0, "1" on th ekeypad is pressed. 
		BEQ _col1
		
		CMP R5, #0x0B	;Check if second column
		BEQ _col2
		
		CMP R5, #0x0D	;Check if third column
		BEQ _col3
		
		;Otherwise, fourth column
		CMP R5, #0x0E
		BEQ _col4
		ADDS KEY_NUM, #4
_row4
		LDR	R4,=(GPIO1DATA) ; just let fourth row = 0
		MOVS R5, #0x0E
		STR R5, [R4]	
		
		LDR R4, =(GPIO0DATA)
		LDR R5, [R4]
		MOVS R6, #0x01E
		ANDS R5, R5, R6
		MOVS R5, R5, LSR #1  ; find inoup coulmn and shift down one bit
		
		CMP R5, #0x07  ; if the first coulmn is 0, "1" on th ekeypad is pressed. 
		BEQ _col1
		
		CMP R5, #0x0B	;Check if second column
		BEQ _col2
		
		CMP R5, #0x0D	;Check if third column
		BEQ _col3
		
		;Check fourth column
		CMP R5, #0x0E
		BEQ _col4

		;Otherwise, something strange happened (ie button released too fast).
		;Print nothing.
		MOVS R6, #0
		BL noChar
_col1
		B		exit

_col2
		ADDS KEY_NUM, #1
		B		exit
_col3
		ADDS KEY_NUM, #2
		B		exit
_col4
		ADDS KEY_NUM, #3
		B		exit
exit

;Wait for user to release key before leaving interrupt
	LDR R0, =(GPIO0DATA) ;Get address of columns
	;Ground all rows
	LDR	R4,=(GPIO1DATA)	; continue to clear rows
	MOVS R5, #0x00
	STR R5, [R4]

	MOVS R2, #0x1E
waitForRelease
	;Mask all bits except 1,2,3,4. Leave loop once all bits are 1.
	LDR R1, [R0]
	ANDS R1, R1, R2
	CMP R1, #0x1E
	BNE waitForRelease

	MOVS R6, #1
	
noChar	
	
	POP{R0-R5,PC}
	BX LR
	ALIGN
	END