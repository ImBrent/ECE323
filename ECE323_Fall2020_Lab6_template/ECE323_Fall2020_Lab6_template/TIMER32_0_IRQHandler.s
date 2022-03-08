 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT TIMER32_0_IRQHandler
	 	 
IR	RN	2
		 
TIMER32_0_IRQHandler
	PUSH {R0-R7, LR}
	;Stop the timer
	LDR R7, =(TMR32B0TCR)
	MOVS R6, #0				;0 to stop timer
	STR R6, [R7]
	;Timer stopped

	;; Clear interrupt by writing to Interrupt Register(TMR32B0IR) see datasheet for this
	LDR R0, =TMR32B0IR
	LDR IR, [R0]	;Get contents of IR before clearing
	LDR R1, =0x3	;Write bits 0 and 1 to clear interrupts 0 and 1 (could probably do this better)
	STR R1, [R0]
	
	;Assuming only one IR bit is going to be set at a time. If more than one, then something unexpected happened/do nothing
	
	;Loading GPIODATA into R3
	LDR R0, =GPIO1DATA
	LDR R3, [R0]

checkMR0
	;If MR0 set, then set output to low
	CMP IR, #0x1	
	BNE checkMR1
	
	LDR R1, =0xFFFFFFDF	;Clearing bit 5
	ANDS R1, R1, R3
	STR R1, [R0]
	BL done

checkMR1
	;If MR1 set, then set output to high
	CMP IR, #0x2
	BNE done
	
	LDR R1, =0x20		;Setting bit 5
	ORRS R1, R1, R3
	STR R1, [R0]
	
done
	;Start the timer. R7 already has TCR
	MOVS R6, #0x1		;1 starts timer
	STR R6, [R7]	

	POP {R0-R7, PC}
	END