;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;capture_init
;Performs necessary initializations to use CT32B0_CAP:
;	* IOCON_PIO1_5 is set for CT32B0_CAP0 function and Pull-up resistor mode
;	* ISER of NVIC configured to allow CT32B0 to trigger interrupt
;	* Configure CCR to capture on rising edge and interrupt on event
;	* Configure MCR to interrupt on MR3 (used for counters that track overflow)
;	* Initialize counters to be 0
;	* Start timer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT capture_init
 INCLUDE LPC11xx.inc
 INCLUDE GlobalVariables.inc
	 
capture_init
	PUSH{R0-R2,LR}

	;Configure pin as capture pin
	;Function: CT32B0_CAP0	- Bit 1 set
	;Mode	 : Pull-up resistor - Bit 4 set
	LDR R0, =IOCON_PIO1_5
	MOVS R1, #0x12
	STR R1, [R0]

	;Configure NVIC
	;Set bit 18 of ISER to allow CT32B0 to trigger interrupt
	LDR R0, =ISER
	LDR R1, [R0]
	MOVS R2, #1
	LSLS R2, R2, #18
	ORRS R1, R1, R2
	STR R1, [R0]

	;Configure CCR:
	;	CAP0RE (bit 0 set) - capture on rising edge
	;	CAP0I  (bit 2 set) - interrupt on event	
	LDR R0, =TMR32B0CCR
	MOVS R1, #0x5	;Bit 0,2 set
	STR R1, [R0]

	;Configure MCR to interrupt on MR3
	LDR R0, =TMR32B0MCR
	LDR R1, [R0]
	LDR R2, =0x200	;Set bit 9
	ORRS R1, R1, R2
	STR R1, [R0]

	;Set MR3 to a large value
	LDR R0, =TMR32B0MR3
	LDR R1, =48000000
	STR R1, [R0]

	;Initialize counters to 0
	LDR R0, =0xFFFF0
	ANDS R0, R0, R7
	LSRS R0, R0, #4
	;Memory base now in R0
	
	;Initialize counter1 to 0
	MOVS R1, #_counter1
	SUBS R1, R0, R1
	MOVS R2, #0
	LDR R2, [R1]
	
	;Intialize counter0 to be 0
	MOVS R1, #_counter0
	SUBS R1, R0, R1
	LDR R2, [R1]

	;Start timer
	LDR R0, =TMR32B0TCR
	MOVS R1, #1
	STR R1, [R0]
	
	POP{R0-R2,PC}
	ALIGN
	END
