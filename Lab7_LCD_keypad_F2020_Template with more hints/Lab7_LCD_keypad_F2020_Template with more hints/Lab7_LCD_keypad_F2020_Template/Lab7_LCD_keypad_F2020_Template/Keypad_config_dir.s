;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Keypad_config_dir.s
;Performs the following initializations:
;	* 
;		- Configures direction of pins 0.1, 0.2, 0.3, 0.4, as input
;		- Enables P0's interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA program, CODE, READONLY
 EXPORT Keypad_config_dir
 IMPORT EnableP0Interrupt
 INCLUDE LPC11xx.inc
	 
Keypad_config_dir
	PUSH {R0-R7, LR}

	;Set bits 1, 2, 3, 4 of GPIO0 to configure as input pins
	LDR R0, =(GPIO0DIR) ;Get address of GPIO0DIR in R0
	LDR R1, [R0]		;Get current value of GIO0DIR in R1
	LDR R2, =(0xFFFFFE1)		;Clear bits 1,2,3,4 to configure pins as input
	ANDS R1, R2			;Apply bit pattern to existing value of GPIO0DIR
	STR R1, [R0]		;Store updated value back into GPIO0DIR

	LDR  R4, =(GPIO1DATA)		;clear the row
	LDR R5, =(0x0)
	STR  R5, [R4]

	BL EnableP0Interrupt	;Enable the interrupt

	POP {R0-R7, PC}
	ALIGN
 END