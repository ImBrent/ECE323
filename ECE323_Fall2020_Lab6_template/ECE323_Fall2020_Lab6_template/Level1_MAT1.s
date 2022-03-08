;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Level1_MAT1.s
;Configures pin1_7 (the pin associated with Timer0 MAT1)
;To blink at a frequency of N Hertz (N is defined below)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT Level1_MAT1
	 
N		EQU		3		;Frequency desired
CLOCK_F	EQU		12000000;12 MHz clock	 
TICKS	EQU		CLOCK_F / (N * 2)	;Number of clock tick before toggling
	
Level1_MAT1
	PUSH{R0-R7,LR}
	
	;Conifgure IOCON_PIO1_7 as follows:
	;	Function: CT32B0_MAT1 (bit 1 set)
	;	Mode	: Pull-up resistor enabled (bit 3 set)
	LDR R0, =(IOCON_PIO1_7)	;Load address of IOCON_PIO1_7
	LDR R1, [R0]			;Load value of current config into R1
	LDR R2, =0xA			;Set bits 1 and 3
	ORRS R1, R2				;Set bits in config.
	STR R1, [R0]			;Store new config.
		
	;Load MR1 of 32-bit Timer 0
	LDR R0, =(TMR32B0MR1)
	LDR R1, =(TICKS)
	STR R1, [R0]
	
	 ; Set the external match register to toggle the pin upon match with MAT1
    LDR R0, =(TMR32B0EMR )
    MOVS R1, #(0xC0) ;Toggle pin 
    STR R1, [R0];	
	
	 ; set the Match Control Register(MCR) to reset the counter when the timer counter matches MAT1
    LDR R0, =(TMR32B0MCR)
    MOVS R1, #(0x10); Reset counter when counter matches MAT1
    STR R1, [R0];
	
	 ; Start the counter by setting bit 0 of Timer Control Register(TCR)
    LDR R0, =(TMR32B0TCR)
    ; Load R1 with all zeros except bit 0 set
    MOVS R1, #(0x1);
    ; Store R1 into TMR32B0TCR. This starts the counter
    STR R1, [R0];

	
	POP {R0-R7,PC}
	END