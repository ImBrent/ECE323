;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;configureChannel.s
;Given a channel number 1-4, T0, and T1, this subroutine will configure the
;	chosen channel to output with T1 as its high period and T0 as its low period
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT configureChannel
 INCLUDE LPC11xx.inc
 IMPORT Divide
 IMPORT Init_TMR16B1
 IMPORT determine_prescale
 
configureChannel
	PUSH{R0-R6,LR}
	
	CMP R2, #1
		BEQ channel3
	CMP R2, #2
		BEQ channel1
	CMP R2, #3
		BEQ channel4
	CMP R2, #4
		BEQ channel2
	
channel1
	;Update MRs
	
	;MR1 contains negative period. T0 - T1.
	MOVS R4, R0	;T0 loaded into R4
	SUBS R4, R1	;T0 - T1 in R4
	LDR R3, =TMR32B0MR1
	STR R4, [R3] ;Store T0 - T1
	
	;MR3 contains total period. T0.
	LDR R3, =TMR32B0MR3
	STR R0, [R3]

	LDR R3, =TMR32B0TCR
	;Load 0x2 to reset timer
	MOVS R2, #0x2
	STR R2, [R3]
	;Load 0x1 to start timer
	MOVS R2, #0x1
	STR R2, [R3]

	B exit
channel2
	;MR1 contains total period. T0.
	LDR R3, =TMR32B1MR1
	STR R0, [R3]
	
	;MR3 contains negative period. T0 - T1.
	MOVS R4, R0	;T0 loaded into R4
	SUBS R4, R1	;T0 - T1 in R4
	LDR R3, =TMR32B1MR3
	STR R4, [R3] ;Store T0 - T1

	LDR R3, =TMR32B1TCR
	;Load 0x2 to reset timer
	MOVS R2, #0x2
	STR R2, [R3]
	;Load 0x1 to start timer
	MOVS R2, #0x1
	STR R2, [R3]
	B exit
channel3
	BL determine_prescale	;prescale now in R3.
	;Divide T0 and T1 by prescale.
	MOVS R2, R0	;Dividend goes into R2
	BL Divide	;Quotient in R4
	MOVS R0, R4	;Place divided value back into R0
	
	MOVS R2, R1 ;Divide T1 by Prescale
	BL Divide	;Quotient in R4
	MOVS R1, R4
	
	;Set new prescale
	LDR R5, =TMR16B1PR
	STR R3, [R5]
	
	;MR1 contains total period. T0. 
	LDR R3, =TMR16B1MR1
	STR R0, [R3]
	
	;MR0 contains negative period. T0 - T1.
	SUBS R0, R0, R1	;T0 - T1 in R4
	LDR R3, =TMR16B1MR0
	STR R0, [R3] ;Store T0 - T1

	LDR R3, =TMR16B1TCR
	;Load 0x2 to reset timer
	MOVS R2, #0x2
	STR R2, [R3]
	
	;Load 0x1 to start timer
	MOVS R2, #0x1
	STR R2, [R3]

	B exit
channel4
	BL determine_prescale	;prescale now in R3.
	;Divide T0 and T1 by prescale.
	MOVS R2, R0	;Dividend goes into R2
	BL Divide	;Quotient in R4
	MOVS R0, R4	;Place divided value back into R0
	
	MOVS R2, R1 ;Divide T1 by Prescale
	BL Divide	;Quotient in R4
	MOVS R1, R4
	
	;Set new prescale
	LDR R5, =TMR16B0PR
	STR R3, [R5]
	
	;MR0 contains total period. T0. 
	LDR R3, =TMR16B0MR0
	STR R0, [R3]
	
	;MR1 contains negative period. T0 - T1.
	SUBS R0, R0, R1	;T0 - T1 in R4
	LDR R3, =TMR16B0MR1
	STR R0, [R3] ;Store T0 - T1

	LDR R3, =TMR16B0TCR
	;Load 0x2 to reset timer
	MOVS R2, #0x2
	STR R2, [R3]
	
	;Load 0x1 to start timer
	MOVS R2, #0x1
	STR R2, [R3]
exit
	
	POP{R0-R6,PC}
	ALIGN
	END