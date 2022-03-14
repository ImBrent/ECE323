;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT determine_prescale
 IMPORT Divide
 
 
 
determine_prescale
	PUSH{R0-R2,R4-R6,LR}
	
	;Find minimum prescale for T0:
	LDR R3, =65535
	MOVS R2, R0
	BL Divide	;Quotient now in R4
	MOVS R5, R4	;Minimum prescale for T0 is in R5
	
	;Find minimum prescale for T1:
	MOVS R2, R1
	BL Divide
	MOVS R6, R4 ;Minimum prescale for T1 is in R6
	
	;Find the larger of the two, and return in R3.
	CMP R5,R6
	BGT assignR5
	MOVS R3,R6
	B exit
assignR5
	MOVS R3, R5
exit
	ADDS R3, R3, #1	;Add 1 to avoid issues following from integer division
	POP{R0-R2,R4-R6,PC}
	ALIGN
	END