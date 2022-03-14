;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Init_TMR32B1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 INCLUDE LPC11xx.inc
 EXPORT Init_TMR32B1
	 
Init_TMR32B1
	PUSH{R0-R2,LR}
	
	;Configure CT32B0 for PWM
	;MAT3: Period T0 - T1. PWM.
	;MAT1: Period T0. Reset on match.
	
	;IOCON_PIO1_4. Function: CT32B1_MAT3 (bit 1). Pull-up resistor (bit 4).
	LDR R0, =IOCON_PIO1_4
	LDR R1, [R0]
	MOVS R2, #0x12
	ORRS R1, R1, R2 ;Set bits 1 and 4
	STR R1, [R0] ;Store updated register
	
	;MCR. Reset on MR1 (set bit 4).
	LDR R0, =(TMR32B1MCR)
	LDR R1, [R0]
	MOVS R2, #0x1
	LSLS R2, R2, #4	;Set bit 4
	ORRS R1, R1, R2
	STR R1, [R0]
	
	;MR. Initially, LED should just be on. Set MR3 to be 0 and MR1 to be 12000000
	LDR R0, =TMR32B1MR1
	LDR R1, =0		;Set MR1 to be 48000000
	STR R1, [R0]
	
	LDR R0, =TMR32B1MR3
	LDR R1, =0
	STR R1, [R0]
	
	;PWM. Set MAT3 as PWM (bit 3 set)
	LDR R0, =TMR32B1PWMC
	LDR R1, [R0]
	MOVS R2, #0x8
	ORRS R1, R1, R2
	STR R1, [R0]
	
	POP{R0-R2,PC}
	ALIGN
	END