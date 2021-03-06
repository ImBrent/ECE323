 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT Level1

CLOCKFREQ 	EQU 12000000		;Clock frequency
CLOCKCYCLES EQU 4			;4 cycles per loop iteration. 3 for branch, 1 for addition (pg. 520-521)
BLINKFREQ 	EQU 1			;The frequency needed to blink LEDs at (in Hz)
				;Approximate num ticks before inverting output pin.
NUMTICKS  	EQU CLOCKFREQ / (BLINKFREQ * 2 * CLOCKCYCLES)
	
Level1
	PUSH{R0-R7,LR}

main_loop

	; Set the initial output on PIO1_5, PIO1_6, PIO1_7 as high
   
    ; Load the address of GPIO1DATA(last unmasked address base+0x3FFC) into R0
    LDR R0, =(GPIO1DATA); GPIO1DATA Base + 0x3FFC, address 0x5001 3FFC, Table 174, page 192
    ; Load the value (1) at bit location 5, 6 and 7 to set PIO1_5, PIO1_6, PIO1_7 high
    MOVS R1, #(0x7);
	
	MOVS R1, R1, LSL #5
    ; Store the value of R1 into GPIO1DATA
    STR R1, [R0];
	
	;----delay-----
	LDR R1, =(NUMTICKS)
delay1
	SUBS R1, #1
	BNE delay1
    ; Load the value (0) at bit location 5, 6 and 7 to set PIO1_5, PIO1_6, PIO1_7 low
    MOVS R1, #((0x0)) ;
	MOVS R1, R1, LSL #5
    ; Store the value of R1 into GPIO1DATA
    STR R1, [R0];
	
	LDR R1, =(NUMTICKS)
delay2
	SUBS R1, #1
	BNE delay2
	
	B main_loop

	
	POP {R0-R7,PC}
	END