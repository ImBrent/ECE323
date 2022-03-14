 AREA program, CODE, READONLY
 EXPORT wait_for_key_release
 INCLUDE LPC11xx.inc
	 
wait_for_key_release
	PUSH {R0-R2,R4-R5, LR}
	
	LDR R0, =(GPIO0DATA) ;Get address of columns
	
	;Ground all rows
	LDR	R4,=(GPIO0DATA)
	MOVS R5, #0x00
	STR R5, [R4]

	MOVS R2, #0x1E
waitForRelease
	;Mask all bits except 1,2,3,4. Leave loop once all bits are 1.
	LDR R1, [R0]
	ANDS R1, R1, R2
	CMP R1, R2
	BNE waitForRelease


	POP{R0-R2,R4-R5,PC}
	ALIGN
	END