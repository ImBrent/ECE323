;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;TIMER32_0_IRQHandler
;Interrupt handler for TIMER32B0:
;	* Clears interrupt
;	* If MR0 interrupt:
;		- Set data of PIO1_7 to be low
;	* If MR3 interrupt:
;		- Go to TMR32B0MR3_Interrupt subroutine
;	* If capture pin interrupt:
;		- Go to TMR32B0CAP_INT subroutine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT TIMER32_0_IRQHandler
 INCLUDE LPC11xx.inc
 INCLUDE GlobalVariables.inc
 IMPORT TMR32B0MR3_Interrupt
 IMPORT TMR32B0CAP_INT

memoryBase			RN		6

TIMER32_0_IRQHandler
	PUSH{R0-R6,LR}

	;Get IR and clear interrupt
	LDR R0, =TMR32B0IR
	LDR R2, [R0]	;IR saved into R2
	MOVS R1, #0x1F	;Set all bits
	STR R1, [R0] ;Write all bits to clear interrupt
	
	;Get global memory start from R7
	LDR R6, =0xFFFF0	;Get bits 4-19
	ANDS R6, R6, R7
	LSRS R6, R6, #4	;Shift back into bits 0-15
	LDR R4, =0x10000000
	ADDS memoryBase, R6, R4		;Get correct initial memory location

checkMR0
	;Checking if MR0
	MOVS R0, R2	
	MOVS R1, #1
	ANDS R0, R0, R1
	CMP R0, #1
	BNE checkMR3	;If not equal, then not MR0. Skip.
	
MR0Interrupt
	;Delay by 23 clock cycles to synchronize precisely with MR3 interrupt
	;PUSH and POP take N + 1 clock cycles, where N is number of elements
	PUSH{R0-R6}
	PUSH{R0}
	POP{R0}
	POP{R0-R6}
	NOP
	;;; Delay over
	
	;If MR0, then set output of PIO1_7 to be low
	LDR R0, =GPIO1DATA
	LDR R1, [R0]
	MOVS R5, #0x80
	BICS R1, R1, R5	;Set bit 7 to be low
	STR R1, [R0]
	
checkMR3	
	;Check bit 3 (MR3)
	MOVS R0, R2
	MOVS R1, #1
	LSRS R0, R0, #3	;Set bit 3
	ANDS R0, R0, R1	
	CMP R0, #1
	BNE checkCapture ;If not set, then not MR3. Skip.
	
	;Otherwise, interrupt on MR3. Increment counters.
MR3Interrupt
	BL TMR32B0MR3_Interrupt

checkCapture
	;Checking bit 4 (capture event)
	LSRS R2, R2, #4
	CMP R2, #1
	BNE exit ;If not set, then quit interrupt

captureEvent	
	BL TMR32B0CAP_INT

exit

	POP{R0-R6,PC}
	ALIGN
	END
