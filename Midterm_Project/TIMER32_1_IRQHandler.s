;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TIMER32_1_IRQHandler.s
; Interrupt handler for TMR32B1:
;	* Clears interrupt
;	* If MR0 interrupt:
;		* Set data of PIO1_4 to low
;	* If MR3 interrupt:
;		* Set data of PIO1_4 to high
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT TIMER32_1_IRQHandler
 INCLUDE LPC11xx.inc
 
TIMER32_1_IRQHandler
	PUSH{R0-R6,LR}

	;Get IR, clear interrupt
	LDR R0, =TMR32B1IR
	LDR R2, [R0]	;Store interrupts in R2
	MOVS R1, #0x9 ;Interrupts 0 and 3 configured
	STR R1, [R0] ;Clear interrupts
	
	;Check individual interrupts
checkMR0	;Check if MR0 interrupt
	MOVS R6, #1
	ANDS R6, R6, R2
	;If zero flag set, then bit is not set
	BEQ checkMR3

MR0Interrupt
	;To get sync precisely with MR3, delay by 8 clock cycles.
	;PUSH and POP take N + 1 clock cycles, where N is number of arguments
	PUSH{R0-R2}
	POP{R0-R2}

	;On MR0 Interrupt, set the pin to low.
	LDR R0, =GPIO1DATA
	LDR R3, [R0]	;Current data loaded to R3
	MOVS R1, #0x10	;Set bit 4
	BICS R3, R3, R1	;Clear bit 4 from R3
	STR R3, [R0]	;Store updated data

checkMR3
	MOVS R6, #1
	LSRS R2, R2, #3	;Check if bit 3 set
	ANDS R6, R6, R2
	BEQ exit	;If interrupt bit not set, then exit

MR3Interrupt
	;On MR3 Interrupt, set the pin to high
	LDR R0, =GPIO1DATA
	LDR R3, [R0]	;Current data loaded to R3
	MOVS R1, #0x10	;Set bit 4
	ORRS R3, R3, R1	;Set bit 4 in R3
	STR R3, [R0]	;Store updated data
	
exit
	POP{R0-R6,PC}
	ALIGN
	END