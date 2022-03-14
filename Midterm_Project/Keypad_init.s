 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT Keypad_init
	 
IPR0	EQU		0xE000E400
IPR7	EQU		IPR0 + 7 * 4
	 
Keypad_init
	PUSH{R4-R6,LR}
	
	;Lower interrupt priority
	LDR R4, =IPR7
	LDR R5, [R4]
	MOVS R6, #1
	LSLS R6, R6, #30
	ORRS R5, R5, R6
	STR R5, [R4]
	
	LDR  R4, =(GPIO0DIR)	;set the direction of Port0 pins 1-4 as input
	LDR R5, =0x1E
	LDR R6, [R4]
	BICS R6, R6, R5	;Clear bits
	STR  R6, [R4]
	
	LDR  R4, =(IOCON_PIO0_5)
	LDR	 R5, =(0x100)
	STR  R5, [R4]
	
	LDR  R4, =(IOCON_PIO0_6)
	LDR	 R5, =(0x000)
	STR  R5, [R4]
	
	LDR  R4, =(IOCON_PIO0_7)
	LDR	 R5, =(0x000)
	STR  R5, [R4]
	
	LDR  R4, =(IOCON_R_PIO0_11)
	MOVS R5, #0x1
	STR  R5, [R4]
		
	LDR  R4, =(GPIO0DIR)		;set the direction of P0.5, 0.6, 0.7 and 0.11 as output
	LDR R6, [R4]
	LDR R5, =0x8E0
	ORRS R6, R6, R5
	STR  R6, [R4]
	
	LDR  R4, =(LPC_GPIO0IS)		;Interrupt sense register is configured as level sensitive
	MOVS R5,  #0x1E
	STR  R5, [R4]
	
	LDR  R4, =(LPC_GPIO0IE)		;Interrupt on P0.1, 0.2, 0.3 and 0.4 is unmasked
	MOVS R5,  #0x1E
	STR  R5, [R4]
	
	LDR  R4, =(LPC_GPIO0IEV)	;Interrupts on falling edge or low level of pin
	LDR R5,  =(0xFFFFFFE1)
	STR  R5, [R4]
	
	LDR  R4, =(GPIO0DATA)		;clear the row
	LDR R5, =(0x0)
	STR  R5, [R4]
	
	LDR R4, =(0xE000E100)		;enable the interrupt for Port0
	MOVS R5, #0x1
	MOVS R5, R5, LSL #31
	STR R5, [R4]
	
	POP {R4-R6,PC}
	ALIGN
	END