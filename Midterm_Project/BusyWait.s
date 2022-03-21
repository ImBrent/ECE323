;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BusyWait.s
;Delays for an amount of time specified by the user
;Preconditions:
;	* R3 contains 1/4 of the number of clock cycles that should be delayed for
;Postconditions:
;	* Execution is delayed by approximately (4 * R3) + 10 clock cycles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT BusyWait
	 
BusyWait
	PUSH{R3,LR}	;3 clock cycles

delay
	SUBS	R3, R3, #1	;Takes 1 clock cycle
	BNE		delay		;Takes 3 clock cycle if conditional jump is taken
						;1 clock cycle if not taken
	POP {R3,PC}	;6 clock cycles
	END