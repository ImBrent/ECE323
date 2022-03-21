;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Divide.s
;Performs division on the given dividend and divisor inputs, and returns the quotient
;		as output.
;Preconditions:
;	*R2 contains dividend
;	*R3 contains divisor 
;		- Divisor cannot be 0. Subroutine will never return if 0.
;Postconditions:
;	*R4 contains quotient
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT Divide
	 
Dividend	RN	2
Divisor		RN	3
Quotient	RN	4
n			RN	5
temp		RN	6

	 
Divide
	PUSH {R2,R3,R5,R6,LR}
	MOVS Quotient, #0
	MOVS n, #31
	
DivisionOuterLoop
	CMP Dividend, Divisor	;Done if divisor less than dividend
	BLT DivisionDone
	MOVS temp, Divisor		;Save extra copy of divisor into a register
	MOVS n, #1						;Counter initially 1
DivisionInnerLoopBegin
	CMP temp, Dividend				;If temp > Dividend, jump out of inner loop
	BGT DivisionInnerLoopDone
		LSLS temp, temp, #1			;Find largest power of 2 that temp can be multiplied by and fit into n 
		LSLS n, n, #1 				;n represents that power
	B DivisionInnerLoopBegin
DivisionInnerLoopDone
	LSRS n, n, #1			;Shift back right one position so that temp <= Dividend
	LSRS temp, temp, #1		
	ADDS Quotient, Quotient, n		;Add n to quotient
	SUBS Dividend, Dividend, temp	;Subtract temp from dividend
	B DivisionOuterLoop
	
DivisionDone

	POP{R2,R3,R5,R6,PC}
	END