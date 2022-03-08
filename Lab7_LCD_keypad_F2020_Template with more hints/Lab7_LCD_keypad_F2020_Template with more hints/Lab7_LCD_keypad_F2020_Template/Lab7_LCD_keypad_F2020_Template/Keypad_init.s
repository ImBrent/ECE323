 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT Keypad_init
	 
	 
Keypad_init
	PUSH{R0-R7,LR}
	
	LDR  R4, =(GPIO0DIR)	;set the direction of Port0 as input
	LDR R5, =0x00
	STR  R5, [R4]
	
	LDR  R4, =(IOCON_R_PIO1_0)
	LDR	 R5, =(0x081)
	STR  R5, [R4]
	
	LDR  R4, =(IOCON_R_PIO1_1)
	LDR	 R5, =(0x081)
	STR  R5, [R4]
	
	LDR  R4, =(IOCON_R_PIO1_2)
	LDR	 R5, =(0x081)
	STR  R5, [R4]
	
	
	LDR  R4, =(IOCON_PIO1_4)
	MOVS R5, #0x80
	STR  R5, [R4]
		
	LDR  R4, =(GPIO1DIR)		;set the direction of P1.0, 1.1, 1.2 and 1.4 as output
	LDR R6, [R4]
	LDR R5, =0x17
	ORRS R6, R6, R5
	STR  R6, [R4]
	
	LDR  R4, =(GPIO1DATA)		;set the data of Port1 to 0
	LDR R5, =(0x00)
	STR  R5, [R4]
	
	LDR  R4, =(LPC_GPIO0IS)		;Interrupt sense register is configured as level sensitive
	MOVS R5,  #0x1E
	STR  R5, [R4]
	
	LDR  R4, =(LPC_GPIO0IE)		;Interrupt on P0.1, 0.2, 0.3 and 0.4 is unmasked
	MOVS R5,  #0x1E
	STR  R5, [R4]
	
	LDR  R4, =(LPC_GPIO0IEV)	;Interrupts on falling edge or low level of pin
	LDR R5,  =(0xFFFFFFE1)
	STR  R5, [R4]
	
	LDR  R4, =(GPIO1DATA)		;clear the row
	LDR R5, =(0x0)
	STR  R5, [R4]
	
	LDR R4, =(0xE000E100)		;enable the interrupt for Port0
	MOVS R5, #0x1
	MOVS R5, R5, LSL #31
	STR R5, [R4]
	
	POP {R0-R7,PC}
	ALIGN
	END