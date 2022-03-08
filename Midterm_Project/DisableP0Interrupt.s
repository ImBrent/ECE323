 AREA program, CODE, READONLY
 EXPORT DisableP0Interrupt
 INCLUDE LPC11xx.inc

	  
DisableP0Interrupt
	PUSH{R4-R5,LR}
		LDR R4, =(0xE000E180)		;disable the interrupt for Port0
		MOVS R5, #0x1
		MOVS R5, R5, LSL #31
		STR R5, [R4]
		
		LDR R4, =(0xE000E280)		;clear the pending interrupt, Interrupt Clear-pending Register (ICPR)
		MOVS R5, #0x1
		MOVS R5, R5, LSL #31
		STR R5, [R4]
	POP{R4-R5,PC}
	END