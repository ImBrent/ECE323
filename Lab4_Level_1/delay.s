 AREA program, CODE, READONLY
 EXPORT delay
	;Takes value from R1 to perform delay
	
delay
	PUSH {R0-R7, LR}
	
delay1
	SUBS	R1, R1, #1
	BNE		delay1
	
	POP {R0-R7, PC}
	
	END