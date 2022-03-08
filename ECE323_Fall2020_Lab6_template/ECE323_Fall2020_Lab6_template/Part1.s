 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT Part1
	 
N		EQU		3		;Frequency desired
CLOCK_F	EQU		12000000;12 MHz clock	 
TICKS	EQU		CLOCK_F / (N * 2)	;Number of clock tick before toggling
Part1
	PUSH{R0-R7,LR}

	;Conifgure IOCON_PIO1_6 as follows:
	;	Function: CT32B0_MAT0 (bit 1 set)
	;	Mode	: Pull-up resistor enabled (bit 3 set)
	; Load the address of IOCON_PIO1_6 into R0
    LDR R0, =(IOCON_PIO1_6)
    ; Load the value of IOCON_PIO1_6 into R1
    LDR R1, [R0];
	; Load R2 with bits 1 and 3 set
    LDR R2, =(0xA);
    ; Apply AND operation between R1 and R2
    ORRS R1, R2;
    ; Store the new value of R1 into IOCON_PIO1_6
    STR R1, [R0];
		
	; Load Match Register0(TMR32B0MR0) of 32-bit counter0(TMR32B0 or CT32B0)
    LDR R0, =(TMR32B0MR0); TMR32B0MR0, address 0x4001 4018
    LDR R1, =(TICKS)
    ; Store the value of R1 into TMR32B0MR0
    STR R1, [R0];
	
	 ; Set the pin of external match register to toggle the pin
    LDR R0, =(TMR32B0EMR )
    ; Load R1 with all zeros except bit 0 set
    MOVS R1, #(0x30);Toggle pin
    ; Store R1 into TMR32B0TCR. This starts the counter
    STR R1, [R0];	
	
	 ; set the Match Control Register(MCR) to reset the counter when the timer counter matches Match register 0
    LDR R0, =(TMR32B0MCR)
    MOVS R1, #(0x2);
    ; Store R1 into TMR32B0TCR. This starts the counter
    STR R1, [R0];
	
	 ; Start the counter by setting bit 0 of Timer Control Register(TCR)
    LDR R0, =(TMR32B0TCR)
    ; Load R1 with all zeros except bit 0 set
    MOVS R1, #(0x1);
    ; Store R1 into TMR32B0TCR. This starts the counter
    STR R1, [R0];
	
	POP {R0-R7,PC}
	END