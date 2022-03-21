;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LCD_config_dir.s
;Configures the direction of GPIO pins needed to write to LCD
;Preconditions:
;	* PIO0 pins 1,2,3,4,7 and PIO1_8 are configured as GPIO
;Postconditions:
;	* Configures direction of pins 0.1, 0.2, 0.3, 0.4, 0.7 and 1.8 as output
;	* Disable P0 interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA program, CODE, READONLY
 EXPORT LCD_config_dir
 INCLUDE LPC11xx.inc
 IMPORT DisableP0Interrupt
	 
LCD_config_dir
	PUSH {R0-R2, LR}	

	;Disable interrupt
	BL DisableP0Interrupt

	;Set bits 1, 2, 3, 4 of GPIO0 to configure as output pins
	LDR R0, =(GPIO0DIR) ;Get address of GPIO0DIR in R0
	LDR R1, [R0]		;Get current value of GIO0DIR in R1
	MOVS R2, #(0x1E)	;Set bits 1,2,3,4 to configure pins as output
	ORRS R1, R2			;Apply bit pattern to existing value of GPIO0DIR
	STR R1, [R0]		;Store updated value back into GPIO0DIR
	
	;Set bit 0, 8 of GPIO1 to configure as output pin
	LDR R0, =(GPIO1DIR)
	LDR R1, [R0]
	LDR R2, =0x101
	ORRS R1, R2
	STR R1, [R0]
	
	POP {R0-R2, PC}
	ALIGN
 END