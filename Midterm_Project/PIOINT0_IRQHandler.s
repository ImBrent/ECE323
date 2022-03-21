;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PIOINT0_IRQHandler.s
; Implementation of the interrupt for Port 0.
;
; For any interrupt on port 0, this subroutine will scan the keypad in attempt to
; find a key that is pressed.
; If a key is found: 
;		The key number of that key is returned in the lower 4
;		bits of R7, and the new key flag in R7 is set. The handler will not 
;		return until it detects that all keys are up.
; Otherwise, if a key is not detected, no changes are made. The handler returns
; 		immediately after determining that no key is down.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT PIOINT0_IRQHandler
 IMPORT BusyWait
 IMPORT get_key_num
 IMPORT wait_for_key_release
 IMPORT EnableP0Interrupt
 IMPORT DisableP0Interrupt

PIOINT0_IRQHandler
	PUSH {R3,LR}
	
	BL DisableP0Interrupt
	
	;Give small window for mechanical bouncing during push to settle
	LDR R3, =0x1000
	BL BusyWait	
	
	;Get Key number from keypad
	BL get_key_num ;Place key number in lower 4 bits of R7, sets new key flag

wait
	;Wait for user to release key before leaving interrupt
	BL wait_for_key_release

	;Give a small window in case release detected during bouncing
	LDR R3, =0x1000
	BL BusyWait

	;Enable interrupt
	BL EnableP0Interrupt

	POP{R3,PC}
	ALIGN
	END