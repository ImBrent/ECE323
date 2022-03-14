 AREA PROGRAM, CODE, READONLY
 EXPORT TMR32B0MR3_Interrupt
 INCLUDE GlobalVariables.inc
 INCLUDE LPC11xx.inc
 
TMR32B0MR3_Interrupt
	PUSH{R3,R5,LR}
	;If CCR configured for neg edge, then increment both counters.
	;Otherwise, incremenet only counter 0
	;Read CCR to determine whether pos or negative edge event
	LDR R5, =TMR32B0CCR
	LDR R3, [R5]
	;Check if bit 0 is set. If set, then positive edge
	MOVS R5, #0x1
	ANDS R5, R5, R3	
	
	CMP R5, #1
	BEQ inc_counter0
inc_counter1
	;Get counter 1 variable
	MOVS R3, R6
	SUBS R3, R3, #_counter1
	LDR R5, [R3]	;counter variable contents in R5
	ADDS R5, #1	;Increment counter
	STR R5, [R3];Store counter back to memory	
inc_counter0
	;Get counter 1 variable
	MOVS R3, R6
	SUBS R3, R3, #_counter0
	LDR R5, [R3]	;counter variable contents in R5
	ADDS R5, #1	;Increment counter
	STR R5, [R3];Store counter back to memory
	
	POP{R3,R5,PC}
	ALIGN
	END