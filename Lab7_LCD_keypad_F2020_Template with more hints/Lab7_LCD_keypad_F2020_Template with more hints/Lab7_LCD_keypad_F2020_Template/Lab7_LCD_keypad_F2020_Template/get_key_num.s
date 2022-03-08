;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;get_key_num.s
;Gets key number of a key that is pressed on keypad
;Returned:
;	* R7: Key_Num. The number of the key that is pressed
;	* R6: New_Key. Flag indicating whether or not a new key was found
;				If 1, then new key is found. 0 indicates key could not be found
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 AREA program, CODE, READONLY
 EXPORT get_key_num
 INCLUDE LPC11xx.inc
	 
ROW_NUM		RN	3
KEY_NUM		RN	7
NEW_KEY		RN	6
ROWS		RN	0
COL_NUM		RN	4
COLS		RN	0
	 
get_key_num
	PUSH{R0-R5, LR}
	MOVS ROW_NUM, #3	
	MOVS KEY_NUM, #0	
	MOVS NEW_KEY, #1	;Make assumption that new key is found. Will be cleared if not
check_row
		;Get necessary code to ground currently examined row
		MOVS ROWS, #0xF
		MOVS R1, #1
		MOVS R1, R1, LSL ROW_NUM
		EORS ROWS, ROWS, R1
		
		;Ground the row
		LDR	R4,=(GPIO1DATA)
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
		;No new key found. Send 0 to indicate as such.
		MOVS NEW_KEY, #0
exit
	POP{R0-R5,PC}
	END