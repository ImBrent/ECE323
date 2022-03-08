 AREA PROGRAM, CODE, READONLY
 INCLUDE LPC11xx.inc
 EXPORT Level3
	 
FREQUENCY	EQU		4					;Desired frequency(Hz)
CLOCK_F		EQU		12000000			;Clock frequency
DUTY		EQU		20					;Positive duty cycle %
CYCLE_LEN	EQU		CLOCK_F / FREQUENCY	;Number of ticks for each LED period
HIGH		EQU		CYCLE_LEN * DUTY / 100;Number of ticks LED high for
LOW			EQU		CYCLE_LEN - HIGH		  ;Number of ticks LED low for
	 
Level3
	PUSH{R0-R7,LR}

	;Configure IOCON_PIO1_6 as follows:
	;	Function: CT32B0_MAT0 (Bit 1 set)
	;	Mode:	  Pull-up resistor enabled (bit 4 set)
	LDR R0, =(IOCON_PIO1_6)	;Load address of IOCON_PIO1_7
	LDR R1, [R0]			;Load value of current config into R1
	LDR R2, =0x12			;Set bits 1 and 4
	ORRS R1, R2				;Set bits in config.
	STR R1, [R0]			;Store new config.		

	;Load MR0 of 32-bit Timer 0. Time in PWM that output changes from low to high
	LDR R0, =(TMR32B0MR0)
	LDR R1, =(LOW)
	STR R1, [R0]

	;Load MR1 of 32-bit Timer 0. Sets PWM cycle. 
	LDR R0, =(TMR32B0MR1)
	LDR R1, =(CYCLE_LEN)
	STR R1, [R0]

	;Configure MCR:
	;MR0: No configuration needed
	;MR1: Reset timer on match (set bit 4)
    LDR R0, =(TMR32B0MCR)
    MOVS R1, #(0x10); Reset counter when counter matches MAT1
    STR R1, [R0];
	
	;Config PWM:
	;	Configure MAT0 as PWM output (Set bit 0)
	LDR R0, =(TMR32B0PWMC)
	MOVS R1, #(0x1)
	STR R1, [R0]
	
	;Config TCR:
	;	Start counter: Set bit 0
	LDR R0, =(TMR32B0TCR)
	MOVS R1, #(0x1)
	STR R1, [R0]	

	POP{R0-R7,PC}
	END