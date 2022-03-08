;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LCD_config_dir.s
;Performs the following initializations:
;	* 
;		- Configures direction of pins 0.1, 0.2, 0.3, 0.4, 0.7 and 1.8 as output
;		- Disable the P0's interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA program, CODE, READONLY
 EXPORT LCD_config_dir
 INCLUDE LPC11xx.inc
 IMPORT DisableP0Interrupt
	 
LCD_config_dir
	PUSH {R0-R7, LR}	

	;Disable interrupt
	BL DisableP0Interrupt

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