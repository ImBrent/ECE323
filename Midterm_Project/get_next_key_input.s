;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;get_next_key_input.s
;Contiuously checks new key flag.
;If flag is set, then it gets the key value from R7 and returns it in R6
;Preconditions:
;	* None
;Postconditions:
;	* New key value is in R6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT get_next_key_input
	 
get_next_key_input
	PUSH {LR}
	
waitForInput
	MOVS R6, R7	;Continuously check new key flag
	LSRS R6, R6, #31
	CMP R6, #1
	BNE waitForInput
	
	;Extract new key from R7
	MOVS R6, #0xF
	ANDS R6, R6, R7	;New key now in R6
	
	POP{PC}
	END