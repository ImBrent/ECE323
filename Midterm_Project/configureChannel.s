;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;configureChannel.s
; Given a channel number 1-4, T0, and T1, this subroutine will configure the
;	MRs and prescales of the timer used by the chosen channel such that
;	the channel blinks with T1 as its high period and T0 as its low period
; Preconditions:
;	* R0: Contains T0
;	* R1: Contains T1
;	* R2: Contains channel number
; Postconditions:
;	* Timer corresponding to channel has its MRs and prescales initialized as
;		needed to blink with chosen periods. Timer is also reset and started.
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
		BEQ channel1
	CMP R2, #2
		BEQ channel2
	CMP R2, #3
		BEQ channel3
	CMP R2, #4
		BEQ channel4
	
channel2
	;Update MRs
	
	;MR1 contains positive period. T1
	LDR R3, =TMR32B0MR0
	STR R1, [R3] ;T1
	
	;MR3 contains total period. T0.
	LDR R3, =TMR32B0MR3
	STR R0, [R3]

	;Initialize GPIO1_7 to 1 to set LED to be on
	LDR R0, =GPIO1DATA
	LDR R1, [R0]
	MOVS R2, #0x80	;Set bit 7
	ORRS R1, R1, R2
	STR R1, [R0]		

	;Set MCR to allow LED to turn off
	LDR R3, =TMR32B0MCR
	LDR R1, [R3]
	MOVS R2, #1
	ORRS R1, R1, R2
	STR R1, [R3]

	LDR R3, =TMR32B0TCR
	;Load 0x2 to reset timer
	MOVS R2, #0x2
	STR R2, [R3]
	;Load 0x1 to start timer
	MOVS R2, #0x1
	STR R2, [R3]

	B exit
channel4
	;MR3 contains total period. T0.
	LDR R3, =TMR32B1MR3
	STR R0, [R3]
	
	;MR0 contains positive period. T1.
	LDR R3, =TMR32B1MR0
	STR R1, [R3] ;Store T1

	;Set LED to be on
	LDR R0, =GPIO1DATA
	LDR R1, [R0]
	MOVS R2, #0x10	;Set bit 4
	ORRS R1, R1, R2
	STR R1, [R0]

	;Set MCR to allow LED to turn off
	LDR R3, =TMR32B1MCR
	LDR R1, [R3]
	MOVS R2, #1
	ORRS R1, R1, R2
	STR R1, [R3]	

	LDR R3, =TMR32B1TCR
	;Load 0x2 to reset timer
	MOVS R2, #0x2
	STR R2, [R3]
	;Load 0x1 to start timer
	MOVS R2, #0x1
	STR R2, [R3]
	B exit
channel1
	BL determine_prescale	;prescale now in R3.
	;Divide T0 and T1 by (prescale + 1). Extra 1 accounts for prescaling counting R3 + 1 numbers before incrementing TC
	PUSH{R3}	;Save copy of R3
	
	ADDS R3, R3, #1

	MOVS R2, R0	;Dividend goes into R2
	BL Divide	;Quotient in R4
	
	MOVS R0, R4	;Place quotient value back into R0
	
	MOVS R2, R1 ;Divide T1 by Prescale
	BL Divide	;Quotient in R4
	MOVS R1, R4 ;Place quotient back into R1

	POP{R3}

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
channel3
	BL determine_prescale	;prescale now in R3.
;Divide T0 and T1 by (prescale + 1). Extra 1 accounts for prescaling counting R3 + 1 numbers before incrementing TC

	PUSH{R3}	;Save copy of R3
	
	ADDS R3, R3, #1

	MOVS R2, R0	;Dividend goes into R2
	BL Divide	;Quotient in R4
	
	MOVS R0, R4	;Place quotient value back into R0
	
	MOVS R2, R1 ;Divide T1 by Prescale
	BL Divide	;Quotient in R4
	MOVS R1, R4 ;Place quotient back into R1

	POP{R3}
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