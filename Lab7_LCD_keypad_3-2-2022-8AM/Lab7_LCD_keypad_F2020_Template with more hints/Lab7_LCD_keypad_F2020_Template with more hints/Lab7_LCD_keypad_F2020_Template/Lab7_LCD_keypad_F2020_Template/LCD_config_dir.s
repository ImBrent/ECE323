;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LCD_config_dir.s
;Performs the following initializations:
;	* 
;		- Configures direction of pins 0.1, 0.2, 0.3, 0.4, 0.7 and 1.8 as output
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA program, CODE, READONLY
 EXPORT LCD_config_dir
 INCLUDE LPC11xx.inc
	 
LCD_config_dir
	PUSH {R0-R7, LR}

	LDR R4, =(0xE000E180)		;disable the interrupt for Port0
	MOVS R5, #0x1
	MOVS R5, R5, LSL #31
	STR R5, [R4]
	
	LDR R4, =(0xE000E280)		;clear the pending interrupt, Interrupt Clear-pending Register (ICPR)
	MOVS R5, #0x1
	MOVS R5, R5, LSL #31
	STR R5, [R4]	

	;Set bits 1, 2, 3, 4 of GPIO0 to configure as output pins
	LDR R0, =(GPIO0DIR) ;Get address of GPIO0DIR in R0
	LDR R1, [R0]		;Get current value of GIO0DIR in R1
	MOVS R2, #(0x9E)	;Set bits 1,2,3,4,7 to configure pins as output
	ORRS R1, R2			;Apply bit pattern to existing value of GPIO0DIR
	STR R1, [R0]		;Store updated value back into GPIO0DIR
	
	;Set bit 8 of GPIO1 to configure as output pin
	LDR R0, =(GPIO1DIR)
	LDR R1, [R0]
	LDR R2, =0x100
	ORRS R1, R2
	STR R1, [R0]
	
	POP {R0-R7, PC}
	ALIGN
 END