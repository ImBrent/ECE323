 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT Level2
 IMPORT delay

CLOCKFREQ 		  EQU 3000000	;Clock frequency is observed to be 3 MHz? Doesn't seem right. Make generically, fix later if need
HALFSECTICKS	  EQU (CLOCKFREQ / 2)
	
LEDPATTERN0		  EQU	0x00
LEDPATTERN1		  EQU	0x20
LEDPATTERN2		  EQU	0x60
LEDPATTERN3		  EQU	0xE0
	
Level2
	PUSH{R0-R7,LR}

main_loop
	
	; Set the initial output on PIO1_5, PIO1_6, PIO1_7 as low
   
    ; Load the address of GPIO1DATA(last unmasked address base+0x3FFC) into R0
    LDR R0, =(GPIO1DATA); GPIO1DATA Base + 0x3FFC, address 0x5001 3FFC, Table 174, page 192
    ; Load the value 0 at bit location 5, 6 and 7 to set PIO1_5, PIO1_6, PIO1_7 low
    MOVS R1, #(LEDPATTERN0);
	
	MOVS R1, R1, LSL #5
    ; Store the value of R1 into GPIO1DATA
    STR R1, [R0];
	
	;Blink LEDs in pattern
	LDR R1, =(HALFSECTICKS) ;number of ticks per half second. Used in delay subroutine call
blink
	BL delay	;Wait half second
	;Display pattern 1
	
	LDR R0, =(GPIO1DATA)
	LDR R2, =(LEDPATTERN1)
	STR R2, [R0]			;Store pattern in output
	BL delay ;Wait half second
	;Display pattern 2

	LDR R0, =(GPIO1DATA)
	LDR R2, =(LEDPATTERN2)
	STR R2, [R0]			;Store pattern in output
	BL delay ;Wait half second
	;Display pattern 3
			
	LDR R0, =(GPIO1DATA)
	LDR R2, =(LEDPATTERN3)
	STR R2, [R0]			;Store pattern in output
	BL delay ;Wait half second
	;Display pattern 2
	
	LDR R0, =(GPIO1DATA)
	LDR R2, =(LEDPATTERN2)
	STR R2, [R0]			;Store pattern in output
	BL delay ;Wait half second
	;Display pattern 1

	LDR R0, =(GPIO1DATA)
	LDR R2, =(LEDPATTERN1)
	STR R2, [R0]			;Store pattern in output
	BL delay ;Wait half second
	;Repeat pattern
	
	LDR R0, =(GPIO1DATA)
	LDR R2, =(LEDPATTERN0)
	STR R2, [R0]	;Store pattern in output	
	BL delay ;Wait half second
	
	BL blink

	
	B main_loop

	
	POP {R0-R7,PC}
	END