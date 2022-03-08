;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Level2.s
;Controls PIO1_5 to output at varying frequencies and duty cycles
;Done via timers and interrupts.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 INCLUDE LPC11xx.inc
 IMPORT Level2ConfigPin
 EXPORT Level2
	
FREQUENCY	EQU		2					;Desired frequency (Hz)
CLOCK_F		EQU		12000000			;Clock frequency
DUTY		EQU		75					;Positive duty cycle %
CYCLE_LEN	EQU		CLOCK_F / FREQUENCY	;Number of ticks for each LED period
HIGH		EQU		CYCLE_LEN * DUTY / 100;Number of ticks LED high for

Level2
	PUSH {R0-R7, LR}
	
	;Configure PIO1_5 as GPIO. Set direction as output.
	BL Level2ConfigPin

	;Configure match registers 0 and 1 of TMR32B0
    LDR R0, =(TMR32B0MR0) ;MR0 configured for high period
	LDR R1, =HIGH
	STR R1, [R0]
	
	LDR R0, =(TMR32B0MR1) ;MR1 configured for total period
	LDR R1, =CYCLE_LEN
	STR R1, [R0]
	
	;Configure MCR to:
	;	For MR0: Interrupt (bit 0 set)
	;	For MR1: Interrupt and reset timer (bit 3 and 4 set)
	LDR R0, =(TMR32B0MCR)
    MOVS R1, #(0x19);
    STR R1, [R0];
	
	;Configure TCR to enable counting
	LDR R0, =TMR32B0TCR
	MOVS R1, #1	;Bit 0 set enables counting
	STR R1, [R0]
	
	POP {R0-R7, PC}
	END