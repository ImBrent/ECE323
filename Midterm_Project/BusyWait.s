 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT BusyWait
	 
	 
BusyWait
	PUSH{R3,LR}

delay
	SUBS	R3, R3, #1
	BNE		delay

	POP {R3,PC}
	END