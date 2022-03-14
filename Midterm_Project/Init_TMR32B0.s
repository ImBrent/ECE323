;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Init_TMR32B0
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT Init_TMR32B0
 INCLUDE LPC11xx.inc
	 
Init_TMR32B0
	PUSH{R0-R2, LR}

	;Configure CT32B0 for PWM
	;MAT1: Period T0 - T1. PWM.
	;MAT3: Period T0. Reset on match.
	
	;IOCON_PIO1_7. Function: CT32B0_MAT1 (bit 1). Pull-up resistor (bit 4).
	LDR R0, =IOCON_PIO1_7
	LDR R1, [R0]
	MOVS R2, #0x12
	ORRS R1, R1, R2 ;Set bits 1 and 4
	STR R1, [R0] ;Store updated register
	
	;MCR. Reset on MR3 (set bit 10).
	LDR R0, =(TMR32B0MCR)
	LDR R1, [R0]
	MOVS R2, #0x1
	LSLS R2, R2, #10	;Set bit 10
	ORRS R1, R1, R2
	STR R1, [R0]
	
	;MR. Initially, LED should just be on. Set MR1 to be 0 and MR3 to be 12000000
	LDR R0, =TMR32B0MR1
	LDR R1, =0		;Set MR1 to be 0
	STR R1, [R0]
	
	LDR R0, =TMR32B0MR3
	LDR R1, =48000000
	STR R1, [R0]
	
	;PWM. Set MAT1 as PWM (bit 1 set)
	LDR R0, =TMR32B0PWMC
	LDR R1, [R0]
	MOVS R2, #0x2
	ORRS R1, R1, R2
	STR R1, [R0]
	
	LDR R0, =TMR32B0TCR
	;Load 0x1 to start timer
	MOVS R2, #0x1
	STR R2, [R0]	

	POP{R0-R2, PC}
	ALIGN
	END