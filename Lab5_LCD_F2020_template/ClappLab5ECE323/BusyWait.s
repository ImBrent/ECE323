 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT BusyWait
	 
	 
BusyWait
	PUSH{R0-R7,LR}

delay
	SUBS	R3, R3, #1
	BNE		delay

	POP {R0-R7,PC}
	END