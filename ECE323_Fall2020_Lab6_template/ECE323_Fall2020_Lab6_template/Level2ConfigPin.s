;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Level2ConfigPin
;Configs PIO1_5 as GPIO, sets direction as output, initializes data to 0.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, READONLY, CODE
 INCLUDE LPC11xx.inc
 EXPORT Level2ConfigPin	 

Level2ConfigPin
	PUSH {R0-R7, LR}
	
	;Configure PIO1_5 as GPIO.
	LDR R0, =IOCON_PIO1_5
	LDR R1, [R0]
	LDR R2, =0xFFFFFFF8		;Clear bits 0 to 2 to configure as GPIO
	ANDS R1, R1, R2
	STR R1, [R0]
	
	;Set direction as output
	LDR R0, =GPIO1DIR
	LDR R1, [R0]
	LDR R2, =0x20		;Set bit 5
	ORRS R2, R2, R1
	STR R2, [R0]
	
	;Initialize data of pin as 0
	LDR R0, =GPIO1DATA
	LDR R1, [R0]
	LDR R2, =0xFFFFFFDF	;Clear bit 5
	ANDS R2, R2, R1
	STR R2, [R0]
	

	POP {R0-R7, PC}
	END