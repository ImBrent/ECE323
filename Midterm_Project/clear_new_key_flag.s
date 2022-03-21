;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;clear_new_key_flag
;Clears new key flag stored in R7
;Preconditions:
;	* None
;Postconditions:
;	* Clears new key flag (Bit 31 of R7)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT clear_new_key_flag
	 
clear_new_key_flag
	PUSH{R6,LR}
	
	MOVS R6, #1
	LSLS R6, R6, #31
	BICS R7, R7, R6		;Clear bit 31
	
	POP{R6,PC}
	END