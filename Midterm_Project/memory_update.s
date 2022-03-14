;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;memory_update
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 INCLUDE Constants.inc
 EXPORT memory_update

	 
memory_update
	PUSH{R5,R6,LR}
	
	;If flags for R0 and R1 update are set (bits 29 and 30 in R7), then add them to memory
	LDR R5, =0x60000000 ;Bits 29 and 30 set
	MOVS R6, R5			;Apply same value to R6
	ANDS R5, R5, R7		;Check if both are set in R7, store result in R5
	CMP R6, R5
	BNE exit	;If at least one isn't set, then don't update memory
	;Otherwise, go through memory update process

	;Updating memory
	CMP R0, R1	;Check if T0 >= T1
	BLT exit	;Do not update memory if T0 < T1

	STR R0, [memory_pointer, memory_offset]		;Store R0 to memory, increment pointer
	ADDS memory_offset, #element_size
	STR R1, [memory_pointer, memory_offset]		;Store R1 to memory, increment pointer
	ADDS memory_offset, #element_size

	;Prepare for next cycle
	BICS R7, R7, R5 ;Clear the flags
	
	CMP memory_offset, #memory_size	;If offset is outside of range, reset it to 0
	BNE exit	;If not out of range, then skip
	
	MOVS memory_offset, #0	;Reset offset to start
	;Set flag indicating that memory is full (bit 28)
	MOVS R5, #1
	LSLS R5, R5, #28
	ORRS R7, R7, R5		;Set bit 28
	
exit	
	POP{R5,R6,PC}
	END