;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;GlobalVariables.inc
;A file containing the byte offset of all global variables, as well as the total
;amount of memory that must be allocated to global variables.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

global_memory_size	EQU	24
	
_T0							EQU	8
_T1							EQU	12
_capture_time_pos			EQU 4
_capture_time_neg			EQU 0
_counter1					EQU	16	;counter corresponding to number of overflows before neg edge recorded
_counter0					EQU	20	;counter corresponding to number of overflows before pos edge recorded
	
	END