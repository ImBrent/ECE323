;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;determine_prescale.s
;This subroutine determines the minmum prescale that a 16-bit timer can use 
;to perform PWM with the input period passed in R0.
;Preconditions:
;	* R0 contains the period which the prescale is to be determined for
;Postconditions:
;	* R3 contains minimum prescale for input period.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT determine_prescale
 IMPORT Divide
 
determine_prescale
	PUSH{R2,LR}
	
	;Find minimum prescale for T:
	LDR R3, =65535
	MOVS R2, R0
	BL Divide	;Quotient now in R4
	MOVS R3, R4	;Minimum prescale for T0 is in R3
	
	POP{R2,PC}
	ALIGN
	END