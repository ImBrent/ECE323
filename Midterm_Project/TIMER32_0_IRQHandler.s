;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;TIMER32_0_IRQHandler
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT TIMER32_0_IRQHandler
 INCLUDE LPC11xx.inc
 INCLUDE GlobalVariables.inc
 IMPORT print_string
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT LCD_command
 IMPORT TMR32B0MR3_Interrupt

CR0					RN		4
timestamp1			RN		2
timestamp2			RN		3
T1					RN		1
T0					RN		0
memoryBase			RN		6

TIMER32_0_IRQHandler
	PUSH{R0-R6,LR}

	;Get IR and clear interrupt
	LDR R0, =TMR32B0IR
	LDR R2, [R0]
	MOVS R1, #0x18	;Set bit 3 and 4
	STR R1, [R0] ;Write to bit 3,4 to clear CAP interrupt
	
	;Get global memory start from R7
	LDR R6, =0xFFFF0	;Get bits 4-19
	ANDS R6, R6, R7
	LSRS R6, R6, #4	;Shift back into bits 0-15
	LDR R4, =0x10000000
	ADDS memoryBase, R6, R4		;Get correct initial memory location
	
	;Determine which interrupt occured
	;Checking bit 4 (capture event)
	LSRS R2, R2, #4
	CMP R2, #1
	BEQ captureEvent ;If 1, then capture event
	;Otherwise, interrupt on MR3. Increment counters.
MR3Interrupt
	BL TMR32B0MR3_Interrupt
	B exit
captureEvent	
	;Get timestamp3 from CR0
	LDR R0, =TMR32B0CR0
	LDR CR0, [R0]	
	
	;Read CCR to determine whether pos or negative edge event
	LDR R5, =TMR32B0CCR
	LDR R3, [R5]
	;Check if bit 0 is set. If set, then positive edge
	MOVS R5, #0x1
	ANDS R5, R5, R3		
	
	CMP R5, #0x1	;If bit 0 is set, posedge event. Otherwise, negedge event.
	BNE negEdge
posEdge
;If posedge event: 
;	* Read timestamp 1 and 2 from memory
;	* Record CR0 into memory
;	* Compute T0, T1
;	* Store T0 and T1 into memory
;	* Set capture flag
;	* Configure CCR to capture falling edge

	LDR timestamp2, [R6]	;Get timestamp2
	
	MOVS R1, #_capture_time_pos
	SUBS R1, R6, R1	;Get memory location where timestamp1 is stored
	LDR timestamp1, [R1]	;Get timestamp1

	;Record timestamp3 into memory location of timestamp1 for next iteration
	STR CR0, [R1]

	;Load counter1 from memory
	MOVS R5, #_counter1
	SUBS R5, R6, R5
	LDR R5, [R5]	;Counter1 in R5

computeT1	
	;Check if counter1 > 0 (in this case, timer reset in between)
	CMP R5, #0
	BEQ noReset1
reset1
	;If reset occured, then need contents of MR3 to make correction
	LDR R0, =TMR32B0MR3
	LDR R1, [R0]	;MR3 in R1
	
	;T1 = counter * (MR3+1) + timestamp2 - timestamp1 - 1
	ADDS R1, #1
	MULS R5, R1, R5
	ADDS R5, R5, timestamp2
	SUBS T1, R5, timestamp1
	SUBS T1, #1
	B computeT0
noReset1
	;T1 = timestamp2 - timestamp1
	SUBS T1, timestamp2, timestamp1
	SUBS T1, #1

computeT0
	;Load counter0 from memory
	MOVS R5, #_counter0
	SUBS R5, R6, R5
	LDR R5, [R5]	;Counter0 in R5	

	;Check if counter0 > 0 (in this case, time reset in between)
	CMP R5, #0
	BEQ noReset2
reset2
	;If reset occured, then need contents of MR3 to make correction
	LDR R0, =TMR32B0MR3
	LDR R0, [R0]	;MR3 in R0
	
	;T0 = counter * (MR3 + 1) + timestamp3 - timestamp1
	ADDS R0, #1
	MULS R0, R5, R0
	ADDS R0, R0, CR0
	SUBS T0, R0, timestamp1
	B store_to_memory
noReset2
	SUBS T0, CR0, timestamp1
	SUBS T0, #1
	
store_to_memory

	;Store T0 and T1 to memory
	MOVS R5, #_T0
	SUBS R5, R6, R5
	STR T0, [R5]
	
	MOVS R5, #_T1
	SUBS R5, R6, R5
	STR T1, [R5]
	
set_capture_flag
	;Set bit 27 of R7
	LDR R5, =0x08000000
	ORRS R7, R7, R5
	
clear_counters
	MOVS R5, R6
	SUBS R5, R5, #_counter1
	MOVS R4, #0
	STR R4, [R5]
	
	MOVS R5, R6
	SUBS R5, R5, #_counter0
	STR R4, [R5]

configure_CCR ;Configure CCR for neg edge event
	LDR R5, =TMR32B0CCR
	LDR R6, [R5]
	MOVS R0, #0x6	;Bit 1,2 set
	STR R0, [R5]

	B exit
negEdge
	;Record CR0 into memory. R6 has memory base already.
	SUBS R5, R6, #_capture_time_neg
	STR CR0, [R6]
	
	;Configure CCR for pos edge event
	LDR R5, =TMR32B0CCR
	LDR R6, [R5]
	MOVS R0, #0x5	;Bit 0,2 set
	STR R0, [R5]

exit

	POP{R0-R6,PC}
	ALIGN
	END
