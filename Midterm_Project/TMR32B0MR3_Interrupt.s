;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TMR32B0MR_Interrupt.s
; Preconditions: 
;	* PIO1_7 configured as output GPIO
; Postconditions:
;	* Set data of PIO1_7 to be high
;	* Increment counter(s) used by capture pin
;		- These timers let the capture pin know how many overflows occured between capture eents
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 AREA PROGRAM, CODE, READONLY
 EXPORT TMR32B0MR3_Interrupt
 INCLUDE GlobalVariables.inc
 INCLUDE LPC11xx.inc
 
TMR32B0MR3_Interrupt
	PUSH{R3-R5,LR}
	;Set output of PIO1_7 to be high
	LDR R3, =GPIO1DATA
	LDR R5, [R3]
	MOVS R4, #0x80
	ORRS R5, R5, R4	;Set bit 7
	STR R5, [R3]	
	
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
	
	POP{R3-R5,PC}
	ALIGN
	END