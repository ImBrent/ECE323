;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;get_key_num.s
;Gets key number of a key that is pressed on keypad
;Returned:
;	* R7: Bits 0-3: Detected key number
;		  Bit 31: Set to 1 if new key detected. 0 otherwise.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 AREA program, CODE, READONLY
 EXPORT get_key_num
 INCLUDE LPC11xx.inc
	 
ROW_NUM		RN	3
KEY_NUM		RN	6
ROWS		RN	0
COL_NUM		RN	4
COLS		RN	0
	 
get_key_num
	PUSH{R0-R6, LR}
	;Make assumption that new key is found. Will be cleared if not
	MOVS R6, #1
	LSLS R6, R6, #31
	ORRS R7, R7, R6	;New key flag is set
	
	MOVS KEY_NUM, #0
	MOVS ROW_NUM, #3		
check_row
		;Get necessary code to ground currently examined row
		LDR ROWS, =0x8E0
		LDR R4, =row_pins
		LDRB R2, [R4, ROW_NUM] ;Get pin number to ground for this iteration
		MOVS R1, #1
		MOVS R1, R1, LSL R2
		EORS ROWS, ROWS, R1
		
		;Ground the row
		LDR	R4,=(GPIO0DATA)
		MOVS R5, ROWS
		STR R5, [R4]
		
		;Get columns resulting from grounded row. Store in R5.
		LDR R4, =(GPIO0DATA)
		LDR R5, [R4]
		MOVS R2, #0x01E
		ANDS R5, R5, R2
		MOVS R5, R5, LSR #1
		
		MOVS COL_NUM, #3
;Check each column in current row
check_col
		;Set examined column to 0
		MOVS COLS, #0xF
		MOVS R1, #1
		MOVS R1, R1, LSL COL_NUM
		EORS COLS, COLS, R1
		
		;Compare against value of input columns
		;If match, then done searching. KEY_NUM contains number of found key
		;Otherwise, increment KEY_NUM and move to next key
		CMP R5, COLS
		BEQ exit
		
		ADDS KEY_NUM, #1
		
		;Move to next column. If last column has been examined, then move to next row
		SUBS COL_NUM, COL_NUM, #1
		BGE check_col
		
		;Move to next row. If last row has been examined, then no key has been found
		SUBS ROW_NUM, ROW_NUM, #1
		BGE check_row

		;Otherwise, something strange happened (ie button released too fast).
		;No new key found. Clear new key flag
		MOVS R6, #1
		LSLS R6, R6, #31
		BICS R7, R7, R6
exit
	;Put key num into lower 4 bits of R7
	;Clear existing bits, then apply new ones
	MOVS R5, #0xF
	BICS R7, R7, R5	;Clear existing bits
	ORRS R7, R7, KEY_NUM ;Apply new bits
	
	POP{R0-R6,PC}
row_pins	DCB		11,7,6,5	;Pins numbers corresponding to row 4,3,2,1
	ALIGN
	END