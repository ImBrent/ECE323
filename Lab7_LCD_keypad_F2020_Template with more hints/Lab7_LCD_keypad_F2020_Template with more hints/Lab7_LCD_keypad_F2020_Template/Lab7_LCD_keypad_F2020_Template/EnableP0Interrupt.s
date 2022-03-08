 AREA program, CODE, READONLY
 EXPORT EnableP0Interrupt
 INCLUDE LPC11xx.inc

	  
EnableP0Interrupt
	PUSH{R0-R7, LR}
		LDR R4, =(0xE000E280)		;clear the pending interrupt, Interrupt Clear-pending Register (ICPR)
		MOVS R5, #0x1
		MOVS R5, R5, LSL #31
		STR R5, [R4]
	
		LDR R4, =(0xE000E100)		;enable the interrupt for Port0
		MOVS R5, #0x1
		MOVS R5, R5, LSL #31
		STR R5, [R4]
	POP{R0-R7,PC}
	END