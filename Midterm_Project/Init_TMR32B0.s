;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Init_TMR32B1
;Performs the following initializations to configure TMR32B0:
;	* Configures ISER to enable TMR32B0 interrupt
;	* Configures PIO1_7 as an output GPIO with data set to high. This GPIO will 
;		be the output for the channel
;	* Configures MCR to interrupt on MR0 and interrupt/reset on MR3
;	* Initializes MRs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT Init_TMR32B0
 INCLUDE LPC11xx.inc
	 
Init_TMR32B0
	PUSH{R0-R2, LR}

	;Enable interrupt for TMR32B0 in ISER of NVIC (Set bit 18)
	LDR R0, =ISER
	LDR R1, [R0]
	MOVS R2, #1
	LSLS R2, R2, #18
	ORRS R1, R1, R2
	STR R1, [R0]
	
	;IOCON_PIO1_7. Function: PIO1_7 (no bits set). Pull-up resistor (bit 4).
	LDR R0, =IOCON_PIO1_7
	LDR R1, [R0]
	MOVS R2, #0x10
	ORRS R1, R1, R2 ;Set bit 4
	STR R1, [R0] ;Store updated register
	
	;Initialize direction of pin to be output
	LDR R0, =GPIO1DIR
	LDR R1, [R0]
	MOVS R2, #0x80
	ORRS R1, R1, R2
	STR R1, [R0]
	
	;Initialize GPIO1_7 to 1 to set LED to be on
	LDR R0, =GPIO1DATA
	LDR R1, [R0]
	MOVS R2, #0x80	;Set bit 7
	ORRS R1, R1, R2
	STR R1, [R0]	
	
	;MCR.
	;	* MR0: Interrupt (bit 0). Leave as 0 here to leave LED on until user defines MR0/3
	;	* MR3: Interrupt and reset clock (bit 9,10)
	LDR R0, =(TMR32B0MCR)
	LDR R1, [R0]
	LDR R2, =0x600	;Set bits
	ORRS R1, R1, R2
	STR R1, [R0]
		
	;Do not start timer
	POP{R0-R2, PC}
	ALIGN
	END