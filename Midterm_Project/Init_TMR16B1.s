;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Init_TMR16B1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 INCLUDE LPC11xx.inc
 EXPORT Init_TMR16B1
	 
Init_TMR16B1
	PUSH{R0-R6,LR}	

	;PIO1_9. Function: CT16B1_MAT0 (bit 0 set)
	LDR R0, =IOCON_PIO1_9
	MOVS R1, #0x1
	STR R1, [R0]

	;MCR: Set bit 4 (reset on MR1)
	LDR R0, =TMR16B1MCR
	LDR R1, [R0]
	MOVS R2, #0x10
	ORRS R1, R1, R2
	STR R1, [R0]
	
	;MR. Initially, LED should just be on. Set MR0 to be 0 and MR1 to be 65535. Don't start timer.
	LDR R0, =TMR16B1MR0
	LDR R1, =0		;Set MR1 to be 0
	STR R1, [R0]
	
	LDR R0, =TMR16B1MR1
	LDR R1, =0
	STR R1, [R0]
	
	;PWM. Set MAT0 as PWM (bit 0 set)
	LDR R0, =TMR16B1PWMC
	LDR R1, [R0]
	MOVS R2, #0x1
	ORRS R1, R1, R2
	STR R1, [R0]

	POP{R0-R6,PC}
	ALIGN
	END